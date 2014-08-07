rdoc-generator-mdoc
===================

An mdoc(7) generator for [RDoc](https://github.com/rdoc/rdoc).

Usage
-----

### In Your Ruby Source Code

Add `rdoc-generator-mdoc` to your `Gemfile`:

    gem "rdoc-generator-mdoc"

Specify `mdoc` as the formatter using the `-f` option when calling
`RDoc::RDoc#new`:

    require "rdoc/generator/mdoc"

    RDoc::RDoc.new.document "-f mdoc"

For more information on using the `RDoc::RDoc` class see [the official RDoc
documentation](http://docs.seattlerb.org/rdoc/).

### Using the `rdoc` executable

Specify `mdoc` as the formatter using the `-f` option:

    $ rdoc -f mdoc

Copyright
---------

Copyright (c) 2014 Calle Erlandsson & thoughtbot, Inc.

Lead by Calle Erlandsson & thoughtbot, Inc.
