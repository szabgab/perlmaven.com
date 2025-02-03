---
title: "How to add images to the documentation of Perl modules on CPAN "
timestamp: 2013-08-22T14:30:01
tags:
  - CPAN
published: true
author: szabgab
---


Having a lot of clear documentation for a CPAN module is awesome, but
looking at a wall of text while reading it can be a bit boring.

Luckily both [MetaCPAN](http://metacpan.org/)
and [search.cpan.org](http://search.cpan.org/).


First let's link to few examples:

## Including images in MetaCPAN

* [Chart::Clicker](https://metacpan.org/pod/Chart::Clicker)
* [SVGN](https://metacpan.org/pod/SVG)
* [Acme::CPANAuthors::Nonhuman](https://metacpan.org/pod/Acme::CPANAuthors::Nonhuman)
* [MOSES::MOBY](https://metacpan.org/pod/MOSES::MOBY)
* [Wrangler](https://metacpan.org/pod/Wrangler)

## Including images on search.cpan.org

* [Chart::Clicker](http://search.cpan.org/dist/Chart-Clicker/lib/Chart/Clicker.pm)
* [SVG](http://search.cpan.org/dist/SVG/lib/SVG.pm)

As Ether pointed out on the related [blogs.perl.org](http://blogs.perl.org/users/gabor_szabo/2013/08/adding-images-to-cpan.html)
post, [grep.cpan.me](http://grep.cpan.me/?q=%3Dbegin+html) can list a bunch of modules that might have some embedded HTML
in their POD.

## So how can this be done?

Let's look at the
[source code of Char::Clicker](https://github.com/gphat/chart-clicker/blob/master/lib/Chart/Clicker.pm).

It has the following section:

```
=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/line.png"
width="500" height="250" alt="Line Chart" /></p>

=end HTML
```

That's all we need to include in the POD of the module.

The images are served from a [Github page](http://pages.github.com/).

Actually [Chart::Clicker](http://gphat.github.io/chart-clicker/) has its own site
hosted on a Github page. It is very easy to create such a Github page for your project.
Just follow [the instructions](https://help.github.com/articles/creating-project-pages-manually).
There you can include add the images

In the [source code of SVG](https://github.com/szabgab/SVG/blob/master/lib/SVG.pm) the
example is slightly different:

```
=for HTML <p><img src="https://szabgab.com/img/SVG/circle.png" alt="SVG example circle" /></p>
```

Here the image is actually served from my own personal domain.


