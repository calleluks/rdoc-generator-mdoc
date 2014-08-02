class Document
  def initialize(markup)
    @markup = markup
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
