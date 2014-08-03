module Rdoc2mdoc
  class RenderContext
    def initialize(assigns)
      assigns.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end

    def binding
      super
    end
  end
end
