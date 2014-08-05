require "rdoc2mdoc/helpers"

module Rdoc2mdoc
  class RenderContext
    include Helpers

    def initialize(assigns, mandb_section)
      assigns.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
      @_mandb_section = mandb_section
    end

    def binding
      super
    end

    def mandb_section
      @_mandb_section
    end
  end
end
