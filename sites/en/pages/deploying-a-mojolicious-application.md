---
title: "Deploying a Mojolicious Application using Hypnotoad and Apache"
timestamp: 2018-02-18T10:00:01
tags:
  - Mojolicious
  - morbo
  - Hypnotoad
  - Apache
  - Nginx
published: true
books:
  - mojolicious
author: moritz
---


After you [developed your first Mojolicious application](/adding-layout-to-mojolicious-lite-based-application), you'll want to show it the world. That means running it on an Internet-facing web server.

Let's walk through the steps of getting an application running in a robust and reliable way.


When you've worked with Mojolicious, you're likely familar with [morbo](http://mojolicious.org/perldoc/morbo), the development server. But that is tailored for development use, not for production. For example it serves only one request at a time.

The Mojolicious developers have you covered: Mojolicious also ships with [hypnotoad, a production ready web server for Mojolicious](http://mojolicious.org/perldoc/hypnotoad).

The first step is as simple as running `hypnotoad hello_world.pl`, assuming your application is called `hello_world.pl`.

By default, hypnotoad starts one controlling process and four workers that serve requests. It also supports hot reloading. If you change your application, and then call the same command again, hypnotoad starts new workers based on the new version of your application, and later kills the old workers. During the whole process your site is available.

Hot reloading is generally a good idea, because it reduces downtime, and gives you a chance to detect errors before shutting down the old version of the application.

A bare hypnotoad is still not something you want to expose to the Internet. The Mojolicious developers recommend that you have a web server like Apache or Nginx serve the requests, and forward the requests to the Mojolicious application. These web servers are battle tested, and have been made secure for many years. They also likely handle some edge cases better than hypnotoad, like when the client only sends one byte every ten seconds.

To make this setup happen, you must first tell hypnotoad to only listen on localhost (so that it's not reachable from the outside), and to collaborate with a reverse proxy:

```perl
use Mojolicious::Lite;

app->config(
    hypnotoad => {
        listen => [ 'http://127.0.0.1:8082/' ],
        proxy  => 1,
    },
);

# the rest of your application goes here
```

The [documentation for Mojo::Server::Hypnotoad](http://mojolicious.org/perldoc/Mojo/Server/Hypnotoad) explains those options, and lists other options.

You can now start the server with `hypnotoad hello_world.pl`.

If you use Apache as the front end, the proxy configuration can look like this (assuming the domain example.com):

```
# /etc/apache2/sites-available/example.com.conf
<VirtualHost *:80>
    ServerAdmin your.name@example.com
    ServerName  example.com
    ServerAlias www.example.com

    <Proxy *>
        Order deny,allow
        Allow from all
    </Proxy>
    ProxyRequests Off
    ProxyPreserveHost On
    ProxyPass / http://localhost:8082/ keepalive=On
    ProxyPassReverse / http://localhost:8082/
    RequestHeader set X-Forwarded-HTTPS "0"

    ErrorLog ${APACHE_LOG_DIR}/example.com-error.log
    LogLevel warn
    CustomLog  {APACHE_LOG_DIR}/example.com-access.log combined
</VirtualHost>
```

You need to enable some Apache modules first

```
$ a2enmod headers
$ a2enmod proxy
$ a2enmod proxy_http
```

If you forget to enable the modules, trying to restart Apache gives you

```
Invalid command '<Proxy', perhaps misspelled or defined by a module not included in the server configuration
```

or a complain about RequestHeaders being an invalid command.

You can enable the site configuration with

```
$ a2ensite example.com.conf
```

Before you restart Apache to activate the configuration, run `apachectl configtest` to check the syntax of the configuration.

In the long run, you'll likely want to take more measures to ensure a smooth operation of your site. For example you can use [Let's Encrypt](https://letsencrypt.org/) to obtain free SSL certificates, and offer secure connections to your users. To ensure uptime, monitoring and capacity planning are essential.

But for now, you can enjoy your website running in a production setting.

## Comments

Just wanted to say thanks. This was exactly what I needed to know, and with a quick adjustment or two for my particular environment, I now see "raptor not found" on the domain name of my choosing. This is fun!

<hr>

Hi,
Thanks for this post. Can you also provide the steps for deploying the mojolicious app on shared hosting using cpanel. I am struggling with the same while using CGI.

---
   I'm also in a shared environment and could use some pointers

---

I have not use a shared environment for more than 20 years. I wonder what value do you get from such environment instead of having your own vps?

<hr>
thanks Moritz!

