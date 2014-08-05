require "rdoc"
require "rdoc2mdoc/helpers"

module Rdoc2mdoc # :nodoc:
  ##
  # Format an RDoc AST into mdoc.
  class Formatter < RDoc::Markup::Formatter
    include Helpers

    ##
    # Instantiate a mdoc Formatter that escapes special mdoc characters.
    def initialize(options=nil, markup = nil)
      super
      init_attribute_manager_tags
    end

    ##
    # Initialize the formatter with an empty array of parts and lists.
    def start_accepting
      @parts = []
      @list_types = []
    end

    ##
    # Compile the parts together
    def end_accepting
      handle_leading_punctuation parts.join.squeeze("\n")
    end

    ##
    # Turn a heading into a subsection header.
    def accept_heading(heading)
      parts << ".Ss #{heading.text}\n"
    end

    ##
    # Output a paragraph macro for the escaped paragraph.
    def accept_paragraph(paragraph)
      parts << handle_inline_attributes(paragraph.text)
      parts << "\n.Pp\n"
    end

    ##
    # Turn a large quoted section into a block display.
    def accept_block_quote(block_quote)
      parts << ".Bd -offset indent\n"
      block_quote.parts.each { |part| part.accept self }
      parts << "\n.Ed\n.Pp\n"
    end

    ##
    # Blank lines are paragraph separators.
    def accept_blank_line(blank_line)
      parts << "\n.Pp\n"
    end

    ##
    # Open an enumerated, dictionary, or bulleted list.
    # The list must be closed using #accept_list_start.
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

    ##
    # Close a list.
    # This works for all list types.
    def accept_list_end(list)
      list_types.pop
      parts << ".El\n"
    end

    ##
    # Open a list item.
    # If the list has a label, that label is the list item.
    # Otherwise, the list item has no content.
    #
    # Also see #accept_list_item_end.
    def accept_list_item_start(list_item)
      case current_list_type
      when :LABEL, :NOTE
        labels =  Array(list_item.label).join(", ")
        parts << ".It #{labels}\n"
      else
        parts << ".It\n"
      end
    end

    ##
    # Finish a list item.
    # This works for all list types.
    def accept_list_item_end(list_item)
    end

    ##
    # Format code as an indented block.
    def accept_verbatim(verbatim)
      parts << ".Bd -literal -offset indent\n"
      parts << verbatim.text
      parts << "\n.Ed\n.Pp\n"
    end

    ##
    # Format a horizontal ruler.
    def accept_rule(rule)
    end

    ##
    # All raw nodes are passed through unparsed, separated by newlines.
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
      escape(string.strip)
    end

    ##
    # Return a string with all new-lines immediately followed by one of:
    #
    #   .,:;()[]?!
    #
    # immediately followed by whitespace or the end of line replaced with a
    # space, the matched character and a space.
    #
    # This is to prevent lines to start with `.` and to avoid whitespace
    # between the last word of a sentence and the following punctuation
    # character.
    def handle_leading_punctuation(string) # :doc:
      string.gsub(/\n([.,:;()\[\]?!])(\s|$)/, " \\1\n")
    end
  end
end
