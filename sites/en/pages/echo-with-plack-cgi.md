---
title: "Echo with Plack in CGI mode"
timestamp: 2017-07-27T20:30:01
tags:
  - Plack::Handler::CGI
published: true
books:
  - psgi
author: szabgab
archive: true
---


A [web application that can echo back text](http://code-maven.com/exercise-web-echo) show almost all the capabilities one needs to know
before they can embark on building a larger application. It involves sending data to the server, and showing a response to it.

In this case we are going to use [Plack/PSGI](/psgi) in [CGI](/cgi) mode.


{% include file="examples/psgi-cgi-echo.pl" %}

We start in a similar way to our [Hello World in PSGI CGI](/hello-world-with-plack-cgi) example,
but we also load the [Plack::Request](https://metacpan.org/pod/Plack::Request) module that can properly parse
the `QUERY_STRING` environment variable created by the Apache web server.

If we put this script in a [CGI-enabled directory of Apache](http://code-maven.com/set-up-cgi-with-apache),
we can access it as

```
http://127.0.0.1/cgi-bin/echo.pl
```

or we can pass parameters on the URL:

```
http://127.0.0.1/cgi-bin/echo.pl?name=Foo
```

The Apache web server will put the string after the `?` question mark in an environment variable
called `QUERY_STRING`. We need to parse it. Luckily, just as [CGI and CGI::Simple](/echo-with-plain-cgi),
Plack can also parse this information. That's part of what Plack::Request does.

In our solution we grab the parameter passed to our main subroutine. That's where the Plack passes in all the environment
information. So we don't need to know if the web server used the QUERY_STRING environment variable or some other means.

The Plack::Request module uses the information in this hash reference to construct an object with a `param` method,
just as the CGI, and CGI::Simple modules provided that method.

We get the value of the 'name' parameter and use the `|| ''` construct to set it to the empty string in case the user
has not passed any value.


## Echo with Plack in CGI mode and full HTML5

This is basically the same code, but instead of sending back a small HTML snippet containing only "Hello $name!" 
we build a slightly bigger HTML snippet with all the parts that are required for an HTML 5 page.

Then we send back the content of the `$html` variable.

{% include file="examples/psgi-cgi-html5-echo.pl" %}

The indentation is a bit off due to the [here document](/here-documents), something we could solve by using external
template files.


