require "rdoc2mdoc/unknown_class"
require "rdoc2mdoc/module"

module Rdoc2mdoc
  class Class < Module
    def superclass
      if rdoc_class.superclass.is_a? String
        UnknownClass.new(rdoc_class.superclass)
      else
        self.class.new(rdoc_class.superclass, mandb_section)
      end
    end

    private

    def rdoc_class
      rdoc_module
    end
  end
end
