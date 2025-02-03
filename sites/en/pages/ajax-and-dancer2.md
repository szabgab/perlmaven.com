---
title: "Ajax and Dancer 2"
timestamp: 2016-02-27T16:10:01
tags:
  - Dancer2
  - jQuery
  - Ajax
published: true
books:
  - dancer2
author: szabgab
archive: true
---


In this project we are going to create a web application using [Dancer2](/dancer) as back-end,
and we are going to create front-end using JavaScript communicating with the seerver via Ajax requests.



## Create project

After installing [Dancer2](https://metacpan.org/pod/Dancer2) I created the skeleton of the new project by running
`dancer2 -a D2::Ajax`:

```
$ dancer2 -a D2::Ajax

+ D2-Ajax
+ D2-Ajax/config.yml
+ D2-Ajax/cpanfile
+ D2-Ajax/Makefile.PL
+ D2-Ajax/MANIFEST.SKIP
+ D2-Ajax/bin
+ D2-Ajax/bin/app.pl
+ D2-Ajax/bin/app.psgi
+ D2-Ajax/environments
+ D2-Ajax/environments/development.yml
+ D2-Ajax/environments/production.yml
+ D2-Ajax/lib/D2
+ D2-Ajax/lib/D2/Ajax.pm
+ D2-Ajax/public
+ D2-Ajax/public/dispatch.cgi
+ D2-Ajax/public/dispatch.fcgi
+ D2-Ajax/public/404.html
+ D2-Ajax/public/500.html
+ D2-Ajax/public/favicon.ico
+ D2-Ajax/public/css
+ D2-Ajax/public/css/error.css
+ D2-Ajax/public/css/style.css
+ D2-Ajax/public/images
+ D2-Ajax/public/images/perldancer-bg.jpg
+ D2-Ajax/public/images/perldancer.jpg
+ D2-Ajax/public/javascripts
+ D2-Ajax/public/javascripts/jquery.js
+ D2-Ajax/t
+ D2-Ajax/t/001_base.t
+ D2-Ajax/t/002_index_route.t
+ D2-Ajax/views
+ D2-Ajax/views/index.tt
+ D2-Ajax/views/layouts
+ D2-Ajax/views/layouts/main.tt
```

It created the `D2-Ajax` subdirectory and a bunch of files in it.

Then I changed  directory and created the Git repository.

```
$ cd D2-Ajax
$ git init

Initialized empty Git repository in /Users/gabor/work/D2-Ajax/.git/
```

Added all the files and created the initial commit.

```
$ git add .
$ git commit -m "initial"

[master (root-commit) f54eade] initial
 24 files changed, 699 insertions(+)
 create mode 100644 MANIFEST
 create mode 100644 MANIFEST.SKIP
 create mode 100644 Makefile.PL
 create mode 100755 bin/app.pl
 create mode 100755 bin/app.psgi
 create mode 100644 config.yml
 create mode 100644 cpanfile
 create mode 100644 environments/development.yml
 create mode 100644 environments/production.yml
 create mode 100644 lib/D2/Ajax.pm
 create mode 100644 public/404.html
 create mode 100644 public/500.html
 create mode 100644 public/css/error.css
 create mode 100644 public/css/style.css
 create mode 100755 public/dispatch.cgi
 create mode 100755 public/dispatch.fcgi
 create mode 100644 public/favicon.ico
 create mode 100644 public/images/perldancer-bg.jpg
 create mode 100644 public/images/perldancer.jpg
 create mode 100644 public/javascripts/jquery.js
 create mode 100644 t/001_base.t
 create mode 100644 t/002_index_route.t
 create mode 100644 views/index.tt
 create mode 100644 views/layouts/main.tt
```

I've also [created](https://github.com/) a [GitHub repository](https://github.com/szabgab/D2-Ajax) for the project
and pushed out the code so far.

```
$ git remote add origin git@github.com:szabgab/D2-Ajax.git
$ git push -u origin master
Counting objects: 36, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (32/32), done.
Writing objects: 100% (36/36), 49.35 KiB | 0 bytes/s, done.
Total 36 (delta 3), reused 0 (delta 0)
To git@github.com:szabgab/D2-Ajax.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from origin.
```


[commit](https://github.com/szabgab/D2-Ajax/commit/f54eade446f8ac138eb6d095461df8a570569538)

## Run tests

Then I ran the tests that came with the skeleton. The usual ritual for Perl projects:

```
$ perl Makefile.PL
$ make
$ make test
```

That worked, but as `git status` can show, it created a number of helper files.

```
$ git status

On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

    MYMETA.json
    MYMETA.yml
    Makefile
    blib/
    pm_to_blib

nothing added to commit but untracked files present (use "git add" to track)
```


## Create .gitignore

We don't want those to enter the repository by mistake when we use `git add .`
so it is better to create a `.gitiignore` file with the following content:

```
/MYMETA.json
/MYMETA.yml
/Makefile
/blib/
/pm_to_blib
```

and add it to the repository:

```
$ git add .gitignore
$ git commit -m "add .gitignore"
```

[commit](https://github.com/szabgab/D2-Ajax/commit/ce62f3184240d2feb282baf74248d2d7ccdd65bb)

## Clean up skeleton

Before starting with the real thing, I wanted to remove some part of the skeleton, so it wont' get in the way.
Specifically I've replaced the content of the main template in `views/index.tt` by just one line:

```
Dancer Ajax example
```

I've also removed all the content of the CSS file `public/css/style.css` and 
In the `views/layouts/main.tt` file I've removed the footer section that had "Powered by Dancer2" in it.
I'd rather focus on the task ahead.

[commit](https://github.com/szabgab/D2-Ajax/commit/e9309ac03e8ddde2b1d82f7d2f695e5ad78f03c5)


## Gitignore swap files

A minor thing I've forgotten earlier is to put `*.swp` in the `.gitignore` file
to avoid swap files created by vim to Git by mistake.

[commit](https://github.com/szabgab/D2-Ajax/commit/1a49fafa41f6af1ae789995e4cbce6093d79723b)

## Try the empty application

In case you'd like to try the empty application you can launch a web server using

```
$ plackup -R lib bin/app.psgi 
```

and then you can visit the web site by accessing `http://127.0.0.1:5000/`

It should be a white page with "Dancer Ajax example" on it.

## Route returning JSON

In Dancer we need to add "routes" that map URLs to actions. More specificaly a "route" maps
a URL to an anonymous function. The return value of that functions is going to be the response
of this requst.

By default `lib/D2/Ajax.pm`, the Perl module implementing our site contains a single route:

```perl
get '/' => sub {
    template 'index';
};
```

This means that if a `GET` request arrives to the root of the web server (`/`) it will
generate an HTML page using the "index" template that can be found in `views/index.tt`.
(The file we put "Dancer Ajax example" earlier in.)

We add another route to that file:

```perl
get '/api/v1/greeting' => sub {
    header 'Content-Type' => 'application/json';
    return to_json { text => 'Hello World' };
};
```

This means that if someone accesses the `/api/v1/greeting` URL with a `GET` request,
the server will set the "Content-Type" of the response to be "application/json" and then
it will send a stringified JSON object created from the hash reference `{ text => 'Hello World' }`.

In the URL I've included `v1` to make it easier to create several versions of the API. This is version 1.

Before creating the client side, we should test whether this works properly. For this we create a new
test file called `t/v1.t` with the following content:

```perl
use strict;
use warnings;

use D2::Ajax;
use Test::More tests => 1;
use Plack::Test;
use HTTP::Request::Common;

subtest v1_greeting => sub {
    plan tests => 3;

    my $app = D2::Ajax->to_app;

    my $test = Plack::Test->create($app);
    my $res  = $test->request( GET '/api/v1/greeting' );

    ok $res->is_success, '[GET /] successful';
    is $res->content, '{"text":"Hello World"}';
    is $res->header('Content-Type'), 'application/json';
};
```

In the test `$app` represents our application and `$test` is the web browser
(like [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)).
It knows about our application as it received it in the constructor of `Plack::Test`.
With `$test->request` we send a request to the application that runs in the same process. It returns a
a [HTTP::Response](https://metacpan.org/pod/HTTP::Response) object that can be interrogated.

In the 3 assertions we check if the request was successfule, if the content is as expected (a stringified JSON object), 
and if the header was set correctly.

We can now run the tests

```
$ make test
```

and observe that everything is fine.

```
$ git add .
$ git commit -m "add a route returning JSON"
```

[commit](https://github.com/szabgab/D2-Ajax/commit/0c645133fb7d48355b144e66a834feacafcc99e4)

If you still have the web server running you can visit `http://127.0.0.1:5000/api/v1/greeting`
and see the returned string `{"text":"Hello World"}`.

Alternatively, you can open a separate console and run 

```
$ curl http://127.0.0.1:5000/api/v1/greeting
```

That will fetch the page and print it on the console.

## Add page sending Ajax request

The next step is to create a page that will send an Ajax request to the route we have created earlier
and display the result.

First of all we create the template called `views/v1.tt` that contains a bit of HTML (a single `div`) and
some JavaScript code using jQuery. (In a real application we would probably put the JavaScript in a separate
file.)

```perl
<div id="msg"></div>

<script>
$(document).ready(function() {
    jQuery.get('/api/v1/greeting', function(data) {
        console.log(data);
        $("#msg").html(data["text"]);
    });
});
</script>
```

In case you are not familiar with jQuery, `$(document).ready()` will execute the function passed to the 
`ready` function when the page has been  fully rendered.

Then there is an anonymous function defined with `function() { ... }` that will be executed when the
document is ready.

`jQuery.get('/api/v1/greeting', ... ` sends an asynchronous request to the given path on the same server where
the page containing this code came from and once the resones has arrived it will call the (anonymous) function passed
to it. That function will receive the response as the first parameter. (This is what will be in `data`),
but depending on the Content-Type of the page, the response will be processed first. If the server sends
`application/json` as Content-Type then jQuery will first parse the response as JSON and will call
the anonymous function with the JavaScript object.

Inside the anonymous function we print the data to the console, just so we can see the whole structure,
and then we take the value of the "text" key (in `data["text"]`) and put it on the page.

`$("#msg")` will locate the object on the page with the id "msg" which is the `div` element
we have on the page. The `html` method can set the content of the given page. 

OK. So we have the HTML and JavaScript part of the page, but how can we try this?
In order to show this template as a page we need to create a new route so we add the following
lines to `lib/D2/Ajax.pm`:

```perl
get '/v1' => sub {
    return template 'v1';
};
```

This is a simple route that returns the `views/v1.tt` template.

Once we have both of these in place we can access `http://127.0.0.1:5000/v1` and
it will display "Hello World".

Congratulation, you've created the first web application in which the client talks to the server
via Ajax.

If you open the JavaScript console  of your browser then you can see something like this: `Object {text: "Hello World"}`.

We can now commit this change.

[commit](https://github.com/szabgab/D2-Ajax/commit/99034e178ea414924c42cc355d6478ff7f84555e)


## Comments

I am getting virtually unending errors. It started with the git repo not being there. I found one that seemed to be right, and did a git clone. But the errors are so plentiful I'm thinking there was a mistake in the repo. Is this still a working page/example?

This is the perfect dealio for what I am looking for. I have a d2 site that I have been asked to make more dynamic, which seems to be AJAX. This page really lifted my hopes that I could push through the process pretty easily.

<hr>

If you head over to https://github.com/szabgab/D2-Ajax you can download the zip file if you do not have git.

If you get an error like:

"Error while loading C:\D2-Ajax-master\bin\app.pl: Can't locate MongoDB.pm in @INC (you may need to install the MongoDB module)"
then you need to install additional libraries for Perl (I assume you have Perl in your Linux or Strawberry perl on your Windows machine).

We install them using CPAN (or CPANm), in my case, just:
"cpan MongoDB" will install that (coffee break required, it takes a while; the Windows version requires you to press enter).

I then get some warnings for http://localhost:5000/

but the example (http://localhost:5000/v1) works.

C:\D2-Ajax-master\bin>plackup -R . app.pl
Watching . ./lib app.pl for file updates.
Prototype mismatch: sub D2::Ajax::encode_json: none vs ($) at C:/Strawberry/perl/lib/Exporter.pm line 66.
at C:/D2-Ajax-master/bin/../lib/D2/Ajax.pm line 4.
Prototype mismatch: sub D2::Ajax::decode_json: none vs ($;$) at C:/Strawberry/perl/lib/Exporter.pm line 66.
at C:/D2-Ajax-master/bin/../lib/D2/Ajax.pm line 4.
HTTP::Server::PSGI: Accepting connections at http://0:5000/
[D2::Ajax:-116] core @2016-11-28 15:32:49> looking for get / in C:/Strawberry/perl/site/lib/Dancer2/Core/App.pm l. 34
[D2::Ajax:-116] core @2016-11-28 15:32:49> Entering hook core.app.before_request in (eval 59) l. 1
[D2::Ajax:-116] core @2016-11-28 15:32:49> Entering hook core.app.after_request in (eval 59) l. 1
127.0.0.1 - - [28/Nov/2016:15:32:49 +0100] "GET / HTTP/1.1" 200 631 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0"

