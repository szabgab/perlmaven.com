---
title: "How does the world wide web work?"
timestamp: 2014-04-19T21:00:01
tags:
  - URL
  - Ajax
  - JSON
  - XML
published: true
author: szabgab
---


A short overview of "the web" or "the Internet" as some people call it.

For the more technically oriented: "the Internet" is the interconnected network of devices (computers, mobile phones, tablets, routers, modems etc.),
while "the Web" is the subset of "the Internet" that is usually reachable via the protocols `http` or `https` and is generally seen
in a "browser".


On your computer, mobile phone or tablet you have a software application called a "web browser".
(Major web browsers are [Mozilla Firefox](http://www.mozilla.org/en-US/firefox/new/),
[Google Chrome](https://www.google.com/intl/en/chrome/browser/),
[Apple Safari](https://www.apple.com/safari/),
[Opera](http://www.opera.com/), and
[Microsoft Internet Explorer](http://windows.microsoft.com/en-us/internet-explorer/download-ie)).

You type a web address (also called a "[URL](https://en.wikipedia.org/wiki/Url)") in the address-bar: something like www.google.com or perlmaven.com/perl-tutorial,
or even just an [IP address](https://en.wikipedia.org/wiki/Ip_address) like 127.0.0.1. If you have not supplied the `protocol`, the browser will
automatically add it, and change the address to http://www.google.com or https://perlmaven.com/perl-tutorial .
Then it does some background work translating the address to the IP number of the server, that we don't discuss here,
and send a request to fetch the appropriate page from the right computer somewhere, possibly on the other side of the world.

The computer on the other side, runs a software program called a web server. (Major flavors are
the open source [Apache](http://httpd.apache.org/) and [nginx](http://nginx.org/) servers,
and the proprietary [Microsoft IIS](http://www.iis.net/).)

These web servers can be configured to map each request to a specific file on the file-system to be served as it-is.
This would create a static web site. A site that cannot take any input from you, the user.

On the other hand the web server can be configured to run a program when the user requests a page.
That program can be written in many different programming languages and there are a number of different ways to call them.

## 3 major ways to serve the dynamic page

**CGI**: One of the most basic ways, and probably the oldest one, is called `CGI`. Upon receiving a request from the browser,
the web server will set certain environment variables, and run the requested program. That program will process
the request and print the results to its standard output. The web server captures this output and sends it back to your
browser which will try to display it for you. These programs are usually written in Perl or in some other dynamic language
that the general public refers to as "scripting language". Hence these programs are usually called **CGI scripts**.
The advantage of CGI scripts is that they can be written in any language. Once the web server is configured you can even
replace the scripts by others written in other languages. It is very simple to write CGI scripts. The disadvantage is
that, for every request, the web server will have to spawn a new process, which can be time consuming. For simple web sites
that get only a few 10s of requests an hour this is usually not an issue, but when the site gets busy this can have a bad impact
on response time.

**Embedded interpreter**: Another way is to embed the interpreter of the desired "scripting language" inside the web server. PHP usually works this way
and [mod_perl](https://perl.apache.org/) provides this functionality for Perl when using the Apache web server.
This is much faster than CGI - for example mod_perl can be 200 times faster than CGI/Perl, but this ties the implementation
language and the web server. This makes development and deployment a bit more rigid.

**Application server**: The third way is using an "application server". In this case there is an additional server, often called an "application server"
running alongside the web server. Every time the web server receives a request for a dynamic page, it hands it over to the
application server. The application server is language specific and it has all the application loaded in the memory and compiled once.
Applications written in Java usually utilize an application server.

[FastCGI](http://www.fastcgi.com/) is basically a language-independent application server with a slightly unfortunate name.

Starman, and other [PSGI-based](http://plackperl.org/) servers can work as stand-alone web servers
(the Perl Maven site used to run on Starman as a web server), or as application servers. Usually this involves an Apache or Nginx
server in front of such PSGI-based server. (The Perl Maven site currently runs on Nginx in-front of a Starman.)
In all of these cases the application written in Perl is embedded in the PSGI-based server providing speed and flexibility.
Other languages, such as Python and Ruby have their own respective "application servers".

## What you get back from the web server

When you access a URL what you usually get back is a file with text in it using HTML (the Hyper Text Markup Language) that
describes which part is the title, what are list items etc. In addition, the HTML page usually refers to a number of
additional files (for example: images). After the browser receives the HTML file it parses it, and will request
the additional files from the web server. At the same time it tries to render the file and display it in your browser.
Sometimes you will see that certain images appear on the page at once while others appear later. That's because
the fetching of the images and the rendering of the HTML file are done in parallel. Some of the images will
arrive before the rendering is done, some will arrive only later. Yet others might never arrive, in which case the
browser might display a picture of a "broken image".

In addition to the images, an HTML page usually also refers to external CSS and JavaScript files.
CSS ([Cascading Style Sheets](http://en.wikipedia.org/wiki/Cascading_Style_Sheets)) provides the "look" of the
page. (e.g. colors, sizes, relative location of objects etc.) while [JavaScript](http://en.wikipedia.org/wiki/Javascript)
can provide additional interactivity inside the browser.

This is how the majority of web sites work. Every time we click on a link or a button, that generates a request sent to the web server,
that returns a new page, a new HTML file, that is rendered again by the browser.

## Ajax

The more modern way that we can see in a lot of web applications is that it loads a single HTML page and for every click that
page changes somehow. In the background, the page talks to the server. It sends and receives data. One of the most well known
web-based applications like that is Gmail.

The technology it employs to talk to the server in the background is called Ajax.
It stands for [Asynchronous JavaScript and XML](http://en.wikipedia.org/wiki/Ajax_(programming)),
even though in most modern applications the data is transferred using JSON instead of XML.

The Ajax-based applications are basically [client-server](http://en.wikipedia.org/wiki/Client_server)
applications and as such, have two major moving parts.
The code that runs in the web browser which is referred to as the "client side" is written in JavaScript.
The code that runs on the server which is referred to as the "server side" can be written in any language. Including Perl.
The server-side part is quite similar in the two kinds of sites, the difference is only that in the first case it
returns an HTML page, while in the second case it returns serialized data. Usually as XML or JSON.

## Mixed sites

There are many web sites that are a mix of the two methods. For example, blog software will probably
display the articles as stand-alone HTML pages with their individual URLs,
but will have an Ajax-based administrative interface where the owner can edit and post articles.


