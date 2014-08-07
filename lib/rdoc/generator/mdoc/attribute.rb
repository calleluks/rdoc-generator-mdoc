require "rdoc/generator/mdoc/comment"

class RDoc::Generator::Mdoc
  class Attribute
    def initialize(rdoc_attribute)
      @rdoc_attribute = rdoc_attribute
    end

    def name
      rdoc_attribute.name
    end

    def rw
      rdoc_attribute.rw
    end

    def described?
      !description.empty?
    end

    def description
      comment.mdoc_formatted_content
    end

    private

    def comment
      @comment ||= Comment.new(rdoc_attribute.comment.text)
    end

    attr_reader :rdoc_attribute
  end
end
