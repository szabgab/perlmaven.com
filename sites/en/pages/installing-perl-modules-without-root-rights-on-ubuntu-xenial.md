---
title: "Installing Perl modules without root rights on Ubuntu Xenial (16.04)"
timestamp: 2018-04-22T08:30:01
tags:
  - local:lib
  - cpanm
published: false
author: szabgab
archive: true
---


You might have the box from [Digital Ocean](/digitalocean) or just on your desktop.
I used Vagrant to build the machine.

## Building the machine using Vagrant

Using this Vagrantfile:

{% include file="examples/perl-ubuntu-xenial/Vagrantfile" %}


```
sudo apt-get install -y build-essential
```


## Installing cpanm and local::lib

Assuming you are running as regular user and not as user `root`.

[cpanminus](https://cpanmin.us/) looks very hackish, but it is just the source code
of the command you need to run.


Run
```
curl -L https://cpanmin.us | perl - App::cpanminus
```

This will complain a bit

```
~/perl5/bin/cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
```

```
$ which cpanm
/home/vagrant/perl5/bin/cpanm
```

In order to make the configuration permanent (that is, available the next time you log in to the machine)
add the following line:

```
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
```

to the end of the `~/.bashrc` file.



```
wget https://cpanmin.us/
```


```
```


