require "erb"
require "rdoc"
require "rdoc2mdoc/renderable_class"
require "rdoc2mdoc/render_context"

module Rdoc2mdoc
  class Generator
    def initialize(store, options)
      @store = store
      @output_directory = File.expand_path(File.join(options.op_dir, "man", "man#{section.split('-').first}"))
      FileUtils.mkdir_p output_directory
    end

    def generate
      renderable_classes.each do |klass|
        File.write File.join(output_directory, [klass.name, section].join(".")), render_class(klass)
      end
    end

    RDoc::RDoc.add_generator self

    private

    attr_reader :store, :output_directory

    def renderable_classes
      store.all_classes.select(&:display?).map { |c| RenderableClass.new(c) }
    end

    def render_class(klass)
      render_template class_template, class: klass, section: section
    end

    def render_template(template, assigns)
      ERB.new(template).result(binding_with_assigns(assigns))
    end

    def class_template
      <<-TEMPLATE.gsub(/^\s*/, '')
        .Dd <%= Time.now.strftime "%B %-d, %Y" %>
        .Dt <%= @class.name.upcase %> <%= @section %>
        .Os
        .Sh NAME
        .Nm class <%= @class.name %>
        .Nd <%= @class.short_description %>
        .Sh DESCRIPTION
        <%= @class.description %>
      TEMPLATE
    end

    def binding_with_assigns(assigns)
      RenderContext.new(assigns).binding
    end

    def section
      "3-rubygems-gem"
    end
  end
end
