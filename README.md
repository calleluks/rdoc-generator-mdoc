rdoc-generator-mdoc
===================

An **experimental** [mdoc(7)][mdoc] generator for [RDoc][rdoc].

The generator outputs one man page per Ruby module, class and method in
[mdoc(7)][mdoc] format.

[mdoc]: http://man7.org/linux/man-pages/man7/mdoc.7.html
[rdoc]: https://github.com/rdoc/rdoc

Installation
------------

Install `rdoc-generator-mdoc` using [RubyGems][rubygems]:

    $ gem install rdoc-generator-mdoc

You can also use [Bundler][bundler] to install `rdoc-generator-mdoc` by adding
this line to your `Gemfile`:

    gem "rdoc-generator-mdoc"

Then run the `bundle` command:

    $ bundle

[rubygems]: https://rubygems.org/
[bundler]: http://bundler.io/

Usage
-----

### In your Ruby source code

Specify `mdoc` as the formatter using the `-f` option when calling
`RDoc::RDoc#new`:

    require "rdoc/generator/mdoc"

    RDoc::RDoc.new.document "-f mdoc"

Since RDoc is often used to document Ruby libraries and section 3 of the Unix
manual generally contains library documentation, the mdoc generator will assign
the generated man pages to section `3-rdoc` by default. If you want the man
pages to be assigned to a different section, specify the section using the
`--section` option:

    RDoc::RDoc.new.document "-f mdoc --section 3-my-section"

For more information on using the `RDoc::RDoc` class see [the official RDoc
documentation][rdoc-docs]. For more information on manual sections see
[man(1)][man].

[rdoc-docs]: http://docs.seattlerb.org/rdoc/
[man]: http://man7.org/linux/man-pages/man1/man.1.html

### Using the `rdoc` executable

Specify `mdoc` as the formatter using the `-f` option:

    $ rdoc -f mdoc

Since RDoc is often used to document Ruby libraries and section 3 of the Unix
manual generally contains library documentation, the mdoc generator will assign
the generated man pages to section `3-rdoc` by default. If you want the man
pages to be assigned to a different section, specify the section using the
`--section` option:

    $ rdoc -f mdoc --section 3-my-section

For more information on manual sections see [man(1)][man].

### Reading generated man pages

The generated man pages are viewable directly using `man -l FILE` or
using `man [SECTION] PAGE` after putting them in a directory on the `$MANPATH`
(see [man(1)][man] for details).

Copyright
---------

Copyright (c) 2014 Calle Erlandsson & thoughtbot, Inc.

Lead by Calle Erlandsson & thoughtbot, Inc.
