require 'rdoc'
require 'rdoc2mdoc/generator'

module Rdoc2mdoc
  ##
  # The command-line interface for rdoc2mdoc.
  class CLI
    ##
    # Run the rdoc2mdoc program using Rdoc2mdoc::Generator.
    def run(argv)
      options = RDoc::Options.new
      options.files = [""]
      options.setup_generator "rdoc2mdoc::generator"
      RDoc::RDoc.new.document options
    end
  end
end
