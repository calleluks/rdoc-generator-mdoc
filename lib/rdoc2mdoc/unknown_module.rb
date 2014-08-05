module Rdoc2mdoc
  class UnknownModule
    def initialize(full_name)
      @full_name = full_name
    end

    def reference
      @full_name
    end
  end
end
