---
title: "DWIM Perl for Linux; $^X vs $Config{perlpath}; Relocatable Perl; Test::Differences"
timestamp: 2014-09-25T10:00:01
tags:
  - DWIM Perl
published: true
author: szabgab
---


The last couple of days I've spent re-building [DWIM Perl for Linux](/dwimperl) using a cpanfile, carton,
running builds on Travis-CI and on a [Digital Ocean Droplet](/digitalocean).
[DWIM Perl for Linux](/dwimperl) is a <b>batteries included</b> binary distribution of
<b>standard perl + lots of CPAN modules</b>. The hope that it will make
it extremely easy for people to get started using Perl. Without the need to encounter the installation headaches that might come with cpan.


I have plenty of things to write about each one of the subjects, but I've encountered an issue that I am not sure how to solve.
I wanted to install [Test::Differences](https://metacpan.org/pod/Test::Differences) (as a prerequisite of a a lot of things).
It uses `$Config{perlpath}` instead of more common `$^X` to run some external perl scripts from some of the test files.
This blows up during build with `Can't exec "/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl/bin/perl": No such file or directory`.

Apparently there is a subtle difference between `$Config{perlpath}` and `$^X`. It was mentioned in an answer to
[this question](http://www.perlmonks.org/?node_id=1098270) as well, but back then I did not understand the issue.
The thing is that in my case `$^X` contains the actual path to the perl executable where it is located when the script is running,
while `$Config{perlpath}` contains the path to the perl executable when it was compiled.

I compiled and originally installed this perl to the <b>/home/dwimperl/dwimperl-linux-5.20.1-1-x86_64/perl/</b> directory, but when
[Travis-CI](https://travis-ci.org/) uses it, it is placed to <b>/home/travis/dwimperl-linux-5.20.1-4-x86_64/perl/</b>.

## Changing the test

One solution would be to send a patch to the maintainers of [Test::Differences](https://metacpan.org/pod/Test::Differences)
to use `$^X` instead of `$Config{perlpath}`, but I am not sure they'd accept, I don't know if this would be right to do,
and most importantly, this would only solve this specific case. Surely there are going to be other modules using `$Config{perlpath}`
and they'd be broken as well. Even the real users of [DWIM Perl for Linux](/dwimperl) might us that value
and the system will be broken for them.

## Skip the test

Another solution would be to install Test::Differences using the `--notest` flag of `cpanm`.
This solution would be quicker (no need to wait for the maintainers of Test::Differences), and no need to depend on them, whether
they accept the change or not.
On the other hand this would not solve any of my other concerns. This could be a work-around till I find a better solution.

## Change $Config{perlpath}

DWIM Perl is supposed to be relocatable. It was compiled with the `userelocatableinc` flag which means it automatically
adjusts the content of `@INC` to the location of perl. That part worked well. I wonder if there is some other flag
I need to use to compile perl to make it adjust `perlpath` and maybe even some other variables?

Running `perl -MData::Dumper -MConfig -e'print Dumper \%Config'` shows quite a few variables that contains the full path to where
this perl was first installed. There are quite a few that show the new path but these variables include the old one, that does not
exists any more:

```
config_arg3
config_args
initialinstalllocation
installbin
installprefix
perlpath
startperl
```


As I can see [this thread](http://lists.gnu.org/archive/html/bug-gnulib/2014-01/msg00003.html) on the Perl 5 Porters
list was about a solution for this problem.

I posted this question on [Perl Monks](http://www.perlmonks.org/?node_id=1102042) as well.

