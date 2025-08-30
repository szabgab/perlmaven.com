---
title: "Add another static page"
timestamp: 2015-05-28T08:30:01
tags:
  - SCO
  - Template::Toolkit
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


So far we've copied the [look-and-feel from search.cpan.org](/create-the-sco-look-and-feel),
but the only page we serve is the main page of the site. Let's add another static page to see
if there are any challenges. We are going to add the [feedback page](http://search.cpan.org/feedback)
of search.cpan.org.


{% youtube id="vQWuioO1FSw" file="add-another-static-page" %}

## Content

First we need to retreive the unique content of this page. We can do that either by clicking view-source in the browser when visiting
the [page](http://search.cpan.org/feedback) or we can download it using `wget http://search.cpan.org/feedback`
and then open it with our regular editor.
We put the content [tt/feedback.tt](https://github.com/szabgab/MetaCPAN-SCO/blob/66f0732a58ca0bae5a635738e40730d1bb8ab26b/tt/feedback.tt).

Actually I made some small changes, to include a link to the GitHub page of this project (but forgetting to add the actual URL),
instead of the mail address of the real search.cpan.org site, and to explicitly say that this is a clone.

## Mapping URL (routing)

We need to map the path `/feedback` in the URL to yhe appropriate template. This is done in the
`run` function of
[lib/MetaCPAN/SCO.pm](https://github.com/szabgab/MetaCPAN-SCO/blob/66f0732a58ca0bae5a635738e40730d1bb8ab26b/lib/MetaCPAN/SCO.pm)
by adding the following lines:

```perl
     if ($request->path_info eq '/feedback') {
         return template('feedback');
     }
```

This maps the URL to the specific template.

Looking at the [new page](http://localhost:5000/feedback) now reveals, that we need some more changes in order to move the logo and the search box to the top left corner.
If we look around the rest of the [search.cpan.org](http://search.cpan.org/) site, we can see that every page looks like the
feedback page except the front page. After some research we can find out that the difference is in the `body` tag.
Specifically that the body tag of the front-page also includes `class="front"`.
This class is set to 'front' on the front page, but the class attribute is missing on every other page.

On the front page:

```html
<body id="cpansearch" onload="document.f.query.focus();" class="front">
```

On the feedback page:

```html
<body id="cpansearch">
```

So we need to have a way to implement the same.

## Conditional in Template::Toolkit

[Template::Toolkit](http://template-toolkit.org/) is huge and it also allows us to have conditionals.

We replace the original code we had in the template:

```html
<body id="cpansearch" onload="document.f.query.focus();" class="front">
```

with this line:

```html
<body id="cpansearch" onload="document.f.query.focus();" <% IF front %>class="front"<% END %>>
```

This means that if the arguments passed to the `process` method of Template::Toolkit
contains a key called `front` with some true value, then the `class="front"`
will be included in the generated HTML.

The question then, how do we pass `front => 1` to the process method for the front page, but
not for the other pages? We need to be able to pass such parameters to the `template()`
function which will then pass them to the `process` method.


## Accepting parameters for individual pages

In the [previous article](/get-cpanstats-from-metacpan) we passed the `{ totals => $totals }`
to the process method, but now we need to be able to accept such parameters from the user of the
`template()` function, but also include the `totals => $totals` pair in it.


We change [lib/MetaCPAN/SCO.pm](https://github.com/szabgab/MetaCPAN-SCO/blob/35c35625c67e43877090dfc22be8ba8324b45f25/lib/MetaCPAN/SCO.pm) file
again to to contain the following code in the template function:

```perl
sub template {
    my ( $file, $vars ) = @_;
    $vars //= {};
    Carp::confess 'Need to pass HASH-ref to template()'
        if ref $vars ne 'HASH';

    my $root = root();

    $vars->{totals} = from_json path("$root/totals.json")->slurp_utf8;

    # ...

    $tt->process( "$file.tt", $vars, \$out )

    # ...
}
```

Instead of accepting only the `$file` parameter, we now also accept a parameter called `$vars` that
is supposed to be the hash we pass to the `process` method of Template::Toolkit.

If the user does not provide the second parameter, we set it to an empty hash, and then we check if this
variable is indeed a reference to a hash. If not we call `Carp::confess` with an error message explaining the problem.

Then we fill the 'totals' key with the values retrieved from the `totals.json` file:

```perl
    $vars->{totals} = from_json path("$root/totals.json")->slurp_utf8;
```

## Passing parameters to template()

Then we can replace this code in the `run` function:

```perl
    if ($request->path_info eq '/') {
         return template('index');
    }
```

by this code:

```perl
    if ($request->path_info eq '/') {
         return template('index', {front => 1});
    }
```

That is, we pass `{front => 1}` to the `template()` function which then passes
it to the `process` method and then the `class="front"` is included on the
front pages but not on any other pages.

With this we have finished adding the feedback page to our clone.

We arrived to another [commit](https://github.com/szabgab/MetaCPAN-SCO/commit/66f0732a58ca0bae5a635738e40730d1bb8ab26b):

```
$ git add .
$ git commit -m "add feedback page"
```

## Add Github link to feedback page

Then I noticed the link to GitHub wasn't working on the feedback page and so I added it with this
[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/8e308044b36eb828f4f957843c84d614b267da6a).


