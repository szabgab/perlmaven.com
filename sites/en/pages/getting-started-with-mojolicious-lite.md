---
title: "Getting started with Mojolicious::Lite"
timestamp: 2015-04-30T08:00:01
tags:
  - Mojolicious::Lite
published: true
books:
  - mojolicious
author: szabgab
---


[Mojolicious](/mojolicious) is one of the relatively new, light-weight,
[modern web application frameworks](/modern-web-with-perl)
of Perl. If you look at its web site, it is full of rainbows, clouds and unicorns.

In this article we'll see how to get started with it, or more specifically with
[Mojolicious::Lite](https://mojolicious.org/perldoc/Mojolicious/Lite).


## Installing Mojolicious

If you already have a CPAN client configured, you can install Mojolicious
with the regular command `cpan Mojolicious`.

Otherwise on Linux systems you can first install [cpanminus](http://cpanmin.us/)
by typing `curl -L http://cpanmin.us | perl - App::cpanminus`.
Then you can install Mojolicious by typing `cpanm Mojolicious`.

## Hello World

Save the following code as `hello_world.pl`:

{% include file="examples/mojolicious/lite/hello_world.pl" %}

And run it with `morbo hello_world.pl`. It will print the following to the screen:

```
Server available at http://127.0.0.1:3000.
```

Now you can take your browser and point it to [http://localhost:3000](http://localhost:3000).

You will see `Hello world`.

<img src="/img/mojolicious_lite_hello_world.png" alt="Mojolicious::Lite Hello World " />

Congratulations! You've just created your first web application with Perl and [Mojolicious](/mojolicious).

This code is quite simple. After loading the module with `use Mojolicious::Lite;`, we defined
a `route`:
A route is just a path in he URL and some code that will be executed when a browser sends a `get` request to the given path on the server. In our case the path is the root of our web site (`/`).
The function returns the `text`, `Hello World`.  Please note, there is a `;` at the end of the block.

The reason for that is that the block is actually just the second parameter of the `get` function
imported by `Mojolicious::Lite`, and in Perl statements are separated by semicolons.

The final line `app->start;` starts the web application.

As you might have noticed even though we recommend
to <a href="/always-use-strict-and-use-warnings">always included `use strict` and `use warnings`</a>,
we have not done it in this case.
This is because including `Mojolicious::Lite` automatically turns on these pragmata. Actually along with
`utf8` and `features`.

The `morbo` command runs our "application" using a small, built-in web server.

Now take a look at the console, where you ran `morbo`. You will see some extra lines printed:

```
Server available at http://127.0.0.1:3000
[Sat May 28 15:16:19 2016] [debug] GET "/"
[Sat May 28 15:16:19 2016] [debug] 200 OK (0.001099s, 909.918/s)
```


## Error pages

What if we browse to a different page on our new web site?
Let's try [http://localhost:3000/echo](http://localhost:3000/echo).

We will see a page like this:

<img src="/img/mojolicious_lite_simple_error.png" alt="Mojolicious::Lite simple error page" />

Earlier versions of Mojolicious had a much simpler error page:

<img src="/img/mojolicious_lite_simple_error_old.png" alt="Mojolicious::Lite simple error page - old version" />

This is a simple error page that list all the existing routes (we currently only have one)
and links to the Mojolicious web site where we can get help. Very nice.

If we look at the console again however we see the following output:

```
Server available at http://127.0.0.1:3000
[Sat May 28 15:26:03 2016] [debug] GET "/"
[Sat May 28 15:26:03 2016] [debug] 200 OK (0.001691s, 591.366/s)
[Sat May 28 15:26:09 2016] [debug] GET "/echo"
[Sat May 28 15:26:09 2016] [debug] Template "not_found.development.html.ep" not found
[Sat May 28 15:26:09 2016] [debug] Template "not_found.html.ep" not found
[Sat May 28 15:26:09 2016] [debug] Rendering template "mojo/debug.html.ep"
[Sat May 28 15:26:09 2016] [debug] Rendering template "mojo/menubar.html.ep"
[Sat May 28 15:26:09 2016] [debug] Your secret passphrase needs to be changed
[Sat May 28 15:26:09 2016] [debug] 404 Not Found (0.060596s, 16.503/s)
```

There is a line which is a bit strange. It tells us that we need to set our secret passphrase.

## Your secret passphrase needs to be changed!!!

As explained in
[the documentation](http://mojolicious.org/perldoc/Mojolicious/Guides/FAQ#What-does-Your-secret-passphrase-needs-to-be-changed-mean), we can do that by calling `app->secrets(['My very secret passphrase.']);` just before calling
`app->start;`.

Stop the server by pressing `Ctrl-C` on the console where you see the log messages, start it again by running
`morbo hello_world.pl`. If you reload the page now and check the log messages, you'll see the warning does not
show up any more.

The full script looks like thos now:

{% include file="examples/mojolicious/lite/hello_world_with_secret.pl" %}

Of course, if you have a public facing application, you might want to use some other super secret passphrase.

In earlier versions of Mojolicious this call looked a bit different. It was in singular and accepted a single string instead
of an array of strings. Like this: `app->secret('My very secret passphrase.');`.

## Echo form

Let's add the `echo` route to our application:

```perl
get '/echo' => { text => q{
   <form method="POST"><input name="q"><input type="submit" value="Echo"></form>
}};
```

This is the same syntax as for the `/` route handler, but this time
our text already includes an HTML form.

We can even do this while the server is running. When we save the file,
`morbo` will notice this, and restart the application.

Now we can reload the [/echo](http://localhost:3000/echo) page.
We are going to see something like this:


<img src="/img/mojolicious_lite_echo_form.png" alt="Mojolicious::Lite echo form" />


I know this is not extremely exciting, just a regular HTML form, but we are making
progress which is great!

## Submit the echo form

We can now type in some text and press the `Echo` button.

We'll see this:

<img src="/img/mojolicious_lite_missing_post_error.png" alt="Mojolicious::Lite missing POST route error" />

Again, earlier versions of Mojolicious used to show a much simpler response:

<img src="/img/mojolicious_lite_missing_post_error_old.png" alt="Mojolicious::Lite missing POST route error" />

We are already familiar with this kind of error page, but what happened now?
We have two routes declared to `/` and `/echo` but only using the `GET method`. Our
form was deliberately using `POST method`. 

The point is, that Mojolicious::Lite allows us to define separate routes to each path and to each HTTP method.
This provides much finer control to us, the developers.

So let's implement the code that deals with the form submission. Let's add the following code to our
`hello_world.pl` file.

```perl
post '/echo' => sub {
    my $self = shift;
    $self->render( text => $self->param('q') );
};
```

In this code, we define the action we want to do when the `post` method is invoked on the
`/echo` route.  Because we want to do something more complex than just return a fixed string,
instead of a plain block, we pass to the `post()` function an <b>anonymous subroutine</b>
created by the `sub` keyword.

In the anonymous subroutine we copy the current Mojolicious object into the "standard" `$self`
variable and we use it for two things.
We call the `param` method to receive the value typed in by the user
(the string `q` was the name of the input field in our HTML page) and then
we call the `render` method to create the page we return that will only contain
what we typed in.

`morbo` will automatically restart our web server and we can reload the page in our browser.
The result is the text we typed in:

<img src="/img/mojolicious_lite_welcome.png" alt="mojolicious_lite_welcome.png" />

## Welcome to Mojolicious

The full code looks like this:

{% include file="examples/mojolicious/lite/echo.pl" %}

