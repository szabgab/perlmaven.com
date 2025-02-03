---
title: "Hello World with plain CGI"
timestamp: 2017-07-07T17:30:01
tags:
  - CGI
  - CGI::Simple
  - Content-type
published: true
books:
  - cgi
author: szabgab
archive: true
---


CGI, the [Common Gateway Interface](/cgi) was the real workhorse behind the early years of the Internet
and while there are other, more modern alternatives, such as [PSGI](/psgi), we still encounter environments
where only CGI scripts are used or only CGI script can be used.

This article for those who are stuck in such environments.


First of all you'll have to make sure your web server was properly [set up to serve CGI script](http://code-maven.com/set-up-cgi-with-apache).
Once you have that we have 3 solution here.

## CGI without any module

The first one does not use any module.

{% include file="examples/plain-cgi-hello-world.pl" %}

The [hash-bang](/hashbang) line, the first line in our code, has to point to the
perl interpreter/compiler. Then we have the [use strict; and use warnings;](/always-use-strict-and-use-warnings) statements.
They are not really required here, but I would not drive without seat-belts either.

Then we need to print the response HTTP header, or at least one line of it. We have to print `Content-type: text/html` followed by two new-lines.
Actually it is the header line `Content-type: text/html\n` followed by an empty row which is created by the second `\n`.

Then we can print the HTML itself which in our case will be a simple string saying `Hello World!`.

In order to make this work we have to make the program executable. We do that using the following command:

```
$ chmod +x plain-cgi-hello-world.pl
```

Then, if our [web server supports CGI](http://code-maven.com/set-up-cgi-with-apache), and if we put the file in the correct place.
we can access it via the web server and see the results.

## Using the CGI module

For many many years the [CGI](http://metacpan.org/pod/CGI) module was part of the
standard distribution of Perl. Unfortunately it was marked as deprecated in version 5.19.7 and then it was removed from perl version 5.22.
You can still install it though.

{% include file="examples/cgi-hello-world.pl" %}

Actually it does not provide a lot of value to this example. Nevertheless it is important to see how to use this module, so later
we can build on this knowledge.

The main thing it can do for us is to help creating the header line.
For this we need to create an instance of the CGI class by calling `new`. Then we can call the `header` method that will
return the `Content-type` line followed by two new lines.


## Using CGI::Simple

If you already have to install something then probably [CGI::Simple](http://metacpan.org/pod/CGI::Simple) is a better
choice than the old CGI module. It is smaller and it provides everything you'll need for a CGI script.

{% include file="examples/cgi-simple-hello-world.pl" %}

The solution for this simple exercise is the same. We load the CGI::Simple module. Create a new instance and call the header method
to get the Content-type line.


## Using Plack

Using CGI, or CGI::Simple might be easy, but if you'd like to make your application more future-proof, then
you'd better write it using PSGI/Plack. Even if you use the CGI mode of Plack. You can see how that's done
in two separate articles: [Hello World in Plack CGI mode](/hello-world-with-plack-cgi)
and [Getting Started with PSGI/Plack](/getting-started-with-psgi).



