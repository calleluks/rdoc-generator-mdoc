require "rdoc2mdoc/comment"
require "rdoc2mdoc/section"
require "rdoc2mdoc/unknown_module"

module Rdoc2mdoc
  class Module
    attr_reader :mandb_section

    def initialize(rdoc_module, mandb_section)
      @rdoc_module = rdoc_module
      @mandb_section = mandb_section
    end

    def name
      rdoc_module.full_name
    end

    def reference
      "#{name} #{mandb_section}"
    end

    def short_description
      truncate(comment.first_paragraph, 50)
    end

    def description
      comment.mdoc_formatted_content
    end

    def extended_modules
      @extended_modules ||= decorate_rdoc_mixins(rdoc_module.extends)
    end

    def included_modules
      @included_modules ||= decorate_rdoc_mixins(rdoc_module.includes)
    end

    def sections
      @sections ||=
        rdoc_module.
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

    private

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

    def comment
      @comment ||= Comment.new(markup)
    end

    def markup
      rdoc_module.
        comment_location.
        map { |rdoc_comment, _| rdoc_comment.text }.
        join("\n")
    end

    def decorate_rdoc_mixins(rdoc_mixins)
      require "rdoc2mdoc/unknown_module"
      require "rdoc2mdoc/module"

      rdoc_mixins.map(&:module).map do |rdoc_module|
        if rdoc_module.is_a? String
          UnknownModule.new(rdoc_module)
        else
          self.class.new(rdoc_module, mandb_section)
        end
      end
    end

    attr_reader :rdoc_module
  end
end
