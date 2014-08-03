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

    attr_reader :rdoc_class

    def markup
      rdoc_class.
        comment_location.
        map { |rdoc_comment, _| rdoc_comment.text }.
        join("\n")
    end

    def comment
      @comment ||= Comment.new(markup)
    end
  end
end
