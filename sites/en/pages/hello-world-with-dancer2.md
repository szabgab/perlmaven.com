---
title: "Hello World with Dancer2"
timestamp: 2015-05-20T00:30:01
tags:
  - Dancer2
  - dancer2
  - get
  - plackup
published: true
books:
  - dancer2
author: szabgab
archive: true
---


There are two ways you can get started with a Perl Dancer based web project.

The single-file way and using the Dancer 2 skeleton. In this article we'll see both.


## Install Dancer2

In any case first you'll need to install Dancer 2. You can do that by using
[cpam minus](http://cpanmin.us/):  

```
$ cpanm Dancer2
```

## Single-file approach

{% include file="examples/dancer2_hello_world.pl" %}

First we load `Dancer2`. We don't need to load `strict` and `warnings` as those are loaded
implicitly by Dancer2.

The next expression: defines a "route" and maps it to an anonymous subroutine.

```perl
get '/' => sub {
    "Hello World!"
};
```

While the above syntax looks nice, it might be strange to some Perl developers. We could write the above in
another way:

```perl
get('/',  sub { "Hello World!" });
```

In this form it is quite obvious that `get` is a function imported from the Dancer2 module.
It accepts two parameters. The first one is a URL path on our server, in this case the root of all the
path-es. The second parameter is a reference to a function, in this case this is an anonymous function
created on-the-fly.

Then we call the `dance` function also imported from the Dancer2 module.

We can run the Dancer application just as we would run any other Perl script:

```
$ perl dancer2_hello_world.pl 
```

At this point Dancer launches a small web sever, and prints the following to the command line:

```
>> Dancer2 v0.158000 server 23376 listening on http://0.0.0.0:3000
```

and then it waits till you browse to the given url.

Though actually I prefer to browse to http://127.0.0.1:3000/

When we type this URL into my browser, the browser will send a `GET /` request to
the server we've just launched. When Dancer sees the request for the `/` route
it checks if there is any already defined route matching it.

As we have mapped `/` to a subroutine. Dancer will then call that anonymous subroutine,
and whatever it returns will be the response sent to the client.

In our case this will be the string "Hello World!".

The `get` function of Dancer effectively added a key-value pair to a dispatch table. The key is the route
(`/` in this case). The value is the subroutine that needs to be called when the route matches.

That's all you need to do in order to create a simple hello-world application using Dancer2.

## Dancer2 using the skeleton

The approach is to use the `dancer2` command-line utility that was installed when we installed Dancer2 itself,
to create a skeleton of a web application.

On the command line run the following:

```
$ dancer2 -a Try::Me
```

This will create a directory called <b>Try-Me</b> and inside that directory it will put a bunch of subdirectories
and files. You can `cd Try-Me` and launch the new application by typing in

```
$ plackup -R . bin/app.psgi
```

This will launch the small built-in web server and print the following:

```
Watching . bin/lib bin/app.psgi for file updates.
HTTP::Server::PSGI: Accepting connections at http://0:5000/
```

Even though it prints the host <b>http://0:5000/</b> that never worked for me using Chrome,
so I browse to <b>http://127.0.0.1:5000/</b> that seems to be working.
I filed [this issue](https://github.com/PerlDancer/Dancer2/issues/862) in case you
want to see if this is a real issue or not.

Browsing to that page will show the default page Dancer provides.

Try accessing <b>http://127.0.0.1:5000/welcome</b> and you'll get a big `Error 404 - Not Found`.

Now, without even shutting down the server, edit the `lib/Try/Me.pm` file.
Originally it had this content:

```perl
package Try::Me;
use Dancer2;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

true;
```

and we add the following 3 lines above the `true;` statement:

```perl
get '/welcome' => sub {
    return 'Hello World';
};
```

We can now reload the <b>http://127.0.0.1:5000/welcome</b> page in the browser and it
will show the plain text "Hello World".

Congratulations. You have just created the first Dancer2 application with the skeleton.


## Automatic reload

The fun part was that when we launched the application we included the `-R .` parameters.
This tells `plackup` to monitor all the files in the directory tree starting from
the current directory and if anything changes reload the application. This makes development
much faster as we don't need to manually stop and start the application after every change.

## Comments

Thanks for the tip about using -R with plackup. It really makes debugging easier

<br>

Seems to be a bug in Files::Notify::Simple that is causing the plackup -R feature to break on Windows 7. It has a ticket filed but no resolution as of May 26, 2017 (today) -- https://github.com/miyagawa/Filesys-Notify-Simple/issues

I'm using
plackup bin/app.psgi
and all is working well (though without an automatic reload).

Thanks for this tutorial!

<br>

Is there a benefit from and a practical way to add Dancer2 to existing Perl v.5.16 / CGI running on Apache 2.4? Suppose I need to add a new page to the legacy application and I want a better way to do it than just follow the old pattern and use CGI methods and print command to output HTML. Should I drop a dancer skeleton into cgi-bin and try to make it work for this and future new pages, or should I take a middle path and simply use templates? In other words, can Dancer2's strengths work and be taken advantage of inside existing cgi-bin folders? My server has one IP address and that's what users around the company use to get to it.

--
In such case I would probably start by using a template system as you also suggested and maybe start using PSGI in CGI mode. See this post for examples: https://perlmaven.com/echo-with-plack-cgi Then I'd probably switch over the old code to PSGI and to start using template system. Assuming I have the time and the need to modernize the infrastructure.


---

Thank you Gabor, this is great. Last question if you do not mind. In this context, what would you name as the immediate and most important advantage of using PSGI in CGI mode + templates for these new pages, as opposed to using CGI with templates?
---

Templates: separation of languages makes it easier to maintain and it can allow the separation on who works on what. - You can easily give text edition to someone with know Perl or programming background.

PSGI: Making it easier to test your application, allowing you to run on other web servers as well.

See also https://perlmaven.com/plack-app-cgibin

