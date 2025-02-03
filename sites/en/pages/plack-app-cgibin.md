---
title: "Running CGI script as a Plack application with Plack::App::CGIBin"
timestamp: 2020-12-20T16:30:01
tags:
  - Plack::App::CGIBin
  - CGI
  - plackup
published: true
books:
  - cgi
types:
  - screencast
author: szabgab
archive: true
description: "Good old CGI scripts needed Apache server. this examples shows how to run them as using Plackup."
show_related: true
---


While [CGI](https://metacpan.org/pod/CGI) might have served the needs of your company for many years there are more advanced techniques these days.
One drawback of CGI is that you usually need to have the Apache web server running it. You might also need to use mod_perl
to improve the speed of your site.

This examples shows how to run them via Plackup using [Plack::App::CGIBin](https://metacpan.org/pod/Plack::App::CGIBin) that will make
it easier to further develop your code and to run it using any modern Perl-based application server.
It will also open the door and easier transition to [Dancer](/dancer) or [Mojolicious](/mojolicious).


{% youtube id="9LO6FPLKkSk" file="english-run-cgi-using-plack.mkv" %}

## Our CGI "application"

We have a simple Perl script which is a [CGI](/cgi) application. It is called app.pl and it is located in a directory called <b>cgi-bin</b>

We probably use it via [HTTP Apache 2 server](/perl-cgi-script-with-apache2). We could even [test the CGI script](/testing-perl-cgi).

{% include file="examples/cgi-bin/app.pl" %}

We can run it on the command line:

```
perl cgi-bin/app.pl
```

We can even supply it with query string parameters:

```
perl cgi-bin/app.pl "text=hello world"
```

After installing [Plack::App::CGIBin](https://metacpan.org/pod/Plack::App::CGIBin) we can run it as

```
plackup -MPlack::App::CGIBin -e 'Plack::App::CGIBin->new(root => "cgi-bin")->to_app'
```

In this case we can access it as http://localhost:5000/app.pl


Alternatively we can create a scrip like this:

{% include file="examples/plack_app_cgibin.pl" %}

That I place just outside the cgi-bin directory.

Here first we calculate the relative location of the cgi-bin directory (so we'll be able to run this script from any working directory).

Then we launch the application.

Finally we map it to the "/cgi" path in the URL. Just so we can see a different solution.

We can access it at this URL:

http://localhost:5000/cgi/app.pl


