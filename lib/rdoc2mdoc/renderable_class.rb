require "rdoc2mdoc/comment"
require "rdoc2mdoc/section"
require "rdoc2mdoc/unknown_class"

module Rdoc2mdoc
  class RenderableClass
    def initialize(rdoc_class, mandb_section)
      @rdoc_class = rdoc_class
      @mandb_section = mandb_section
    end

    def name
      rdoc_class.full_name
    end

    def superclass
      if rdoc_class.superclass.is_a? String
        UnknownClass.new(rdoc_class.superclass)
      else
        RenderableClass.new(rdoc_class.superclass, mandb_section)
      end
    end

    def short_description
      truncate(comment.first_paragraph, 50)
    end

    def description
      comment.mdoc_formatted_content
    end

    def sections
      @sections ||=
        rdoc_class.
        each_section.
        map do |rdoc_section, rdoc_constants, rdoc_attributes|
          Section.new(
            rdoc_section,
            rdoc_constants,
            rdoc_attributes,
            mandb_section,
          )
        end
    end

    def reference
      "#{name} #{mandb_section}"
    end

    private

    attr_reader :rdoc_class, :mandb_section

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
