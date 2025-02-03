---
title: "Testing PSGI based web applications using Plack::Test"
timestamp: 2017-06-24T10:50:01
tags:
  - Plack::Test
  - HTTP::Request::Common
  - Plack::Middleware::DirIndex
published: true
books:
  - psgi
author: szabgab
archive: true
---


We saw a simple example [serving static files using Plack/PSGI](/serving-static-site-using-plack-psgi).
We can use that simple example to see how to write tests for any web applications that using PSGI. For examle plain
[PSGI](/psgi) based applications or [Dancer](/dancer) based applications.


In every PSGI based application there is (or can be) a `app.psgi` file that is used to launch the application. In our case
all the code is in that file, but this is not a requirement for this to work.

{% include file="examples/static_psgi/app.psgi" %}

We also have an html file in the `www` subdirectory which is being served:

{% include file="examples/static_psgi/www/index.html" %}


Finally we have the test script located in the `t/` directory and having a `.t` extension.

{% include file="examples/static_psgi/t/test.t" %}

[Test::More](https://metacpan.org/pod/Test::More) is just the standard test modules used by most of the Perl modules
and Perl-based applications. If you'd like to learn more about it check out the [testing series](/testing).

The two modules [Plack::Test](https://metacpan.org/pod/Plack::Test) and
[HTTP::Request::Common](https://metacpan.org/pod/HTTP::Request::Common) are the core of our test script.

[Path::Tiny](https://metacpan.org/pod/Path::Tiny) is only used as a helper module to make it easy
to [slurp](/slurp) in the content of a file.

By running `my $app = do 'app.psgi';` we load the content of the `app.psgi` file and assign its return value to
the `$app` variable. In every PSGI-based application, and so in ours too, the `app.psgi` file is expected to return a reference to
a function that represents the application.

`Plack::Test` is going to use this reference to function to run the application on our behalf and in our process.

This might need to be clarified here. In this solution we don't launch a separate server for testing. Our test script contains
both the test code and by that `do` call also the web application.

In the next line in `my $main = path('www/index.html')->slurp_utf8;` we just read in the content of the `www/index.html` file
so later we can compare that to what we get from the web application.


In the next line: `my $res = $test->request(GET "/");` is the actual execution of a call to the web application.
Here we sent an HTTP GET request to the `/` page. The result that is assigned to `$res`
is an instance of [HTTP::Response](https://metacpan.org/pod/HTTP::Response). The `GET` keyword is actually
a function imported from [HTTP::Request::Common](https://metacpan.org/pod/HTTP::Request::Common).
We could have also imported `POST`, but we did not need it in our test script.

We can now interrogate the response to see if we got what we have expected.

We don't have to do all these checks, I am just showing a few of the possibilities:

`is $res->code, 200;` checks if the response code was 200, that represents success for HTTP requests.

`is $res->message, 'OK';` checks the actual response.

`$res->headers;` will return an instance of
[HTTP::Headers](https://metacpan.org/pod/HTTP::Headers) that can be checked separately.

Specifically the `header_field_names` returns the names of all the headers. If we really want to make sure is that everything is as expected,
we could test those too, but I only used to list the actual headers this request returned. Then I used the `header` method to fetch the
value of the given attribute in the header.  Again, this is probably way to much for a regular web page, but there can be cases, when we would like
to make sure a given header is returned to some of the requests. For example when we started to add a
[stand alone Ajax client](/stand-alone-ajax-client) to our application we had to add the `Access-Control-Allow-Origin` to the header.
We also added a test to check if the request indeed returned that header. (In other cases you might want to make sure that certain headers are not part of a respopnse.
For example you'd like to make sure that none of the responses include the `Access-Control-Allow-Origin` header.

The ultimate and most important check in most cases, is seeing ig the `content` resembles the expected content.

In our case we have the luxury, that we can compare the actual result to the whole
expected file:

`is $res->content, $main;`

However this is usually not the case. In most cases we will either need to use a regex match to see if certain strings or patterns can be found in the response,
or to make sure certain strings don't appear. We can use the `like` function for this instead of `is`. We can even go further an use an HTML Parser
to see if specific HTML snippets are in the response.


The whole directory structure is quite simple:

```
$ tree
.
├── app.psgi
├── t
│   └── test.t
└── www
    └── index.html
```

## Comments

How do I run this test?


