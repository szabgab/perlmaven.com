---
title: "Serving static files such as favicon.ico and robots.txt using Plack"
timestamp: 2015-05-17T08:30:01
tags:
  - Plack::Middleware::Static
  - builder
  - Plack::Builder
  - favicon.ico
  - robots.txt
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


The [look-and-feel](/create-the-sco-look-and-feel) as we created earlier is not full without the favicon.ico file
that will appear on the tab in some of the browsers. We can easily download the favicon.ico from search.cpan.org,
the question how can we serve it? Do we need to write extra code for serving a static file?

What about robots.txt which is another, usually static file. How can we serve that file?


{% youtube id="FN_coL2JgLE" file="serving-static-files-with-plack" %}

[Plack](http://plackperl.org/) provides an excellent way to add various middlewares to the stack serving the application.
One of the middlewares is called [Plack::Middleware::Static](https://metacpan.org/pod/Plack::Middleware::Static) and
its purpose is, not surprisingly, to server static files.

First we need to have the static files on our disk. We will store them in a subdirectory of the project called 'static':

```
$ mkdir static
$ cd static
$ wget http://search.cpan.org/favicon.ico
```

You could see the [favicon.ico](http://search.cpan.org/favicon.ico) here too.

We also create a file called [static/robots.txt](https://github.com/szabgab/MetaCPAN-SCO/blob/1adde75e60aab8c8f0cf0e8ba42731d09c2024ce/static/robots.txt) with the following content:

```
User-agent: *
Disallow: /
```

The thing is, at this point we would like to avoid being indexed by any of the search engines. We don't want the site to be seen by
any of the search engines and just a copy of search.cpan.org. That could cause damage to both sites.

## Plack::Middleware::Static

In order to configure this middleware we need to use the `builder` function of [Plack::Builder](https://metacpan.org/pod/Plack::Builder).

This is how the `run` subroutine looks like after the change:

Earlier it returned an anonymous subroutine we created and assigned to the `$app` variable.
[Back then](/create-skeleton-psgi-application) I mentioned we did not even need to assign the function to
this variable, but now it comes handy. We store the anonymous subroutine in the `$app` variable and then we use the
`builder` function imported from the Plack::Builder to create and return a new anonymous function.

Inside the call to `builder` we configure the [Plack::Middleware::Static](https://metacpan.org/pod/Plack::Middleware::Static).
It basically needs two parameters: A regex that might match the path part of a URL in the site and a directory where the static files are located
If the `path_info` part of the request matches the request, then the Static Middleware will try to load and serve that file from
the given directory.


```perl
sub run {
    my $root = root();

    my $app = sub {
        my $env = shift;

        my $request = Plack::Request->new($env);
        if ($request->path_info eq '/') {
            return template('index');
        }

        return [ '404', [ 'Content-Type' => 'text/html' ], ['404 Not Found'], ];
    };

    builder {
        enable 'Plack::Middleware::Static',
            path => qr{^/(favicon.ico|robots.txt)},
            root => "$root/static/";
        $app;
    };
}
```


This code also needed the path to the root of the project we had in the `template` function. Instead
of repeating that nasty piece of code (calling dirname 3 times), I factored it out to a separate function
called `root()` so when time comes and we improve the way we compute the path to the root directory,
it will be easier to update it in only one place.

This lead us to the next [commit](https://github.com/szabgab/MetaCPAN-SCO/commit/1adde75e60aab8c8f0cf0e8ba42731d09c2024ce):

```
$ git add .
$ git commit -m "add static files: favicon taken from search.cpan.org and robots.txt that disallows every user-agent"
```

