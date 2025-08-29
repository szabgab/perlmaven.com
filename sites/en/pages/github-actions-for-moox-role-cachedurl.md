---
title: "GitHub Actions for MooX-Role-CachedURL"
timestamp: 2022-10-11T09:30:01
tags:
  - GitHub
published: true
books:
  - dancer
author: szabgab
archive: true
show_related: true
---


Looking at [CPAN Digger](https://cpan-digger.perlmaven.com/) I notice the [PAUSE-User](https://metacpan.org/dist/PAUSE-Users)
package that has a link to its [GitHub repository](https://github.com/neilb/PAUSE-Users), but no CI configured.


I cloned the repository and tried to run the tests locally, but got stuck installing the dependencies. [MooX-Role-CachedURL](https://metacpan.org/dist/MooX-Role-CachedURL)
would not intsall. I looked at MetaCPAN and saw that The CPAN Testers report ** Testers (1546 / 304 / 0) ** That is 1546 successful reports but 304 failed reports.
Also that the package was last released on Nov 04, 2015. Almost 7 years ago.

I said, let's see what can we do there.

## MooX::Role::CachedURL

I tried to install it using

```
cpanm MooX::Role::CachedURL
```

I got the error and [reported it](https://github.com/neilb/MooX-Role-CachedURL/issues/1).

As I saw that this package does not have CI setup either I decided to do that first. That will help the author fix this package.

I installed the dependencies locally. That lead me to a Pull-request [adding .gitignore](https://github.com/neilb/MooX-Role-CachedURL/pull/2) file.
Then configured GitHub Actions. The basic configuration went easily, but there were a bunch of things missing (or I just don't know how to use Dist::Zilla properly)
and it took me a few commits and pushes till I managed to install all the dependencies on the CI server. That left us with the test failure.

Hopefully this will help Neil Bowers, the maintainer of the package to fix the issue.

The GitHub Actions configuration file ended up looking like this:

{% include file="examples/moox-role-cachedurl-ci.yml" %}
