---
title: "Getting started with Perl Dancer - Creating an Echo application"
timestamp: 2013-04-21T11:33:01
tags:
  - Dancer
  - DWIM Perl
  - echo
types:
  - screencast
published: true
books:
  - dancer
---


Perl Dancer is a modern, light weight, route-oriented web application framework for Perl. In the first few minutes of this screencast,
you will learn how to set up your development environment on Microsoft Windows machine, and then you will see how to create your
first (and very basic) web application using Perl Dancer <b>regardless of your operating system</b>. (14:25 min)


{% youtube id="266P43Nk4vk" file="getting-started-with-perl-dancer-1280x720" %}

<div id="text">

Showing how to install [DWIM Perl on Windows](/dwimperl),
configure the cmd window enlarging the fonts and resizing the window.

Then we upgrade Dancer using `cpanm --verbose Dancer`.
`dancer -a Echo` will create the skeleton of the application.


Run `perl bin/app.pl` to launch the application.

Browse to `http://127.0.0.1:3000/`

Editing `views/index.tt` which the content of the main page,  and the `views/layouts/main.tt`
which is the default layout of the Dancer pages.


The background image is declared in the stylesheet which is located in the `public/css/style.css` file.


```
<div id="echo-form">
<form>
<input type="text" name="q" />
<input type="submit" value="Echo" />
</form>
</div>
```


The CSS file gets the following:

```
#echo-form {
   text-align: center;
   margin-top: 100px;
}
```


`lib/Echo.pm</li> implements the application.

The default content was this:

```perl
package Echo;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

true;
```


```perl
package Echo;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    my $q = param('q');
    if (defined $q) {
        return "You said: $q";
    }
    template 'index';
};

true;
```


Other articles and videos about [Perl Dancer](/dancer)
</div>
