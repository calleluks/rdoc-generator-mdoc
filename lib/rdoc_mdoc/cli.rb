require "rdoc"
require "rdoc_mdoc/generator"

module RdocMdoc
  ##
  # The command-line interface for rdoc2mdoc.
  class CLI
    ##
    # Run the rdoc2mdoc program using Rdoc2mdoc::Generator.
    def run(argv)
      options = RDoc::Options.new
      options.files = argv
      p options
      options.setup_generator "rdocmdoc::generator"
      RDoc::RDoc.new.document options
    end
  end
end
