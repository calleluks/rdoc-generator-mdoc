require "erb"
require "rdoc"
require "rdoc2mdoc/renderable_class"
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
    # Each class' documentation is converted to mdoc then written out to the
    # relevant file.
    def generate
      renderable_classes.each do |klass|
        File.write File.join(output_directory, [klass.name, mandb_section].join(".")), render_class(klass)
      end
    end

    RDoc::RDoc.add_generator self

    private

    attr_reader :store, :output_directory

    def renderable_classes
      store.all_classes.select(&:display?).map do |klass|
        RenderableClass.new(klass, mandb_section)
      end
    end

    def render_class(klass)
      render_template class_template, class: klass
    end

    def render_template(template, assigns)
      ERB.new(template).result(binding_with_assigns(assigns))
    end

    def class_template
      <<-TEMPLATE.gsub(/^\s*/, '')
        .Dd <%= Time.now.strftime "%B %-d, %Y" %>
        .Dt <%= @class.name.upcase %> <%= mandb_section %>
        .Os
        .Sh NAME
        .Nm <%= @class.name %>
        .Nd <%= @class.short_description %>
        .Sh DESCRIPTION
        <%= @class.description %>
        .Ss Superclass
        .Xr <%= escape @class.superclass.reference %> .
        .Pp
        <% @class.sections.each do |section| %>
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
                .It Fn "<%= escape method.visibility %> <%= escape method.name %>" <%= method.parameters.join(" ") %>

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
                  .Bl -bullet
                  <% method.aliases.each do |_alias| %>
                    .It
                    .Xr <%= escape _alias.reference %> .
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
      RenderContext.new(assigns, mandb_section).binding
    end

    def mandb_section
      "3-rubygems-gem"
    end
  end
end
