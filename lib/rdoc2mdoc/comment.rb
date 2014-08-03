require "rdoc2mdoc/document"
require "rdoc2mdoc/formatter"

module Rdoc2mdoc
  class Comment
    def initialize(rdoc_comment_or_markup)
      @document = Document.new(markup(rdoc_comment_or_markup))
    end

    def mdoc_formatted_content
      document.accept formatter
    end

    def first_paragraph
      document.first_paragraph
    end

    private

    attr_reader :document

    def formatter
      Formatter.new
    end

    def markup(rdoc_comment_or_markup)
      if rdoc_comment_or_markup.is_a? String
        rdoc_comment_or_markup
      else
        rdoc_comment_or_markup.text
      end
    end
  end
end
