---
title: "Counter with Dancer Sessions"
timestamp: 2015-12-11T12:50:01
tags:
  - Dancer
  - session
published: true
books:
  - dancer2
  - counter
author: szabgab
---


How to create a personal [counter](https://code-maven.com/counter) with only a session object in the [Perl Dancer](/dancer) framework?


We create a Dancer application using `dancer2 -a Counter` and change directory to the project: `cd Counter`

We launch the application using plack:

```
$ plackup -R . bin/app.psgi
```

The `-R .` will monitor the whole directory structure and if anything changes it will reload the application.

We enable session management in the `config.yml` file by adding the following line:

```
session: "YAML"
```

(According to the [documentation](https://metacpan.org/pod/distribution/Dancer2/lib/Dancer2/Manual.pod)
one needs to enable sessions, but in fact, probably due to a [bug](https://github.com/PerlDancer/Dancer2/issues/884),
Simple, in-memory sessions are enabled by default. Nevertheless, in order to have sessions that survive the restart of the
application we need to enable the above.)

Then we can browse to [http://127.0.0.1:5000/](http://127.0.0.1:5000/) and see the default page of Dancer.

A session is identified by a cookie the server sends to the browser, but it will only generate the cookie
if we actually store a value in the session. The value will be store on the server in the `sessions/` subdirectory
of the project in a YAML file. (Dancer could use other back-ends for session management, but using YAML files is the most simple
persistent way to store session data.)

You can check, the `sessions/` directory is empty now, if it even exists.

In order to set a value in the session we call the `session` function in our Dancer application.

## Setting a value in a session

This is how we change the `lib/Counter.pm` file:

```perl
get '/' => sub {
    session('cnt' => 1);
    template 'index';
};
```

After saving the change we can reload the web page.

Opening the developer tools of our browser we can see a new Cookie added to 127.0.0.1:

```
dancer.session  VTChcQABUqiiJ0PMHVAnTkm0p_F7nYnk    127.0.0.1    /   Session 50  ✓       
```

The long string is the cookie identifier and it will be unique on your server.

If we look at the file system, we can see that Dancer created a new directory in the project called `sessions/`,
(if it did not exist earlier) and put a single file in it called `VTChcQABUqiiJ0PMHVAnTkm0p_F7nYnk.yml`.
Note, the name of the file is the value of the cookie. By default, the name of the cookie is `dancer.session` and the cookie
was set to be part of the `127.0.0.1` domain that served this page.

The yaml file contains the key-value pair we added to it:

```
$ cat sessions/VTChcQABUqiiJ0PMHVAnTkm0p_F7nYnk.yml 
---
cnt: 1
```

If we reload the page at [http://127.0.0.1:5000/](http://127.0.0.1:5000/) we won't see any change in the display,
as we have not changed the page itself yet.

To cookie in the browser does not contain any information besides the value of the cookie which is the session id.
The key-value pair we set in the cookie is stored on the server in the YAML file.

If we now visited the same page using a different browse, that browser would get a different cookie and the Dancer
application would create another YAML file.

## Fetching the value from the session

In order to fetch the value from the session object, we can use the `session` function again, this time with only one parameter:

```perl
get '/' => sub {
    #session('cnt' => 1);
    my $counter = session('cnt');
    template 'index';
};
```

For the time being we have disabled setting the session so we can see that the value of 'cnt' is indeed fetched from the YAML
file created when we accessed the page earlier.

Of course the above code does not let us see what was in the session so let's print it out to the console by adding `debug()`
call to our code:

```perl
get '/' => sub {
    #session('cnt' => 1);
    my $counter = session('cnt');
    debug("Counter: $counter");
    template 'index';
};
```

If we now reload the web page and then switch to the console window where we ran `plackup` we can go through the output there
and see a line that looks like this:

```
[Counter:86744] debug @2015-04-17 09:38:47> Counter: 1 in ...
```

This is the output of the `debug()` call in our application.

## Incrementing the counter

Now we can combine the two operations, the setting of the value in the session and the fetching of the value.
We can also increment our counter in the same route:

```perl
get '/' => sub {
    my $counter = session('cnt') || 0;
    $counter++;
    debug("Counter: $counter");
    session('cnt' => $counter);
    template 'index';
};
```

1. We fetch the value from the session file or set it to 0 if there was no value in the session file yet.  This is to nicely handle the case when a new browser visits the page.
1. Increment the counter and print it to the console of the web application.
1. Save the new value in the session object and thus in the session YAML file.

If we now reload the browser several times, we'll be able to see the counter incrementing on the console.
Unfortunately we'll also see the plackup server restarting itself after every time we load the page.

This, as I found out later, is because the `-R .` flag tells plackup to restart the server if **any** file changes in the
whole directory tree. As we keep updating the session file in the `sessions/` directory, plackup
will keep reloading the server.

A probably better way to start the application would be:

```
$ plackup -R config.yml,lib bin/app.psgi
```

This way, plackup will only monitor the `config.yml` file and the `lib` directory.

Maybe even better to also monitor the environments/ directory as well, where additional configuration files can be found:

```
$ plackup -R config.yml,lib,environments bin/app.psgi
```


## Displaying the counter in the browser

We now already have a counter for the individual visitor, but the counter is only displayed on the console
of the server. To make a bit fancier, we can also include the value of the counter in the HTML sent to the client.

For this we change the call to the `template` and pass a key-value pair where the value is the
counter:

```perl
get '/' => sub {
    my $counter = session('cnt') || 0;
    $counter++;
    debug("Counter: $counter");
    session('cnt' => $counter);
    template 'index', { count => $counter };
};
```

We also change the views/index.tt template. We can remove all the content and have only the following:

```
Count: <% count %>
```

Now, if we reload the page in the browser we can see the counter incrementing in the browser as well.

If we open another browser we can see it has a separate counter.

## Per session counter

So this counter we created is not the same kind of counter we wanted to create in the big [counter example](https://code-maven.com/counter)
project, but still a useful exercise in using sessions and cookies.


