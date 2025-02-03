---
title: "Testing Perl CGI application"
timestamp: 2018-01-10T11:00:01
tags:
  - CGI
  - Capture::Tiny
  - Test::More
  - File::Temp
published: true
author: szabgab
archive: true
---


Unfortunately CGI.pm has been removed from core Perl, but there are still lots of applications out there
that use CGI.pm. I even encountered one built in 2017 by people who have not learned newer techniques.
The thing is, CGI is perfectly good for small things and for trying out new concepts without forcing
the developer to learn some new technology.

Anyway, when I got to this client, I had to help them write tests for their CGI-based application.


I did not want to convert the application to some PSGI-based application, even though that could
be a nice route. We just wanted to write some tests for the application.

Hence we used the command-line capabilities of CGI.pm.

This is a sample CGI script:

{% include file="examples/cgi.pl" %}

It does not do much, but it is enough to show how to test any CGI-script.

{% include file="examples/cgi.t" %}

There are two test-cases. One for a <b>GET</b> request and one for a <b>POST</b>.

## GET

For the <b>GET</b> request we need to put the parameters that you'd see in the URL into
the `QUERY_STRING` environment variable. In addition we need to set the `REQUEST_METHOD`
to `GET`. Then we can run our CGI script. We use `./cgi.pl` instead of  `$^X cgi.pl`
or even just `perl cgi.pl` as this will ensure we use the same perl for the execution of the
CGI script as it is used by the server.

We use the `capture` function provided by [Capture::Tiny](https://metacpan.org/pod/Capture::Tiny)
to capture the STDOUT and STDERR of the program. The STDOUT should contain everything that is sent back to the
browser, including both the header and the body, but not the HTTP status.

The STDERR should be empty. Whatever goes there usually ends up in the error-log of the web server, but normally
that should be empty.

The 3rd value returned by the `capture` function is the exit-code of the `system` call in the block.
Normally it should be 0, indicating success.

Once we have the responses, we can use the regular functions of [Test::More](https://metacpan.org/pod/Test::More)
such as `is` and `like` to compare the result to the expected values or to check if the result contains
something we expect.

## POST

In the case of a `POST` request we need to set the `REQUEST_METHOD` to be `POST`, we need to supply
the input on the STDIN of the CGI-script and we need to supply the length of the input in the `CONTENT_LENGTH`
environment variable. For this to work nicely, we create a temporary directory using the `tempdir` function
of [File::Temp](https://metacpan.org/pod/File::Temp) and in the `system` call we set up redirection
of the STDIN of the cgi.pl execution.

## local

`local` is used when setting the environment variables as that, and the curly-braces around the `subtest` functions
will prevent these settings from leaking between the subtests.

## Running the test

Using `prove` we can run the test script and get a very compact output:

```
$ prove cgi.t

cgi.t .. ok
All tests successful.
Files=1, Tests=2,  1 wallclock secs ( 0.04 usr  0.01 sys +  0.13 cusr  0.04 csys =  0.22 CPU)
Result: PASS
```

## Further reading

There are two series of related articles. One is about [testing with Perl](/testing) and the other
one is about [CGI and Perl](/cgi).

Besides the 3 environment variables we have already seen there are a few others that might
need to be set in order to fully recreate the environment provided by the web server.
The following ones are the most common variables:

```perl
local $ENV{QUERY_STRING}    = 
local $ENV{REQUEST_METHOD}  = 
local $ENV{CONTENT_LENGTH}  = 

local $ENV{HTTP_COOKIE}     =
local $ENV{HTTP_HOST}       =
local $ENV{HTTP_REFERER}    =
local $ENV{HTTP_USER_AGENT} =
local $ENV{PATH_INFO}       =
```

## Comments

There is also CGI::Emulate::PSGI ( https://metacpan.org/pod/CGI::Emulate::PSGI ) which you can use to easily port existing CGI code into a PSGI environment - where testing and debugging immediately becomes a lot easier.


<hr>

oh, dearest old command line CGI testing :)

too bad most of the time a lot of work is done in the web server configuration or in rewrite rules or in load balancers or in reverse proxies etc.

the only right way to test CGI is with LWP


<hr>

Another module for absolute beginners is https://metacpan.org/dist/CGI-Echo ,  but I'd only use it to explain the transfer of data between the client and the server. I.e. the aim is not to think in terms of the CGI module. From there perhaps introducing a HTML templating module would come next, to stop them reinventing the wheel.
