---
title: "Single Page Application with Perl Dancer and AngularJS"
timestamp: 2015-11-15T19:13:11
tags:
  - Dancer2
  - AngularJS
published: true
books:
  - dancer
author: szabgab
show_related: false
---


Single Page Applications heavily rely on some JavaScript framework and a back-end system that can provide communication using JSON.

[AngularJS](https://code-maven.com/angularjs) is a great JavaScript framework (or HTML framework, or whatever you might want to call it),
and [Perl Dancer](/dancer) is a nice backend framework.

Recent versions of Dancer2 started to allow custom skeletons which means, we can provide our own skeleton files and the new Dancer-based
application will use those.


The [Dancer2-Angular-Skeleton](https://github.com/szabgab/Dancer2-Angular-Skeleton) is such a set of files.

Download the skeleton using the [Download ZIP](https://github.com/szabgab/Dancer2-Angular-Skeleton/archive/master.zip) button in
the GitHub Repository. And unzip the file.

```
$ wget https://github.com/szabgab/Dancer2-Angular-Skeleton/archive/master.zip
$ unzip master.zip
$ dancer2 -a My::App -s Dancer2-Angular-Skeleton-master
```

Due to a bug for which I sent in a [pull request already](https://github.com/PerlDancer/Dancer2/pull/1060) it will complain a bit
with hundreds of rows like this:

```
utf8 "\xAC" does not map to Unicode a ...
```

but in the end it will create a directory called My-App, and in that directory you'll have Dancer2 application, AngularJS,
and a few lines of code that demonstrates how to get started with a Single-Page Application.

It still needs more work, but I really wanted to show it already.

You can now

```
$ cd My-App
$ plackup -R lib bin/app.psgi
```

and visit http://127.0.0.1:5000/ to see how does it work.


## Creating your own Dancer2 skeleton

It is quite easy. You can clone the one I have created, or you can copy the [share/skel](https://github.com/PerlDancer/Dancer2/tree/master/share/skel)
directory from the Dancer2 distribution and tweak it for yourself.

## Comments

Thanks Gabor. Article looks good.

can see app.pl inside bin directory, 

so command should be 

plackup -R lib bin/app.pl


