require "erb"
require "rdoc"
require "rdoc2mdoc/renderable_class"
require "rdoc2mdoc/render_context"
require "rdoc2mdoc/helpers"

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
      @output_directory = File.expand_path(File.join(options.op_dir, "man", "man#{section.split('-').first}"))
      FileUtils.mkdir_p output_directory
    end

    ##
    # Generate the mdoc.
    # Each class' documentation is converted to mdoc then written out to the
    # relevant file.
    def generate
      renderable_classes.each do |klass|
        File.write File.join(output_directory, [klass.name, section].join(".")), render_class(klass)
      end
    end

    RDoc::RDoc.add_generator self

    private

    attr_reader :store, :output_directory

    def renderable_classes
      store.all_classes.select(&:display?).map do |klass|
        RenderableClass.new(klass)
      end
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
        <% @class.sections.each do |section| %>
          <% if section.titled? %>
            .Sh <%= section.title.upcase %>
          <% end %>

          <% if section.described? %>
            <%= section.description %>
          <% end %>

          <% unless section.constants.empty? %>
            .Ss Constants
            .Bl -tag -offset indent
            <% section.constants.each do |constant| %>
              .It Dv <%= constant.name %> Li = <%= escape constant.value %>
              <% if constant.described? %>
                <%= constant.description %>
              <% else %>
                Not documented.
              <% end %>
            <% end %>
            .El
          <% end %>

          <% unless section.attributes.empty? %>
            .Ss Attributes
            .Bl -tag -offset indent
            <% section.attributes.each do |attribute| %>
              .It Va <%= attribute.name %> Pq <%= attribute.rw %>
              <% if attribute.described? %>
                <%= attribute.description %>
              <% else %>
                Not documented.
              <% end %>
            <% end %>
            .El
          <% end %>
        <% end %>
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
