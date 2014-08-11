require "rdoc"
require "rdoc/generator/mdoc/formatter"

class RDoc::Generator::Mdoc
  class Comment
    def initialize(comment)
      case comment
      when RDoc::Markup::Document
        @rdoc_document = comment
      when RDoc::Comment
        @markup = comment.text
      when String
        @markup = comment
      else
        raise "Can't handle input of class: #{comment.class}"
      end
    end

    def first_paragraph
      paragraph = rdoc_document.parts.find do |part|
        part.is_a? RDoc::Markup::Paragraph
      end

      if paragraph
        paragraph.text
      else
        ""
      end
    end

    def mdoc_formatted_content
      rdoc_document.accept formatter
    end

    private

    attr_reader :markup

    def rdoc_document
      @rdoc_document ||= RDoc::Markup.parse(markup)
    end

    def formatter
      Formatter.new
    end
  end
end
