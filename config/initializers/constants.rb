class Constants < ActiveRecord::Base

  def self.model
    "curie"
  end

  def self.query_embeddings_model
    "text-search-" + self.model + "-query-001"
  end

  def self.max_section_len
    500
  end

  def self.separator
    "\n* "
  end

  def self.question_prefix
    "\n\n\nQ: "
  end

  def self.answer_prefix
    "\n\nA: "
  end

  def self.separator_len
    3
  end

  def self.openai_api_key
    ENV.fetch("OPENAI_API_KEY")
  end

  def self.completions_model
    "text-davinci-003"
  end

  def self.pages_csv_filename
    'book.pdf.pages.csv'
  end

  def self.embeddings_csv_filename
    'book.pdf.embeddings.csv'
  end

  def self.header_text
    "Sahil Lavingia is the founder and CEO of Gumroad, and the author of the book The Minimalist Entrepreneur (also known as TME). These are questions and answers by him. Please keep your answers to three sentences maximum, and speak in complete sentences. Stop speaking once your point is made.\n\nContext that may be useful, pulled from The Minimalist Entrepreneur:\n"
  end

  def self.all_question_answer_text
    File.readlines('my_questions.txt')
  end

  def self.completion_api_params
    {
      # We use temperature of 0.0 because it gives the most predictable, factual answer.
      "temperature": 0.0,
      "max_tokens": 150,
      "model": self.completions_model
    }
  end

end #Constants
