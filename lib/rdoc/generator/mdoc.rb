require "erb"
require "rdoc"
require "rdoc/generator/mdoc/version"
require "rdoc/generator/mdoc/class"
require "rdoc/generator/mdoc/module"
require "rdoc/generator/mdoc/render_context"

class RDoc::Options
  attr_accessor :mandb_section
end

##
# An mdoc(7) generator for RDoc.
#
# This generator will create man pages in mdoc(7) format for classes, modules
# and methods parsed by RDoc.
class RDoc::Generator::Mdoc
  RDoc::RDoc.add_generator self

  def self.setup_options(options)
    options.option_parser.on("--section SECTION", String) do |mandb_section|
      options.mandb_section = mandb_section
    end
  end

  ##
  # Create an instance usign the provided RDoc::Store and RDoc::Options.
  def initialize(store, options)
    @store = store
    @mandb_section = options.mandb_section || "3-rdoc"
    @output_directory = File.expand_path(File.join(options.op_dir, "man", "man#{mandb_section.split('-').first}"))
    FileUtils.mkdir_p output_directory
  end

  ##
  # Generate man pages.
  #
  # Every class, module and method gets their own man page in the
  # "man/manSECTION_PREFIX" subdirectory of the output directory.
  def generate
    generate_class_and_module_pages
    generate_method_pages
  end

  private

  attr_reader :store, :output_directory, :mandb_section

  def generate_class_and_module_pages
    (classes + modules).each do |object|
      generate_page(file_name(object), "module", module: object)
    end
  end

  def generate_method_pages
    methods.each do |method|
      generate_page(file_name(method), "method", method: method)
    end
  end

  def classes
    @classes ||= decorate_displayed(store.all_classes, Class)
  end

  def modules
    @modules ||= decorate_displayed(store.all_modules, Module)
  end

  def methods
    @methods ||= (classes + modules).flat_map(&:methods)
  end

  def decorate_displayed(objects, decoration_class)
    objects.select(&:display?).map do |object|
      decoration_class.new(object, mandb_section)
    end
  end

  def generate_page(file_name, template_name, assigns)
    File.write(file_name, render_template(template(template_name), assigns))
  end

  def file_name(object)
    File.join(output_directory, "#{object.full_name}.#{mandb_section}")
  end

  def render_template(template, assigns)
    ERB.new(template).result(binding_with_assigns(assigns)).squeeze("\n")
  end

  def template(name)
    @templates ||= {}
    @templates[name] ||= File.read(template_path(name))
  end

  def template_path(name)
    File.expand_path(
      File.join("..", "..", "..", "..", "templates", "#{name}.mdoc.erb"),
      __FILE__,
    )
  end

  def binding_with_assigns(assigns)
    RenderContext.new(assigns).binding
  end
end
