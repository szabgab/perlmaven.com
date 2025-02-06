---
title: "Echo with plain CGI"
timestamp: 2017-07-12T10:30:01
tags:
  - CGI
  - CGI::Simple
  - QUERY_STRING
  - "%ENV"
published: true
books:
  - cgi
author: szabgab
archive: true
---


After implementing the [Hello World with plain CGI](/hello-world-with-plain-cgi), the next 
step is to implement the [Echo](http://code-maven.com/exercise-web-echo).


## Echo without any module

The first solution I'll show is without using any module. You should probably never use this. The reason I am showing it is
that I hope that this will give you some background information on how the web, HTTP, and CGI work.

When you access a web page, the web server, in our case Apache, will create a number of "environment variables". Put them values.
Run the appropriate program on the server and whatever that program prints "on the screen" will be captured by the web server and sent
back to the browser. That's why in the [Hello World](/hello-world-with-plain-cgi) example we simply used `print`.

The user sitting in front of the web browser can even send parameters to the program by adding a question mark (`?`) after the URL
followed by key-value pairs. Like this: `http://127.0.0.1:8080/cgi-bin/echo.pl?name=Foo`
The web server will take all the content after the `?` mark and put it in an environment variable called `QUERY_STRING`.

Exactly the same will happen if the HTML page has a form that you fill out.
(Actually, it will only work this way if the form method is GET, but let's not jump ahead.)

As with any other environment variables we can access the content of QUERY_STRING via the `%ENV` hash.

Our first solution looks like this:

{% include file="examples/plain-cgi-echo.pl" %}

If we access this page like this:

`http://127.0.0.1:8080/cgi-bin/echo.pl`

the QUERY_STRING will be empty. Therefore, after printing the Content-type in the HTTP header, we print "Hello". The variable `$name` will remain empty.

On the other hand if the user types in

`http://127.0.0.1:8080/cgi-bin/echo.pl?name=Foo`

Then the QUERY_STRING will contain `name=Foo`. We will enter the `if` condition where we'll extract the value (Foo) from the QUERY_STRING
and assign it to the `$name` variable. The result will be "Hello Foo".

As you can see this works, but parsing QUERY_STRING is an ancient technique. There are plenty of libraries that would do it for you. Some of them being
also ancient already.

Parsing QUERY_STRING, and other sources of input is the main service modules such as CGI, CGI::Simple, and Plack provide.

## Echo using CGI

Switching from manual parsing of the QUERY_STRING to using the CGI module makes the code cleaner.
We can use the `header` method of the CGI instance to create the header as we did in the
[Hello World](/hello-world-with-plain-cgi) example, but the interesting part is that `$q`
which is the instance object created from the CGI class has a method called `param`. If we give it a string,
it will return the corresponding value from the QUERY_STRING.

{% include file="examples/cgi-echo.pl" %}

If there was no value it will return [undef](/undef-and-defined-in-perl).
Therefore, in order to avoid getting [Use of uninitialized value](/use-of-uninitialized-value)
warnings, we set the default value to the empty string.

## Echo using CGI::Simple

Instead of the heavy-weight [CGI](https://metacpan.org/pod/CGI) module we can also use
the much lighter [CGI::Simple](https://metacpan.org/pod/CGI::Simple) module as well:

{% include file="examples/cgi-simple-echo.pl" %}

## Echo with form using CGI

The earlier examples relied on the user typing in 

`http://127.0.0.1:8080/cgi-bin/echo.pl?name=Foo`

as the URL.

That's not how we are used to web applications. Hence in the next two example we'll see how to create a real HTML form
that when filled out will send the above request to the server.

{% include file="examples/cgi-echo-form.pl" %}

The heart of the solution is the `form` element in the HTML which has two `input` elements. The first one
has `type="text"` which means it will be a text input box. The second one has `type="submit"` which means
it will be a submit button with the text "Echo" on it. If the user types some text in the input box and clicks on the submit
button, the browser will send a request to the server adding `?text=some text` to the end of the URL.

Instead of returning a plain string like in the previous solutions, here we build a longer string which is a simple  HTML 5 page.

If the variable `$text` has any [defined](/undef-and-defined-in-perl) value in it, then it will be included
in the HTML with bold letter.

## Echo with form using CGI::Simple

This is exactly the same solution using CGI::Simple instead of CGI.

{% include file="examples/cgi-simple-echo-form.pl" %}


## Echo using PSGI

CGI and CGI::Simple can work for you, but you'd be probably better off
[using PSGI](/how-to-build-a-dynamic-web-application-using-psgi).

## Comments

it is great you do these articles about CGI

there are lots of old sites coming up for upgrade and lots of first time Perl programmers which go to various forms for help on CGI and get stomped on by the so-called community leaders for even daring to ask about CGI

<hr>

Gabor, thanks for writing this, as Emil pointed out this is still a much needed topic.

When I started CGI in 1997, we were not allowed to import modules in our environment, so it was a lot of learning and work, but I got a good understanding of how things worked. Basically learned out of the Perl 5 for Web Programming book, which is still on Amazon and not a bad book. https://www.amazon.com/Spec....

There is one thing that must be emphasized these days and that is security. I know it is hard to teach security while people are learning the basics, but it should at least be mentioned that input needs to be encoded before repeating as output.

This can be easily accomplished by the following:

Add to the top:

use URI::Escape;

Then someplace where it makes sense ...

my $safe_text = uri_escape($text);

This will protect against some basic XSS stuff, if you are using files or a database there are other security considerations as well.

if PCGI already does this by default, so much the better.

Cheers,
Jon


