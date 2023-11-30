require './config/initializers/constants'

module Services
  class AskService
    # ...
    def initialize(question)
      @@question = check_question(question)
    end

    def question
      @@question
    end

    def find_answer
      df = Daru::DataFrame.from_csv(Constants.pages_csv_filename)
      document_embeddings = load_embeddings(Constants.embeddings_csv_filename)
      answer_query_with_context(df, document_embeddings)
    end

      private
        def check_question(question)
          question = question.strip
          unless question.end_with? "?"
            question = question + " ?"
          end
          question
        end

      def answer_query_with_context(data_frame, document_embeddings)
        prompt, context = construct_prompt(
        data_frame,
        document_embeddings,
        )

      new_client = OpenAI::Client.new(access_token: Constants.openai_api_key)

      response = new_client.chat(
        parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: [{ role: "user", content: prompt.to_s}], # Required.
          temperature: 0.0,
        })
      [response.dig("choices", 0, "message", "content"), context]

      end


    def load_embeddings(fname)

      df = Daru::DataFrame.from_csv(fname)
      max_dim = 0
      df.each_row do |r|
        max_dim = r.size - 1
        break
      end

      #print "max_dim =", max_dim, "\n"
      embeddings = Hash.new
      df.each_row do |row|
        embeddings[row['title']] = row[1..max_dim]
      end

      embeddings
    end

    def construct_prompt(data_frame, context_embeddings)
      most_relevant_sections = order_document_sections_by_query_similarity(context_embeddings)

      chosen_sections = []
      chosen_sections_len = 0
      chosen_sections_indexes = []

      most_relevant_sections.each do | doc_section|
        section_index = doc_section[1]
        data_frame.filter(:row) do |row|
          if row['title'] == section_index
            document_section = row
            chosen_sections_len += document_section['tokens'] + 3 #Constants.separator_len
            if chosen_sections_len > Constants.max_section_len
              space_left = Constants.max_section_len - chosen_sections_len - Constants.separator.size
              chosen_sections.append(Constants.separator.to_s + document_section['content'][0..space_left + -1].to_s)
              chosen_sections_indexes.append(section_index.to_s)
              break
            end
            chosen_sections.append(Constants.separator + document_section['content'].to_s)
            chosen_sections_indexes.append(section_index.to_s)
          end
        end
      end


      header = Constants.header_text
      all_questions = Constants.all_question_answer_text
      [header + chosen_sections.join("") + all_questions.join("") + Constants.question_prefix + @@question + Constants.answer_prefix, chosen_sections.join("") ]

    end


    def get_embedding(model)
      OpenAI.configure do |config|
        config.access_token = Constants.openai_api_key
      end

      client = OpenAI::Client.new
      response = client.embeddings(
        parameters: {
          model: model,
          input: @@question
        }
      )

      response.dig("data", 0, "embedding")
    end


    def vector_similarity(x, y)
      dot_p = 0
      x.each_index do |i|
        dot_p += x[i].to_f * y[i].to_f
      end
      dot_p
    end

    def order_document_sections_by_query_similarity(contexts)
      query_embedding = get_embedding(Constants.query_embeddings_model)
      #contexts is of type hash map.
      document_similarities = []
      contexts.each do |doc_index, doc_embedding|
        similarity = vector_similarity(query_embedding, doc_embedding)
        document_similarities.push([similarity, doc_index])
      end
      document_similarities.sort.reverse
    end


  end
end