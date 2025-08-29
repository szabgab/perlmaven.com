---
title: "Adding a layout to a Mojolicious::Lite based application"
timestamp: 2013-08-29T21:30:01
tags:
  - Mojolicious::Lite
published: true
books:
  - mojolicious
author: szabgab
---


In the previous article we saw how we can move our HTML to
[embedded templates](/mojolicious-lite-with-embedded-templates).

We even had an exercise to create a template for the `/` route.

In this article we'll see how to add a common layout to all the pages, how to serve
static files and how to move the templates to their own file.


Let's start by looking at a solution for the exercise:

```perl
use Mojolicious::Lite;

get '/' => sub {
    my $self = shift;
    $self->render('index');
};

get '/echo' => sub {
    my $self = shift;
    $self->render('echo', msg => undef);
};

post '/echo' => sub {
    my $self = shift;
    $self->render( 'echo', msg => $self->param('q') );
};

app->secret('My extra secret passphrase.');

app->start;

__DATA__

@@ echo.html.ep

What are you looking for?
<form method="POST"><input name="q"><input type="submit" value="Echo"></form>

% if (defined $msg) {
   You typed: <%= $msg %>
% }

@@ index.html.ep

Hello Template World!<br>
Please, check out our [echo](/echo) page.
```

We changed the handler of `/` and call `$self->render('index');`.
We could use any template name there, but historically the **index** page
was the one that was shown when someone accessed the root directory.
So we stick to that name.

We also added the template itself at the end of the file.
It even had a link to our `echo` page.

```perl
@@ index.html.ep

Hello Template World!<br>
Please, check out our [echo](/echo) page.
```

## Creating a common layout

When building a multi-page web site we usually want certain elements to be the
same on all the pages. For example we might want to have a menu-bar and a logo.
And maybe a footer and some other page elements...

We need to do two things:

First we create another template at the bottom of our script.
The order of the templates is not interesting. What is a bit unique in this template
is that its name starts with `layouts/` as if it was in a subdirectory, even though
it is still in the same Perl script.

The HTML is some very basic HTML 5 code, but it has one unique feature. It has
an entry `<%= content %>` init. This is a little-bit of Mojolicious::Lite
template syntax that tells Mojolicious to embed the content of the actual pages
at this location.

```html
@@ layouts/wrapper.html.ep
<!DOCTYPE html>
<html>
<head>
  <title></title>
</head>
<body>
<div id="menu">
* [home](/)
* [echo](/echo)
</div>

<%= content %>

</body>
</html>
```

The other change is that for every template, except of the layout itself,
we need to tell to use this layout.
We do it by adding `% layout 'wrapper';` immediately after
the declaration of the templates. Like this:

```html
@@ index.html.ep
% layout 'wrapper';

...
```

Now, assuming `morbo` is already running with our application, we can use our browser to look
at the result:

The root page:

<img src="/img/mojolicious_lite_root_with_embedded_layout.png" alt="Mojolicious::Lite root page with embedded layout" />

The echo page:

<img src="/img/mojolicious_lite_echo_with_embedded_layout.png" alt="Mojolicious::Lite echo page with embedded layout" />

## Add some style

Now that we have a common layout we can apply some CSS styling. We already prepared our HTML by having
a `div` around the menu, we can now embed a bit of CSS in our layout getting the following code:

```perl
use Mojolicious::Lite;

get '/' => sub {
    my $self = shift;
    $self->render('index');
};

get '/echo' => sub {
    my $self = shift;
    $self->render('echo', msg => undef);
};

post '/echo' => sub {
    my $self = shift;
    $self->render( 'echo', msg => $self->param('q') );
};

app->secret('My extra secret passphrase.');

app->start;

__DATA__

@@ layouts/wrapper.html.ep
<!DOCTYPE html>
<html>
<head>
  <title></title>

<style>
html,body {
  margin: 0;
  padding: 0;
}
#menu {
  margin-top: 10px;
  margin-bottom: 10px;
  font-weight:bold;
}
#menu ul {
  list-style: none;
  display: inline;
}
#menu li {
  margin-left: 10px;
  float: left;
}
#menu a {
  text-decoration:none;
}
</style>

</head>
<body>
<div id="menu">
* [home](/)
* [echo](/echo)
</div>

<%= content %>

</body>
</html>
 
@@ echo.html.ep
% layout 'wrapper';

What are you looking for?
<form method="POST"><input name="q"><input type="submit" value="Echo"></form>

% if (defined $msg) {
   You typed: <%= $msg %>
% }

@@ index.html.ep
% layout 'wrapper';

Hello Template World!<br>
Please, check out our [echo](/echo) page.
```

The root page will look like this:

<img src="/img/mojolicious_lite_root_with_embedded_css.png" alt="Mojolicious::Lite root page with embedded CSS" />

Not perfect, but we can already show this to a real web designer to make something nice for us.

Except that the CSS is still embedded in our HTML template which is embedded in our Perl code.
It is great as it make distribution easy, but it is much harder to hand out the design work
to someone else. Also if more than one person works on the project, then we will constantly make
merging harder than necessary.

So let's see how can we move the CSS to its own file?

## Move CSS into a separate file - the public folder

Any file found in the directory called `public/` next to our
Mojolicious::Lite script will be accessible directly via the browser.
That means if we have a file called `public/style.css` we 
can view the content of that file by browsing to [http://localhost:3000/style.css](http://localhost:3000/style.css).
It also means we can move the content of the `style` element to the `public/style.css` file
and instead of that add a link to it in the header of our HTML:

```
  <link href="/style.css" rel="stylesheet">
```

Reloading the pages should not make any difference to the viewer.
If you'd like to make sure it worked, make some changes in the style.css file and reload the pages.

## Moving templates to external files

Besides the CSS file, it can be also useful to have the templates and the layout in
external files. Let's move the `index` template to an external file.

We had this in our perl script:

```
@@ index.html.ep
% layout 'wrapper';

Hello Template World!<br>
Please, check out our [echo](/echo) page.
```

We create a directory called `templates/` next to the script and next to the `public/`
directory and create a file called `templates/index.html.ep` - exactly the name we had for the
template. We remove the `@@ index.html.ep` line from the script and move the content of
the template to the new file. It will have this content:

```
% layout 'wrapper';

Hello Template World!<br>
Please, check out our [echo](/echo) page.
```

Or maybe we can slightly change the content so when we reload the page
we'll see it was taken from this new place.

That's it.

## Exercise

Now, that we have moved the CSS stylesheet to an external file we can also add a few
other static files.
For example, a [robots.txt file](http://en.wikipedia.org/wiki/Robots_exclusion_standard),
even if it is empty or has something like this in it:

```
User-agent: *
Disallow: /images/
```

A favicon.ico file can be also cute. You can create one [here](http://www.favicon.cc/).

## Exercise 2



As in the [previous article](/mojolicious-lite-with-embedded-templates),
we have a [GitHub repository](https://github.com/PerlMaven/mojolicious-lite-move-template-to-file) again.
You are more than welcome to fork it, send a pull
request and even to comment the solutions created by other people.

