require "rdoc2mdoc/constant"
require "rdoc2mdoc/comment"
require "rdoc2mdoc/attribute"
require "rdoc2mdoc/method"

module Rdoc2mdoc
  class Section
    def initialize(rdoc_section, rdoc_constants, rdoc_attributes)
      @rdoc_section = rdoc_section
      @rdoc_constants = rdoc_constants
      @rdoc_attributes = rdoc_attributes
    end

    def titled?
      !title.nil?
    end

    def title
      rdoc_section.title
    end

    def described?
      !description.empty?
    end

    def description
      comment.mdoc_formatted_content
    end

    def constants
      @constants ||= rdoc_constants.map do |rdoc_constant|
        Constant.new(rdoc_constant)
      end
    end

    def attributes
      @attributes ||= rdoc_attributes.map do |rdoc_attribute|
        Attribute.new(rdoc_attribute)
      end
    end

    def methods_of_type(type)
      @methods_of_type ||= {}
      @methods_of_type[type] ||=
        rdoc_section.
        parent.
        methods_by_type(rdoc_section)[type.to_s].
        flat_map do |visibility, rdoc_methods|
          rdoc_methods.map { |rdoc_method| Method.new(rdoc_method, visibility) }
        end
    end

    private

    attr_reader :rdoc_section, :rdoc_constants, :rdoc_attributes

    def markup
      rdoc_section.comments.map(&:normalize).map(&:text).join
    end

    def comment
      @comment ||= Comment.new(markup)
    end
  end
end
