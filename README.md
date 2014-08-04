rdoc2mdoc
=========

An rdoc to mdoc converter. Turn Ruby into man pages.

Usage
-----

Given a file `user.rb`, this will generate `./man/man3/user.3-rubygems-gem`:

    rdoc2mdoc user.rb

This will generate `/usr/local/share/man/man3/user.3-rubygems-gem`:

    rdoc2mdoc -o /usr/local/share user.rb

This will generate appropriately-named man pages for all Ruby files under the
current directory, and store these man pages under `/usr/share/man/man3`:

    find . -name \*rb -print | xargs rdoc2mdoc -o /usr/share/man/man3

Copright
-------

Copyright 2014 thoughtbot.

Lead by Calle Erlandsson and thoughtbot.
