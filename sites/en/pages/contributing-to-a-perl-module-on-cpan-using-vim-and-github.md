---
title: "Contributing to a Perl module on CPAN (using vim and GitHub)"
timestamp: 2013-12-09T23:05:01
tags:
  - CPAN
  - git
  - Github
  - MIME::Lite
types:
  - screencast
published: true
author: szabgab
---


In the article on [how to prepare for a Perl job interview](/how-to-prepare-for-a-perl-job-interview),
I mentioned that contribution to an Open Source project is an excellent way to learn new skills and
make yourself marketable. In this article and screencast that was created in July 2011, I showed
how contribute a little improvement to a Perl module on CPAN.


<blockquote>
Thanks. Your video was really eye opening.
It showed me that I do not need to start very big as I was thinking,
small contributions like that can really lead to big ones.

 -  Gervase Byomujuni
</blockquote>

{% youtube id="aB90XVLWyYk" file="contributing-to-mime-lite-2011.07.13.ogv" %}

It is not recommend solution any more, but back then I picked the
[MIME::Lite](https://metacpan.org/pod/MIME::Lite) distribution
as it had the annoying habit to ask me if I want to add optional dependencies.
Even when they were already installed on my system.
It even asked me if I want to install `File::Basename` which is a standard module.

The path of action was:

Search on [MetaCPAN](http://metacpan.org/) and locate
[MIME::Lite](https://metacpan.org/pod/MIME::Lite)
to see where the source code lives. This module did not provide the information in
its META file nor in its documentation. (BTW Already back then I saw that it was already
added in the not-yet-released version, and since then the new version was uploaded).

Anyway, In this case I was lucky as I knew Ricardo (RJBS) uses Github so I went to
[his Github page](https://github.com/rjbs/) and looked for the module.
I found the [repository of MIME::Lite](https://github.com/rjbs/mime-lite)
and **forked** it by pressing the **fork** button.

Then I cloned [my version of MIME::Lite](https://github.com/szabgab/mime-lite)
to my disk using

```
$ git clone git@github.com:szabgab/mime-lite.git
```

I had an editing session using **vim**, in which I made some **refactoring** of the code
and changed it, so it will first check if the optional modules are already installed
or not. If they are installed the version number is also checked if it is smaller
than the <i>required optional</i> version number.

Once this was fixed I added back the changed file and committed it to my local Git repository:

```
$ git add Makefile.PL
$ git ci -m'make optional modules optional'
```

Then pushed it to my remote repository on Github.

```
$ git push
```

Then went back to [my version of MIME::Lite](https://github.com/szabgab/mime-lite)
and clicked on the **Pull Request** button to send a message to Ricardo asking him 
to integrate the change.

That's it. A very small improvement to CPAN in 16 minutes.

