---
title: "Sessions and Cookies using Dancer"
timestamp: 2014-01-15T07:30:01
tags:
  - files
published: false
books:
  - dancer
author: szabgab
---


Cookies


By default Dancer does not set any cookies and it does not handle user "sessions".

In order to convince Dancer to start sending cookies we need to enable sessions in one of the configuration files.
In config.yml there is alread a commented out entry for that. Just enable

```
session: "YAML"
```

in `congig.yml` and restart your application and visit your [development page](http://localhost:3000/).

And nothing happens. Even if you open the developer tools of your browser you won't see any cookies mentioned.

This is because cookies are only created and sent to the user if the URL we requested contains at least two periods `.`.
(See [cookie spec](http://curl.haxx.se/rfc/cookie_spec.html)). So you can either use 
[http://127.0.0.1:3000/](http://127.0.0.1:3000/) if you are lazy, but then if you have more than one
projects in development, their cookies will get mixed, or you can invest 1 minute to set up some local hostnames:

I think it is better to add an entry to the `/etc/hosts` file on Unix/Linux or to the `C:\Windows\System32\Drivers\etc\hosts`
file on MS Windows to map a few hostnames to your local machine.

I added the following line

```
127.0.0.1 a.local.host b.local.host c.local.host d.local.host
```

and then I could browse to [http://a.local.host:3000/](http://a.local.host:3000/).

Opening the developer tools of by browser I can see a new Cookie added to a.local.host:

```
dancer.session  503155064674153239941499197960160199    a.local.host    /   Session 50  ✓       
```

If I look at the file system, I can see that Dancer created a new directory in my project called `sessions/`,
and put a single file in it called `503155064674153239941499197960160199.yml`. Note, the name of the file
is the Value of the cookie. By default, the name of the cookie is `dancer.session` and the cookie
was set to be part of the `a.local.host` domain.


The yaml file is virtually empty. It only contains the session id, which is the same as the filename:

```
$ cat sessions/503155064674153239941499197960160199.yml 
--- !!perl/hash:Dancer::Session::YAML
id: 503155064674153239941499197960160199
```

In order to store a value in the session object we can use the `session` function provided by Dancer:


```perl
get '/' => sub {
    session('answer' => 42);
    template 'index';
};
```

will set a key called `answer` with a value of `42`.

You can observer the session information on the disk saved in the yml file:

```
$ cat sessions/503155064674153239941499197960160199.yml 
--- !!perl/hash:Dancer::Session::YAML
answer: 42
id: 503155064674153239941499197960160199
```


## Cookies without template


You can observe this by deleting the cookie from the browser and the session file from the filesystem,
changing the application code to be:

```perl
get '/' => sub {
    return 'Hello';
};
```

If we reload the browser we can see (in the developer tools) that it does not set any cookie.
We can also check the disk that no session file was created.

To force the creation of a session, even without calling `template` we can call the `session` function.
Even with just a fake read:

```perl
get '/' => sub {
    session('id');
    return "Hello";
};
```

Besides not being elegant, there is also a slight problem with this work-around. If we want to turn off
session management and comment out the `session` key in the config.yml file, then the application
will crash when it reaches the call of the `session()` function.

A way to solve this is to check if sessions have been enabled. We can write the following:

```perl
    if (config->{session}) {
        session('id');
    }
```


## Avoiding session creationg for Bots

It really disturbs me when various bots visit the web site, we create a
session send a cookie, but they never return it, so the next time the same
bot visits the site, we create another session and another cookie.

In many cases it is ok to have these bots on the  site, especially if they also send
regular traffic, but all those cookies are just a waste.

We can enable sessions on-the fly, in the "before" hook.

TODO: Don't create sessions fo bots
TODO: Set the session to handle the whole domain not just the current host


```perl
hook before => sub {
    if (request->user_agent !~ /Googlebot|AhrefsBot|TweetmemeBot|bingbot|YandexBot|MJ12bot|heritrix|Baiduspider|Sogou web spider|Spinn3r|robots|thumboweb_bot|Blekkobot|Exabot|LWP::Simple/) {
        set session => "YAML";
    }
};
```

Of course this means then every place in the code where we call the `session()` function, we first need to check if the session management
has been turned on, but it might be a good opportunity to review the code to see if we really use the session object for things
that expect a human infront of the browers.


```perl
```



```perl
```


