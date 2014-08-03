require "rdoc"

module Rdoc2mdoc
  class Formatter < RDoc::Markup::Formatter
    def initialize(options=nil, markup = nil)
      super
      init_attribute_manager_tags
    end

    def start_accepting
      @parts = []
      @list_types = []
    end

    def end_accepting
      parts.join.squeeze "\n"
    end

    def accept_heading(heading)
      parts << ".Ss #{heading.text}\n"
    end

    def accept_paragraph(paragraph)
      parts << handle_inline_attributes(paragraph.text)
      parts << "\n.Pp\n"
    end

    def accept_block_quote(block_quote)
      parts << ".Bd -offset indent\n"
      block_quote.parts.each { |part| part.accept self }
      parts << "\n.Ed\n.Pp\n"
    end

    def accept_blank_line(blank_line)
      parts << "\n.Pp\n"
    end

    def accept_list_start(list)
      list_types.push(list.type)

      case current_list_type
      when :NUMBER, :LALPHA, :UALPHA
        parts << ".Bl -enum\n"
      when :LABEL, :NOTE
        parts << ".Bl -hang -offset -indent\n"
      else
        parts << ".Bl -bullet\n"
      end
    end

    def accept_list_end(list)
      list_types.pop
      parts << ".El\n"
    end

    def accept_list_item_start(list_item)
      case current_list_type
      when :LABEL, :NOTE
        labels =  Array(list_item.label).join(", ")
        parts << ".It #{labels}\n"
      else
        parts << ".It\n"
      end
    end

    def accept_list_item_end(list_item)
    end

    def accept_verbatim(verbatim)
      parts << ".Bd -literal -offset indent\n"
      parts << verbatim.text
      parts << "\n.Ed\n.Pp\n"
    end

    def accept_rule(rule)
    end

    def accept_raw(raw)
      parts << raw.parts.join("\n")
    end

    private

    attr_accessor :parts, :list_types

    def init_attribute_manager_tags
      add_tag :BOLD, "\n.Sy ", "\n"
      add_tag :EM, "\n.Em ", "\n"
      add_tag :TT, "\n.Li ", "\n"
    end

    def handle_inline_attributes(text)
      flow = attribute_manager.flow(text.dup)
      convert_flow flow
    end

    def attribute_manager
      @am
    end

    def current_list_type
      list_types.last
    end

    def convert_string(string)
      string.strip
    end
  end
end
