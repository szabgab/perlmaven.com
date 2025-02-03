---
title: "Mojolicious::Lite with embedded templates"
timestamp: 2013-08-28T17:30:01
tags:
  - files
published: true
books:
  - mojolicious
author: szabgab
---


In the [first few examples of Mojolicious::Lite](/getting-started-with-mojolicious-lite) we had our very simple HTML
embedded in the Perl code. This was good just to get our feet wet, but soon we'd like to
have some separation between Perl and HTML. Let's see how can we do this using Mojolicious::Lite.


We finished the [echo example](/getting-started-with-mojolicious-lite) with the following script:

```perl
use Mojolicious::Lite;
get '/' => { text => 'Hello World' };

get '/echo' => { text => q{
   <form method="POST"><input name="q"><input type="submit" value="Echo"></form>
}};

post '/echo' => sub {
    my $self = shift;
    $self->render( text => $self->param('q') );
};

app->secret('My extra secret passphrase.');

app->start;
```

Let's save it in a file called `hello_world.pl` and run it
as `morbo hello_world.pl`

Then visit the [http://localhost:3000/echo](http://localhost:3000/echo) to
see it is working before we make changes.

<img src="/img/mojolicious_lite_echo_form.png" alt="Mojolicious::Lite echo form" />

## The echo template

We replace the `get '/echo'` route with the following code:

```perl
get '/echo' => sub {
    my $self = shift;
    $self->render('echo');
};
```

It is a bit similar now to the `post` method of the `/echo` route
in that here too we use an anonymous subroutine, but the call to the `render`
method is a bit different. Instead of passing the `text` key with the actual
HTML we want to send back, we pass in the name of our template.

The template itself can be added to the end of the file, after the `__DATA__` tag.
This `__DATA__` tag is a general Perl syntax that allows us to include pieces
of data within our script and then access it using the `<DATA>` file-handle.
Mojolicious::Lite uses this feature of Perl to allow us to include the templates
in the script but separate from our actual Perl code.

The `@@` syntax is used by the templating system of Mojolicious as a way to mark
where each template starts. `echo.html.ep` is the mark of the template that we can
render as the <b>echo</b> template.

```perl
__DATA__

@@ echo.html.ep

What are you looking for?
<form method="POST"><input name="q"><input type="submit" value="Echo"></form>
```

The actual HTML code was changed so when we reload the page we can see that it has
indeed changed and it already comes from the template:

<img src="/img/mojolicious_lite_echo_form_from_template.png" alt="Mojolicious::Lite echo form" />

The code should look like this now:

```perl
use Mojolicious::Lite;
get '/' => { text => 'Hello World' };

get '/echo' => sub {
    my $self = shift;
    $self->render('echo');
};

post '/echo' => sub {
    my $self = shift;
    $self->render( text => $self->param('q') );
};

app->secret('My extra secret passphrase.');

app->start;

__DATA__

@@ echo.html.ep

What are you looking for?
<form method="POST"><input name="q"><input type="submit" value="Echo"></form>
```

## Server the response from a template too

This time we change the code of the `POST` method handling the `/echo`
route. The `render` method receives the name of the template as the first
parameter and then we can pass key-value pairs. They values will be accessible in
the template using the keys as scalar variables.

```perl
post '/echo' => sub {
    my $self = shift;
    $self->render( 'response', msg => $self->param('q') );
};
```

The template itself is added to the end of the code, after the previous template:

```perl
@@ response.html.ep

You typed: <%= $msg %>
```

Mojolicious::Lite allow us to the keys we passed as if they were scalar variable
and the following syntax embeds the value in our template: `<%= $msg %>` 

We can now type something in the form, click on <b>Echo</b> and see
the new response built from the template.

## Connect the POST method to the same template

There are cases when the request page and the response page are really very different,
and we need two separate templates, but in other cases we might want them to be
served from the same template. For example, we might want the form to stay on the
responses page. So we merge the two templates together to get:

```perl
__DATA__

@@ echo.html.ep

What are you looking for?
<form method="POST"><input name="q"><input type="submit" value="Echo"></form>

You typed: <%= $msg %>
```

Of course we also change the `POST` handler to pass the template name
'echo' instead of 'response'.

As morbo has already restarted our server, we can just reload the page now.
Because this is a POST-request, the browser will ask us if we want to re-submit the form.
In Google Chrome it will look like this:

<img src="/img/google_chrome_post_reload_confirmation.png" alt="Google Chrome POST reload confirmation pop-up" />

Once we click the <b>Continue</b> button we will see the new page that includes both the form
and the text we typed earlier:

<img src="/img/mojolicious_lite_echo_form_and_response.png" alt="Mojolicious::Lite echo form and response" />

So let's try to reload the original page now by clicking on the
link to [http://localhost:3000/echo](http://localhost:3000/echo).

We will get a huge error message:

<img src="/img/mojolicious_lite_missing_variable_error.png" alt="Mojolicious::Lite missing variable error message" />

This is the well known Perl error
[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name),
but displayed in a nice way.

The problem is that in our shared template we use the `$msg` variable, but we pass it only in the POST-handler
as only there has it any value.

I am not sure if this is the best solution, but we can change the call to `render` in the GET-handler
and replace `$self->render('echo');` by `$self->render('echo', msg => undef);`.
That way we'll have the `$msg` variable, but it will be [undef](/undef-and-defined-in-perl).

The resulting page is still not perfect, but at least it is not crashing:

<img src="/img/mojolicious_lite_echo_form_with_undef.png" alt="Mojolicious::Lite echo form with undef" />

The problem is that we still display the text <b>You typed:</b> even though we have not typed anything.

## Conditionals in the template

The templating system that comes with Mojolicious is very powerful and allows us to embed Perl code
using `%` to mark lines with Perl code:

```perl
% if (defined $msg) {
You typed: <%= $msg %>
% }
```

You can even indent the HTML between the Perl snippets as in HTML white-space has no impact.

```perl
% if (defined $msg) {
    You typed: <%= $msg %>
% }
```

## Exercise

Now it would be a good time to do a little exercise. The current version of our code
looks like this:

```perl
use Mojolicious::Lite;

get '/' => { text => 'Hello World' };

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
```

Two of the 3 routes are already using templates. Please, change the script so
the `/` route will be served using a template called 'index'.

If you'd like to show your solution, please fork this
[GitHub repository](https://github.com/PerlMaven/mojolicious-lite-add-embedded-template)
make the changes and send a pull request. I won't merge it but we all can comment on it.

