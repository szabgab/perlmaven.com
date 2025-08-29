---
title: "Some MetaCPAN advanced search tricks using prefixes"
timestamp: 2014-09-05T07:30:01
tags:
  - MetaCPAN
published: true
books:
  - metacpan
author: szabgab
---


The other day I wrote about the possibility to
[list modules in a given namespace](/listing-all-the-modules-in-a-namespace)
using the `module:` prefix.

As it turns out there are more such prefixes that can be used.

There is even a [ticket](https://github.com/CPAN-API/metacpan-web/issues/287) discussing how to make those
more accessible to the users.


While that discussion goes on, let me show a few examples:

## module:

Filter by module name:

[module:Plack::Middleware](https://metacpan.org/search?q=module:Plack::Middleware) - list all the modules in the given namespace.

[module:Plack::Middleware Oauth](https://metacpan.org/search?q=module%3APlack%3A%3AMiddleware+Oauth) Search for **Oauth** in the given namespace.

[module:Middleware](https://metacpan.org/search?q=module:Middleware) search for all the **Middleware**. Apparently the **module:** prefix
matches any full part of the module names. (Hint: searching for [module:iddleware](https://metacpan.org/search?q=module%3Aiddleware) does not bring any results.)

## distribution:

Filter by distribution:

[distribution:Dancer auth](https://metacpan.org/search?q=distribution%3ADancer+auth) search for **auth** in the Dancer distribution.

vs

[module:Dancer auth](https://metacpan.org/search?q=module%3ADancer+auth) search for **auth** in the modules with Dancer in their name.


[distribution:Dancer-Plugin-Auth-CAS  auth](https://metacpan.org/search?q=distribution%3ADancer-Plugin-Auth-CAS++auth) search in the Dancer-Plugin-Auth-CAS
distribution.

vs

[module:Dancer::Plugin  auth](https://metacpan.org/search?q=module%3ADancer%3A%3APlugin++auth) search in all the modules in the Dancer::Plugins namespace.

## author:

Filter by author:

[author:SONGMU](https://metacpan.org/search?q=author%3ASONGMU) All the modules by author SONGMU.

[author:SONGMU Redis](https://metacpan.org/search?q=author%3ASONGMU+Redis) - all the Redis related modules by author SONGMU.


## version:

Filter by version number:

[version:0.01](https://metacpan.org/search?q=version%3A0.01) all the (I think distributions) with version number 0.01.

[version:0.1](https://metacpan.org/search?q=version%3A0.1) similar for 0.1

There are a few strange modules with [version:12](https://metacpan.org/search?q=version%3A12),
[version:14](https://metacpan.org/search?q=version%3A14), and even [version:100](https://metacpan.org/search?q=version%3A100).

Some wildcards can be also used:
[version:5.*](https://metacpan.org/search?q=version%3A5.*)
or include a bit more results: [version:5*](https://metacpan.org/search?q=version%3A5*)
or only one digit (character) after the dot: [version:5.?](https://metacpan.org/search?q=version%3A5.?)


## Combined prefixes

You can also combine these meta-searches

[author:RJBS version:0.0*](https://metacpan.org/search?q=author%3ARJBS+version%3A0.0*)

[module:Dancer author:TLINDEN](https://metacpan.org/search?q=module%3ADancer+author%3ATLINDEN).

What other interesting search can you come up with?

(Hint, in this [ticket](https://github.com/CPAN-API/metacpan-web/issues/287) there are links explaining the
valid prefixes and the valid special characters.


