class Document
  def initialize(markup)
    @markup = markup
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

  def accept(formatter)
    rdoc_document.accept formatter
  end

  private

  attr_reader :markup

  def rdoc_document
    @rdoc_document ||= RDoc::Markup.parse(markup)
  end
end
