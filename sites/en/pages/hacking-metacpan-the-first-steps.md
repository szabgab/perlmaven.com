---
title: "Hacking Meta::CPAN - the first steps"
timestamp: 2013-11-22T15:46:01
tags:
  - Meta::CPAN
  - MetaCPAN
published: true
books:
  - catalyst
  - metacpan
author: szabgab
---


CPAN, the [Comprehensive Perl Archive Network](http://www.cpan.org/) has two
main front-ends. The old [search.cpan.org](http://search.cpan.org/) for which the source code is not available publicly, and [Meta CPAN](https://metacpan.org/),
that is open source and has a nice public API.

I think it is great that we can make changes and improvements to Meta::CPAN.

Let's see how can we start doing it.


(Disclaimer: I tried it on Linux and Mac OSX using
[perlbrew-ed](http://perlbrew.pl/) Perl 5.18.1,
I don't know if this will work on Windows or not.)
The [README](https://github.com/CPAN-API/metacpan-web) indicates
that is works on Win32 as well.

<img src="/img/metacpan-logo.png" alt="MetaCPAN Logo" />

MetaCPAN has two main parts: 

1. The back-end that collects and processes all the data and provides and API.
1. The front end that talks to this API and displays the data.

In this article we'll see how to set up a copy of the front end and how
to make a small change to it.

Clone the [metacpan-web](https://github.com/CPAN-API/metacpan-web)
repository from GitHub.

```
$ git clone https://github.com/CPAN-API/metacpan-web.git
```

(Note: If you want to contribute your changes back then you'll probably first
want to fork the repository and clone the forked version.)

If you don't have it yet, install [cpan-minus](http://cpanmin.us).
This is not a requirement, but it will make
[installation of the dependencies](http://www.dagolden.com/index.php/1528/five-ways-to-install-modules-prereqs-by-hand/) easier.

```
$ cd metacpan-web
$ cpanm --installdeps .
```

Then check if everything was installed:

```
$ perl Makefile.PL
```

One thing I noticed is that `cpanm --installdeps .`  did not upgrade JSON and JSON::XS. I have 2.61 instead of 2.90, and 2.34 instead of 3.01 respectively. So I installed
them manually:

```
$ cpanm JSON
$ cpanm JSON::XS
```


Run the tests that come with the code:

```
$ perl Makefile.PL
$ make
$ make test
```

Then following the [README](https://github.com/CPAN-API/metacpan-web) launch
the web site using

```
$ plackup -p 5001 -r
```

This will start a MetaCPAN front end on port 5001 and `-r` will reload
the application whenever a file changes. This is really good during development.


Now you can visit [localhost:5001](http://localhost:5001) and voilà,
you have your own Meta::CPAN.

Try using it to make sure everything works and that it can connect to the
back-end server.

## Adding links to Google+

If you "connect" a web page with your Google+ account, Google will display
your face whenever that page appears in a search on Google itself.
This needs two steps, one of them is that each page will link to the
Google+ profile of the author with `?rel=author` at the end of the URL.

This is what I wanted to add. 

After some searching, I found out that the templates of MetaCPAN are in
the
[root](https://github.com/CPAN-API/metacpan-web/tree/master/root) subdirectory.

I thought I'd like to add the link to Google+ under the picture of the module author
on the right-hand side. (See for example [SVG](https://metacpan.org/release/SVG), one of the modules I currently maintain.)

I found out that this part of the pages is included from the 
[root/inc/author-pic.html](https://github.com/CPAN-API/metacpan-web/blob/master/root/inc/author-pic.html). As the rest of the site, this is also using
[Template Toolkit](http://www.template-toolkit.org/).

Ever user of MetaCPAN has a profile, and in that profile they can list their IDs on various other sites. Each such other site has a name and an ID string. Basically a key-value pair.
The key for Google+ is **googleplus** and thus I added the following entry:

```
<% IF p.name == "googleplus" %>
  <a rel="author" href="<% profiles.${p.name}.url.replace('%s', p.id) %>?rel=author" target="_blank" title="<% p.name %> - <% p.id%>">
    <img src="/static/images/profile/<% p.name %>.png" width=16 height=16 alt="<% p.name %>">
  </a>
<% END %>
```

This [Template Toolkit](http://www.template-toolkit.org/) code means
that when the profile name is "googleplus" add a link with an img.

The snippet was based on the code in the [root/author.html](https://github.com/CPAN-API/metacpan-web/blob/master/root/author.html) file that displays lots of profile-icons
on the left-hand side of the individual [author pages](https://metacpan.org/author/SZABGAB). At least for people who added the profiles to their
[MetaCPAN account](https://metacpan.org/account/profile).

## Linking from Google+ to MetaCPAN

The other side of the "connection" was described in my post calling
the CPAN authors to
[connect their Google+ pages to MetaCPAN](https://szabgab.com/claiming-your-cpan-authorship-at-google.html).

## Conclusion

It is very easy to set up a local version of the MetaCPAN front-end and to start
making changes to it. Go ahead, make some changes, send a pull request and see
your name appear among the [contributors](https://metacpan.org/about/contributors).

There are currently 85 contributors.

My objective is to make it in the first 3 rows before the end of the year.
Can you stop me from reaching that?


## ps

At first I had to count the number of contributors manually,
but then I checked the source code of that page. It is located in
[root/about/contributors.html](https://github.com/CPAN-API/metacpan-web/blob/master/root/about/contributors.html) and it is using [JQuery](http://jquery.com/)
with an Ajax call. So I added two lines to also display the total number of contributors.
Even if it is not accepted by the maintainers of MetaCPAN, I can now check the number
on my own copy of the MetaCPAN site.

I really enjoy the fact that I can change MetaCPAN so easily.

