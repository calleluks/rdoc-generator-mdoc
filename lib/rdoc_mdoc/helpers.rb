module RdocMdoc
  ##
  # A module of helpers when outputting mdoc formatted text
  module Helpers
    ##
    # Returns a new string where characters that mdoc percieve as special have
    # been escaped.
    #
    # This is in line with the advice given in +mdoc.samples(7)+:
    #
    # > To remove the special meaning from a punctuation character escape it
    # > with ‘\&’. Troff is limited as a macro language, and has difficulty
    # > when pre‐ sented with a string containing a member of the mathematical,
    # > logical or quotation set:
    # >
    # > {+,-,/,*,%,<,>,<=,>=,=,==,&,`,',"}
    # >
    # > The problem is that troff may assume it is supposed to actually perform
    # > the operation or evaluation suggested by the characters. To prevent
    # > the accidental evaluation of these characters, escape them with ‘\&’.
    # > Typical syntax is shown in the first content macro displayed below,
    # > ‘.Ad’.
    def escape(string)
      string.gsub(%r|[+\-/*%<>=&`'"]|, '\\\&\0')
    end

    ##
    # Returns a new string enclosed in double quotes.
    def quote(string)
      string.gsub(/^|$/, '"')
    end
  end
end
