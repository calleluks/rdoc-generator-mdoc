module RdocMdoc
  class UnknownClass
    def initialize(full_name)
      @full_name = full_name
    end

    def reference
      @full_name
    end
  end
end
