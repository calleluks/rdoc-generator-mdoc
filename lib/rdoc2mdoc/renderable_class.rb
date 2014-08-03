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
      truncate(comment.first_paragraph, 50)
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

    def truncate(string, max_length)
      if string.length > max_length
        omission = "..."
        length_with_room_for_omission = max_length - omission.length
        stop = string.rindex(/\s/, length_with_room_for_omission) ||
          length_with_room_for_omission
        string[0...stop] + omission
      else
        string
      end
    end
  end
end
