---
title: "Enable GitHub Actions for CI on Math::Polynomial::Chebyshev"
timestamp: 2022-09-25T08:30:01
tags:
  - CI
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


When looking at the [recent uploads to CPAN](https://metacpan.org/recent) I bumped into the [Math-Polynomial-Chebyshev](https://metacpan.org/dist/Math-Polynomial-Chebyshev)
and noticed it does not have any CI system enabled. So I guess I could contribute to this package a bit by adding GitHub Actions to it.


{% youtube id="dULcU-uEWEw" file="enable-github-actions-on-chebyshev.mp4" %}

I cloned the GitHub repository to my computer:

```
git clone git@github.com:pjacklam/p5-Math-Polynomial-Chebyshev.git
```

Ran the tests locally:

```
cpanm --installdeps .
perl Makefile.PL
make
make test
```

Created a branch

```
git checkout -b ci
```

Copied the perl.yml file from the [try-github-actions](https://github.com/szabgab/try-github-actions/) repository.

I saved a copy of the file here so even if the file changes in the future you'll be able to find the original copy:

{% include file="examples/chebyshev-ci.yml" %}

Then had to fork the original repository on GitHub so I will be able to push out my changes.

```
git remote add fork git@github.com:szabgab/p5-Math-Polynomial-Chebyshev.git
git remote -v
```


Then pushed it out the changes to my repository.

```
git push --set-upstream fork ci
```

Chyecked the <b>Actions</b> tab to see if everything works fine.

Finally I sent a pull-request asking the author to accept these changes.

