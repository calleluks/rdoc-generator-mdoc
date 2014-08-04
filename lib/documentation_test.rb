##
# = Heading level 1
#
# Some paragraph
#
# == Heading level 2
#
# Some more paragraph
#
# === Heading level 3
#
# A third paragraph. Below this comes a rule. Should be ignored by the mdoc
# formatter. (text in parenthesis) [text in brackets] "text in double quoutes"
# 'text in single quotes'
#
# ---
#
# * this is a list with three paragraphs in
#   the first item.  This is the first paragraph.
#
#   And this is the second paragraph.
#
#   1. This is an indented, numbered list.
#   2. This is the second item in that list
#
#   This is the third conventional paragraph in the
#   first list item.
#
# * This is the second item in the original list
#
# [cat]  a small furry mammal
#        that seems to sleep a lot
#
# [ant]  a little insect that is known
#        to enjoy picnics
#
# cat::  a small furry mammal
#        that seems to sleep a lot
#
# ant::  a little insect that is known
#        to enjoy picnics
# [one]
#
#     definition 1
#
# [two]
#
#     definition 2
#
# [one]  definition 1
# [two]  definition 2
#
# *   point 1
#
# *   point 2, first paragraph
#
#     point 2, second paragraph
#       verbatim text inside point 2
#     point 2, third paragraph
#   verbatim text outside of the list (the list is therefore closed)
# regular paragraph after the list
#
# = Text styles
#
# *bold* _emphasized_ +code+
#
# <b>bold</b> <em>emphasized</em> <tt>code</tt>
#
class DocumentationTest
  attr_reader :reader
  attr_writer :writer
  attr_accessor :readerwriter

  ##
  # This is my constant in a section without title.

  CONSTANT_IN_SECTION_WITHOUT_TITLE = "No title."

  # -------------------------------------------------
  # :section: My nice section
  #
  # This is the section that I wrote.
  # -------------------------------------------------

  ##
  # This is my constant.

  CONSTANT = "A nice constant"

  NOT_DOCUMENTED_CONSTANT = 42

  ##
  # This is my only public method

  def a_public_method(param1, param2)
  end

  private

  attr_reader :private_reader

  ##
  # This is my only private method

  def a_private_method(param)
  end
end
