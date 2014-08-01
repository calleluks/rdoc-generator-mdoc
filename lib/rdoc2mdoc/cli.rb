require 'rdoc'
require 'rdoc/generator/mdoc'

module Rdoc2mdoc
  class CLI
    def run(argv)
      RDoc::RDoc.new.document ["--format", "mdoc"] + argv
    end
  end
end
