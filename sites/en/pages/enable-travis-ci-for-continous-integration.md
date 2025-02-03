---
title: "Enable Travis-CI for Continuous Integration"
timestamp: 2015-09-19T10:30:01
tags:
  - Travis-CI
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


[Travis-CI](https://travis-ci.org/) provides Continuous Integration for projects in GitHub repositories. For public repositories it is even free.

In other words, if Travis-CI is enabled and configured for your GitHub repository, then every time you `push` changes out to GitHub,
Travis-CI will automatically run the test on the latest commit.

This is great, as it means I can get feedback for my changes on multiple versions of Perl even before I release my distribution to CPAN.


As this is not the first time I [use Travis-CI](/using-travis-ci-and-installing-geo-ip-on-linux), I already had an account,
and by the time I got to this, my repositories were already synced.
I only needed to enable to enable the `Pod-Tree` GitHub repository on [Tavis-CI](https://travis-ci.org/),
add, the `.travis.yml` file to the root of the repository, 

```
branches:
  except:
    - gh-pages
language: perl
perl:
  - "5.20"
  - "5.18"
  - "5.16"
  - "5.14"
  - "5.12"
  - "5.10"
```

[commit it](https://github.com/szabgab/Pod-Tree/commit/d7bd3772f6438193f18b8e34d26c3e4304f6e488) and push it out to GitHub.

After a few minutes I've received an e-mail notification from Travis-CI that the build for Pod-Tree was successful.
You can also see the [result of this build and test run](https://travis-ci.org/szabgab/Pod-Tree/builds/63035432).

In case you don't have Travis-CI set up yet and you'd also like to run it on your GitHub repositories,
I'd recommend to follow [the instructions of Neil Bowers](http://blogs.perl.org/users/neilb/2014/08/try-travis-ci-with-your-cpan-distributions.html).
I learned about Travis-CI from there.

## Additional suggestions

Later as I learned more about using Travis-CI for Perl projects, I'd even recommend using the [Travis-CI Perl helpers](https://github.com/travis-perl/helpers).

Specifically I have started to add the following statement to my `.travis.yml` file:

```
before_install:
  - eval $(curl https://travis-perl.github.io/init) --auto
```

and then I can add `- "blead"` to the list of perl version I'd like to use. That will make sure my code is tested on the version perl that
is heading to be the next release.

I've also added `sudo: false` to use the newer and faster Travis-CI environment.

The new `.travis.yml` looks like this:


```
branches:
  except:
    - gh-pages
language: perl
sudo: false
perl:
  - "blead"
  - "5.20"
  - "5.18"
  - "5.16"
  - "5.14"
  - "5.12"
  - "5.10"
before_install:
  - eval $(curl https://travis-perl.github.io/init) --auto
```


