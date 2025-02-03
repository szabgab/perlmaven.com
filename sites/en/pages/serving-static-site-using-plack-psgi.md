---
title: "Serving a static site (the content of a directory) using Plack and PSGI"
timestamp: 2017-05-13T22:05:01
tags:
  - plackup
  - Plack::Builder
  - Plack::App::File
  - Plack::Middleware::DirIndex
published: true
books:
  - psgi
author: szabgab
archive: true
---


Just a simple example using [Plack::Builder](https://metacpan.org/pod/Plack::Builder)
and [Plack::App::File](https://metacpan.org/pod/Plack::App::File)
to serve some static files using a Perl-based web server.



{% include file="examples/static_psgi/app.psgi" %}

Put this in a directory as `app.psgi`. Put your HTML files in the 'www' subdirectory.
Run `plackup` and you can visit http://127.0.0.1:5000/ to see the pages.

In this code we use the [Plack::Middleware::DirIndex](https://metacpan.org/pod/Plack::Middleware::DirIndex)
middleware that handles the files in the given directory.

Check out the other [articles on Plack/PSGI](/psgi).


## Comments

There is handy oneliner as well: plackup -MPlack::App::Directory -e 'Plack::App::Directory->new(root => ".")->to_app'

