require "active_support/core_ext/string/filters"
require "rdoc/generator/mdoc/comment"
require "rdoc/generator/mdoc/section"
require "rdoc/generator/mdoc/unknown_module"

class RDoc::Generator::Mdoc
  class Module
    attr_reader :mandb_section

    def initialize(rdoc_module, mandb_section)
      @rdoc_module = rdoc_module
      @mandb_section = mandb_section
    end

    def full_name
      rdoc_module.full_name
    end

    def reference
      "#{full_name} #{mandb_section}"
    end

    def short_description
      comment.first_paragraph.truncate(50)
    end

    def described?
      !description.empty?
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

    def methods
      sections.flat_map(&:methods)
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
            self,
          )
        end
    end

    def methods_by_type(section)
      rdoc_module.methods_by_type(section)
    end

    private

    def comment
      @comment ||= if rdoc_module.comment_location.is_a? RDoc::Markup::Document
        Comment.new(rdoc_module.comment_location)
      else
        Comment.new(extract_markup(rdoc_module.comment_location))
      end
    end

    def extract_markup(comment_location)
      comment_location.map { |rdoc_comment, _| rdoc_comment.text }.join("\n")
    end

    def decorate_rdoc_mixins(rdoc_mixins)
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
