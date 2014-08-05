module Rdoc2mdoc
  class Module
    def initialize(rdoc_module, mandb_section)
      @rdoc_module = rdoc_module
      @mandb_section = mandb_section
    end

    def reference
      "#{rdoc_module.full_name} #{mandb_section}"
    end

    private

    attr_reader :rdoc_module, :mandb_section
  end
end
