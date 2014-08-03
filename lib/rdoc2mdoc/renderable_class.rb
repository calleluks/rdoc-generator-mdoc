require "rdoc2mdoc/comment"

module Rdoc2mdoc
  class RenderableClass
    def initialize(rdoc_class)
      @rdoc_class = rdoc_class
    end

    def name
      rdoc_class.full_name
    end

    def short_description
      comment.first_paragraph
    end

    def description
      comment.mdoc_formatted_content
    end

    private

    def comment
      @comment ||= Comment.new(rdoc_class.comment)
    end

    attr_reader :rdoc_class
  end
end
