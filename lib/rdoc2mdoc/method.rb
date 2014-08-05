require "rdoc2mdoc/comment"

module Rdoc2mdoc
  class Method
    attr_reader :visibility

    def initialize(rdoc_method, mandb_section, visibility = nil)
      @rdoc_method = rdoc_method
      @mandb_section = mandb_section
      @visibility = visibility.to_s
    end

    def name
      rdoc_method.name
    end

    def full_name
      rdoc_method.full_name
    end

    def parameters
      rdoc_method.params.gsub(/[\(\)]/, '').split(", ")
    end

    def described?
      !description.empty?
    end

    def description
      comment.mdoc_formatted_content
    end

    def has_invocation_examples?
      !invocation_examples.empty?
    end

    def invocation_examples
      @invocation_examples ||= if rdoc_method.call_seq.nil?
        []
      else
        extract_invocation_examples(rdoc_method.call_seq)
      end
    end

    def calls_super?
      !superclass_method.nil?
    end

    def superclass_method
      @superclass_method ||= rdoc_method.superclass_method &&
        Method.new(rdoc_method.superclass_method, mandb_section)
    end

    def has_source?
      !source.nil?
    end

    def source
      @source ||= rdoc_method.token_stream && rdoc_method.tokens_to_s
    end

    def alias?
      !aliased_method.nil?
    end

    def aliased_method
      @aliased_method ||= rdoc_method.is_alias_for &&
        Method.new(rdoc_method.is_alias_for, mandb_section)
    end

    def aliased?
      !aliases.empty?
    end

    def aliases
      @aliases ||= rdoc_method.aliases.map do |_alias|
        Method.new(_alias, mandb_section)
      end
    end

    def reference
      "#{full_name} #{mandb_section}"
    end

    private

    attr_reader :rdoc_method, :mandb_section

    def comment
      @comment ||= Comment.new(rdoc_method.comment.text)
    end

    def extract_invocation_examples(call_seq)
      call_seq.split("\n").map do |invocation_example|
        strip_receiver(invocation_example)
      end
    end

    def strip_receiver(invocation_example)
      invocation_example.gsub(/^\w+\./, '')
    end
  end
end
