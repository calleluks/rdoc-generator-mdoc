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
      <<-TEMPLATE.gsub(/^\s*/, '')
        .Dd <%= Time.now.strftime "%B %-d, %Y" %>
        .Dt <%= @module.name.upcase %> <%= @module.mandb_section %>
        .Os
        .Sh NAME
        .Nm <%= @module.name %>
        .Nd <%= @module.short_description %>
        .Sh DESCRIPTION
        <%= @module.description %>

        <% if @module.respond_to?(:superclass) %>
        .Ss Superclass
        .Xr <%= escape @module.superclass.reference %> .
        .Pp
        <% end %>

        <% unless @module.extended_modules.empty? %>
          .Ss Extended Modules
          .Bl -bullet -compact
          <% @module.extended_modules.each do |_module| %>
            .It
            .Xr <%= escape _module.reference %>
          <% end %>
          .El
        <% end %>

        <% unless @module.included_modules.empty? %>
          .Ss Included Modules
          .Bl -bullet -compact
          <% @module.included_modules.each do |_module| %>
            .It
            .Xr <%= escape _module.reference %>
          <% end %>
          .El
        <% end %>

        <% @module.sections.each do |section| %>
          <% if section.titled? %>
            .Sh <%= section.title.upcase %>
          <% end %>

          <% if section.described? %>
            <%= section.description %>
          <% end %>

          <% unless section.constants.empty? %>
            .Ss Constants
            .Bl -tag
            <% section.constants.each do |constant| %>
              .It Dv <%= constant.name %> Li = <%= escape constant.value %>
              <% if constant.described? %>
                <%= constant.description %>
              <% else %>
                Not documented.
                .Pp
              <% end %>
            <% end %>
            .El
          <% end %>

          <% unless section.attributes.empty? %>
            .Ss Attributes
            .Bl -tag
            <% section.attributes.each do |attribute| %>
              .It Va <%= attribute.name %> Pq <%= attribute.rw %>
              <% if attribute.described? %>
                <%= attribute.description %>
              <% else %>
                Not documented.
                .Pp
              <% end %>
            <% end %>
            .El
          <% end %>

          <% [:class, :instance].each do |type| %>
            <% unless section.methods_of_type(type).empty? %>
              .Ss <%= type.capitalize %> Methods
              .Bl -tag
              <% section.methods_of_type(type).each do |method| %>
                .It Fn "<%= escape method.visibility %> <%= escape method.name %>" <%=
                method.parameters.map { |p| quote(escape(p)) }.join(" ") %>

                <% if method.has_invocation_examples? %>
                  .Bd -literal
                  <%= method.invocation_examples.join("\\n") %>
                  .Ed
                  .Pp
                <% end %>

                <% if method.described? %>
                  <%= method.description %>
                <% else %>
                  Not documented.
                  .Pp
                <% end %>

                <% if method.calls_super? %>
                  Calls superclass method
                  .Xr <%= escape method.superclass_method.reference %> .
                  .Pp
                <% end %>

                <% if method.alias? %>
                  Alias for
                  .Xr <%= escape method.aliased_method.reference %> .
                  .Pp
                <% end %>

                <% if method.aliased? %>
                  Also aliased as:
                  .Bl -bullet -compact
                  <% method.aliases.each do |_alias| %>
                    .It
                    .Xr <%= escape _alias.reference %>
                  <% end %>
                  .El
                <% end %>

              <% end %>
              .El
            <% end %>
          <% end %>
        <% end %>
      TEMPLATE
    end

    def binding_with_assigns(assigns)
      RenderContext.new(assigns).binding
    end

    def mandb_section
      "3-rubygems-gem"
    end
  end
end
