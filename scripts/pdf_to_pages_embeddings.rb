require 'dotenv'
require 'optparse'
require 'pdf-reader'
require 'dotenv'
require 'daru'
require 'csv'
require 'openai'
require 'tokenizers'

class Constants
  def self.model
    "curie"
  end

  def self.doc_embeddings_model
    "text-search-" + Constants.model + "-doc-001"
  end

  def self.openai_api_key
    Dotenv.load('.env')
    ENV.fetch("OPENAI_API_KEY")
  end
end


def get_doc_embedding(text)
    OpenAI.configure do |config|
      config.access_token = Constants.openai_api_key
    end

    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: Constants.doc_embeddings_model,
        input: text
      }
    )

    response.dig("data", 0, "embedding")
end

def count_tokens(text)
  tokenizer = Tokenizers.from_pretrained("gpt2")
  tokenizer.encode(text).tokens.size
end

def extract_page_of(page_index, page_text)
  if page_text.length < 1
    puts "empty page"
    return []
  end

  content = page_text.split.join(" ")
  token_count = count_tokens(content)+4
  outputs = ["Page " + page_index.to_s, content, token_count.to_int]
  return outputs
end

def compute_doc_embeddings(data_frame)
  embeddings = Hash.new
  data_frame.each_row_with_index do |row, index|
    embeddings[index] = get_doc_embedding(row[:content])
    end
    return embeddings
end

def extract_page_from_pdf(pdf_file_path)
  reader = PDF::Reader.new(pdf_file_path)
  result = []
  i = 1
  titles= []
  contents = []
  tokens = []
  reader.pages.each_with_index do |page, index|
    print "Extracting page ", index + 1, "\n"
    extract = extract_page_of(index + 1, page.text)
    titles.push(extract[0])
    contents.push(extract[1])
    tokens.push(extract[2].to_i)
    # break to debug script (for testing)
    # if index > 2
    #   break
    # end
  end #end reader.pages.each_index
  [titles, contents, tokens]
end

def write_data_frame_to_csv(df, csv_file_path)
  csv_file_path = 'book2.pdf.pages.csv'
  print "Writing ", csv_file_path, "\n"
  writer = ::CSV.open(csv_file_path, 'w')
  df.each_row do |row|
    writer << row.to_a
  end
  writer.close
end  

def write_doc_embeddings(embeddings, csv_file_path)
  print "Writing ", csv_file_path, "\n"
  writer = ::CSV.open(csv_file_path, 'w')
  headerRow = []
  headerRow.append("title")
  (0..4095).each do |n|
    headerRow.append(n)
  end
  writer << headerRow
  
  index = 1
  embeddings.each do |key, value|
    writer << ["Page " + index.to_s, value.to_a.join("")]
    index = index + 1
  end
  writer.close
end  




options = {}
optparse = OptionParser.new do |opts|
  opts.on('--pdf', '--pdf PDF_FILE', 'Path to PDF file') do |o|
    options[:pdf] = o
  end
end

optparse.parse!

# check if we have correct arguments
raise OptionParser::MissingArgument if options[:pdf].nil?

pdf_file_path = options[:pdf]
unless  File.file?(pdf_file_path)
  puts pdf_file_path + " Cannot open '" + pdf_file_path + "'"
  exit(1)
end

titles, contents, tokens = extract_page_from_pdf(pdf_file_path)

puts "Creating DataFrame..."
data_frame = Daru::DataFrame.new({title: titles, content: contents, tokens: tokens},
order: [:title, :content, :tokens]
)

data_frame = data_frame.where(data_frame[:tokens].lt(16))

write_data_frame_to_csv(data_frame, 'book2.pdf.pages.csv')

puts "Computing doc embeddings..."
doc_embeddings = compute_doc_embeddings(data_frame)

write_doc_embeddings(doc_embeddings, 'book2.pdf.embeddings.csv')
