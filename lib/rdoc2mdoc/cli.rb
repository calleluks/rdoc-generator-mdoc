require 'rdoc'
require 'rdoc2mdoc/generator'

module Rdoc2mdoc
  class CLI
    def run(argv)
      options = RDoc::Options.new
      options.files = [""]
      options.setup_generator "rdoc2mdoc::generator"
      RDoc::RDoc.new.document options
    end
  end
end
