---
title: "Perlbrew on Linux (Ubuntu 18.10)"
timestamp: 2018-12-28T12:30:01
tags:
  - perlbrew
published: true
author: szabgab
---


I have a new computer with Ubuntu 18.10 on it. It comes with perl 5.26, but I wanted to brew my own perl.


Install [perlbrew](https://perlbrew.pl/)

```
sudo apt-get install perlbrew
```

List the available versions of perl:

```
perlbrew available
```

Brew (install) perl 5.28.1:

```
$ perlbrew install perl-5.28.1
```

The response is

```
Fetching perl 5.28.1 as /home/gabor/perl5/perlbrew/dists/perl-5.28.1.tar.gz
Download http://www.cpan.org/src/5.0/perl-5.28.1.tar.gz to /home/gabor/perl5/perlbrew/dists/perl-5.28.1.tar.gz
ERROR: Failed to download http://www.cpan.org/src/5.0/perl-5.28.1.tar.gz
```

Oh. That's not good.

```
mkdir -p perl5/perlbrew/dists
```

Now this works:

```
perlbrew install perl-5.28.1
```

## Using Perlbrew

At this point you should be able to switch to the newly intsalled perl using

```
perlbrew switch perl-5.28.1
```

and it works, but it also prints this, and the switch is only temporary. I think this should be a permanent switch.
As I recall it used to be a permanent switch.

```
A sub-shell is launched with perl-5.28.1 as the activated perl. Run 'exit' to finish it.
```

Anyway, not too optimal workaround is to add this

```
export PATH=~/perl5/perlbrew/perls/perl-5.28.1/bin:$PATH
```

to the `~/.bashrc` file.

## Comments

perlbrew init then adding source ~/perl5/perlbrew/etc/bashrc to your .profile should fix the switch not sticking issue.
