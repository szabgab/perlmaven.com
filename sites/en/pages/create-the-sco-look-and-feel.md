---
title: "Create the search.cpan.org look and feel"
timestamp: 2015-05-16T11:30:01
tags:
  - SCO
  - HTML5
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


We have created [skeleton PSGI application](/create-skeleton-psgi-application), and
we have [started to use Template::Toolkit](/start-using-template-toolkit-to-show-empty-pages)
to separate the Perl code from the HTML code. The next step is to create the look-and-feel of
[search.cpan.org](http://search.cpan.org/).


{% youtube id="H6bbo-LYpkw" file="create-the-sco-look-and-feel" %}

As we don't have access to the templates creating search.cpan.org, we are going to create those ourself.

First step is to look at the source of the main page of search.cpan.org. We can do that either by
visiting the page and clicking on **view source** in the browser, or by fetching the HTML using
`wget`, or `curl`:

```
$ wget http://search.cpan.org/
```

This has downloaded the page and created a file called index.html.

Looking in the file we can see that it uses `HTML 4.01 Transitional`. We don't want to copy that part.
We don't want to be bogged down by that. We will use HTML5 instead.

The header of the html file links to the stylesheet on some external site. We can either include the same link
or we can download the CSS file and store it on our server. For now we can just link to the external site:

```
<link rel="stylesheet" href="http://st.pimg.net/tucs/style.css?3" type="text/css" />
```

Then there are some JavaScript files included starting with JQuery. We are also going to include the JQuery file,
though we will include a newer version. (There might be some compatibility issue, but we'll look at that later,
if we encounter any issues.) More importantly, we move the inclusion of the JavaScript files to the end of the HTML
we generate which means we need to put the code in the
[tt/incl/footer.t](https://github.com/szabgab/MetaCPAN-SCO/blob/7a623c1f410c86642e7719d6e7bdc4d643b18e56/tt/incl/footer.tt)
file:

```
 <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.js"></script>
</body>
</html>
```

The rest of the work was carefully select the HTML code starting from the &lt;body string, including the menu, including the code of the search box
and even the stats at the bottom of the page. I know these numbers are going to be generated later on, but for now it seems like
a good idea to include the values as they are.

So basically all the code of the front page is either in the
[tt/incl/header.tt](https://github.com/szabgab/MetaCPAN-SCO/blob/7a623c1f410c86642e7719d6e7bdc4d643b18e56/tt/incl/header.tt)
or in the
[tt/incl/footer.t](https://github.com/szabgab/MetaCPAN-SCO/blob/7a623c1f410c86642e7719d6e7bdc4d643b18e56/tt/incl/footer.tt).

the `tt/index.tt` will be empty.

```
$ git add .
$ git commit -m "get the source of the main page of search.cpan.org and create something very similar in the header.tt"
```

This got us to the next [commit](https://github.com/szabgab/MetaCPAN-SCO/tree/7a623c1f410c86642e7719d6e7bdc4d643b18e56).
You can take a look at the situation by following the instructions [here](/looking-at-specific-commit-in-github). 


