---
title: "A Simple way to download many web pages using Perl"
timestamp: 2015-04-12T00:30:01
tags:
  - LWP::Simple
  - HTTP::Tiny
  - wget
  - curl
published: true
author: szabgab
---


There are plenty of choices when you need to fetch a page or two from the Internet.
We are going to see several simple examples using wget, curl,
[LWP::Simple](http://metacpan.org/module/LWP::Simple),
and [HTTP::Tiny](http://metacpan.org/module/HTTP::Tiny).


## wget

While they are not Perl solutions, they can actually provide a quick solution for you.
I think there are virtually no Linux distributions that don't come with either `wget`
or `curl`. They are both command line tool that can download files via various protocols,
including HTTP and HTTPS.

You can use the `system` function of Perl to execute external program so you can write the
following:

```perl
my $url = 'https://perlmaven.com/';
system "wget $url";
```

This will download the main page from the perlmaven.com domain and save it on the disk.
You can then read that file into a variable of your Perl program.

However there is another, more straight-forward way to get the remote file in a variable.
You can use the `qx` operator (what you might have seen as back-tick ``) instead of the
`system` function, and you can ask `wget` to print the downloaded file to
the standard output instead of saving to a file. As `qx` will capture and return the standard
output of the external command, this can provide a convenient way to download a page directly into
a variable:

```perl
my $url = 'https://perlmaven.com/';
my $html = qx{wget --quiet --output-document=- $url};
```

`--output-document` can tell `wget` where to save the downloaded file.
As a special case, if you pass a dash `-` to it, `wget` will print the
downloaded file to the standard output.

`--quiet` tells `wget` to avoid any output other than the actual content.

## curl

For `curl` the default behavior is to print to the standard output,
and the `--silent` flag can tell it to avoid any other output.

This is the solution with `curl`:

```perl
my $url = 'https://perlmaven.com/';
my $html = qx{curl --silent $url};
```

The drawback in both cases it that you rely on external tools and you probably
have less control over those than over perl-based solutions.

## Get one page using LWP::Simple

Probably the most well know perl module implementing a web client is `LWP` and its
sub-modules. [LWP::Simple](http://metacpan.org/module/LWP::Simple) is a,
not surprisingly, simple interface to the library.

The code to use it is very simple. It exports a function called `get`
that fetch the content of a single URL:

{% include file="examples/get_lwp_simple.pl" %}

This is really simple, but in case of failure you don't know what really happened.
You just get an empty document.

## Get one page using HTTP::Tiny

For that [HTTP::Tiny](http://metacpan.org/module/HTTP::Tiny) is much better even if the code is slightly longer:

{% include file="examples/get_http_tiny.pl" %}

`HTTP::Tiny` is object oriented, hence you first call the constructor `new`. It returns an object and
on that object you can immediately call the `get` method.

It returns a hash with a number of interesting keys: `success` will
be [true or false](/boolean-values-in-perl), `content` will hold the
actual html content. `status` is the HTTP status-code (200 for success, 404 for not found, etc.).

Try printing it out using `Data::Dumper`. It is very useful!

## A fuller example with HTTP::Tiny

{% include file="examples/get_http_tiny_full.pl" %}

The first part of the output was generated by the `while`-loop on the headers
hash, then we used `Data::Dumper` to print out the whole hash.
Well, except of the content itself, that we deleted from the hash. It would have been
to much for this article and if you'd like to see the content,
you can just visit the main page of the [Perl Maven](/) site.

```
content-type: text/html; charset=utf-8
set-cookie: dancer.session=8724695823418674906981871865731; path=/; HttpOnly
x-powered-by: Perl Dancer 1.3114
server: HTTP::Server::PSGI
server: Perl Dancer 1.3114
content-length: 21932
date: Fri, 19 Jul 2013 15:20:18 GMT

$VAR1 = {
          'protocol' => 'HTTP/1.0',
          'headers' => {
                         'content-type' => 'text/html; charset=utf-8',
                         'set-cookie' => 'dancer.session=8724695823418674906981871865731; path=/; HttpOnly',
                         'x-powered-by' => 'Perl Dancer 1.3114',
                         'server' => [
                                       'HTTP::Server::PSGI',
                                       'Perl Dancer 1.3114'
                                     ],
                         'content-length' => '21932',
                         'date' => 'Fri, 19 Jul 2013 15:20:18 GMT'
                       },
          'success' => 1,
          'reason' => 'OK',
          'url' => 'https://perlmaven.com.local:5000/',
          'status' => '200'
        };
```


## Downloading many pages

Finally we arrived giving an example of downloading many pages using `HTTP::Tiny`.

{% include file="examples/get_http_tiny_download.pl" %}

The code is, quite straight forward. We have a list of URLs in the `@urls` array.
An `HTTP::Tiny` object is created and assigned to the `$ht` variable. The
in a for-loop we go over each url and fetch it.

In order to save space in this article I only printed the size of each page.

This is the result:

```
Start https://perlmaven.com/
Length: 19959
Start https://cn.perlmaven.com/
Length: 13322
Start https://br.perlmaven.com/
Length: 12670
Start https://httpbin.org/status/404
Failed: 404 NOT FOUND
Start https://httpbin.org/status/599
Failed: 599 UNKNOWN
```

The simplicity has a price of course. It means that we wait for each request  to be finished
before we send out a new request. As most of the time is spent waiting for the the request to travel
to the remote server, then waiting for the remote server to process the request,
and then waiting till the response reaches us, we waste quite a lot of time. We could have sent all 3
requests in parallel and we would get our results much sooner.

However, this is going to be covered in another article.

## Comments

Can I read and extract data(actual, not HTML) from URL(website)? if yes, can you please update what APIs i can use?

---
You just found the article that explains it.

---
Thanks for reply, actually, when I try to print "$response->{content}" from above script, it prints HTML. I just want to need actual data without html tags and basically I want to parse tags and extract textbody. Is that possible? Thank you once again!
---
I am sure it is. Read the documentation of the modules. Check out https://metacpan.org/pod/HTML::Parser
----
Thank you! Appreciate your help!

<hr>

I tried the example where you downloaded perlmaven. I get " Failed: 599 Internal Exception". I also had to remove the s from {reasons}. Got any ideas?
Thank you

---

I converted the examples to stand-alone scripts and tried them and they all worked perfectly. Did you try to fetch other URLs? Which ones? Have any of the other solutions worked for you?

----
Further investigating, I added a URL that will return status 599 and I see the key is indeed reason and not reasons. I've update the article with that. Thanks.
However I don't know why would you get 599 on the Perl Maven URLs.

