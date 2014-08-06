require "erb"
require "rdoc"
require "pry"
require "rdoc2mdoc/class"
require "rdoc2mdoc/module"
require "rdoc2mdoc/render_context"

module Rdoc2mdoc # :nodoc:
  ##
  # The rdoc2mdoc generator will make the +man/man3+ directory then generate
  # the mdoc into a file under there.
  # The filename ends with +3-rubygems-gem+ .
  # Each class gets its own mdoc file.
  #
  # This class is used by RDoc and conforms to an interface implemented there.
  class Generator
    ##
    # Create a Generator instance usign the provided RDoc store and parsed
    # options.
    def initialize(store, options)
      @store = store
      @output_directory = File.expand_path(File.join(options.op_dir, "man", "man#{mandb_section.split('-').first}"))
      FileUtils.mkdir_p output_directory
    end

    ##
    # Generate the mdoc.
    # Each class's and module's documentation is converted to mdoc then written
    # out to the relevant file.
    def generate
      (classes + modules).each { |object| generate_module(object) }
    end

    RDoc::RDoc.add_generator self

    private

    attr_reader :store, :output_directory

    def classes
      decorate_displayed(store.all_classes, Class)
    end

    def modules
      decorate_displayed(store.all_modules, Module)
    end

    def decorate_displayed(objects, decoration_class)
      objects.select(&:display?).map do |object|
        decoration_class.new(object, mandb_section)
      end
    end

    def generate_module(_module)
      write(_module, render_template(module_template, module: _module))
    end

    def render_template(template, assigns)
      ERB.new(template).result(binding_with_assigns(assigns)).squeeze("\n")
    end

    def write(object, mdoc)
      File.write file_name(object), mdoc
    end

    def file_name(object)
      File.join(output_directory, "#{object.name}.#{mandb_section}")
    end

    def module_template
      @module_template ||= File.read(template_path("module"))
    end

    def template_path(template_name)
      File.expand_path(
        File.join("..", "..", "templates", "#{template_name}.mdoc.erb"),
        File.basename(__FILE__)
      )
    end

    def binding_with_assigns(assigns)
      RenderContext.new(assigns).binding
    end

    def mandb_section
      "3-rubygems-gem"
    end
  end
end
