---
title: "Perl on the command line (screencast) - video"
timestamp: 2015-02-09T15:30:06
tags:
  - -v
  - -V
  - -e
  - -E
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


In the [Beginner Perl Maven video course](/beginner-perl-maven-video-course) we will mostly write Perl that are
saved in files, but Perl can also be used on the command line, without saving the code in a file.

We are going to see an example here, and later on we are going to see a couple of more examples.


<slidecast file="beginner-perl/command-line" youtube="cjKol7gTlkA" />

In order to open the command line, on Windows you need to click on <b>Start/Run</b> and then type in `cmd`.

```
$ perl -v
```

```
$ perl -V
```

```
$ perl -e "print 42"
```


If running on perl 5.10 or later, you can also:

```
$ perl -E "say 42"
```


On Unix/Linux you might prefer to use single quotes `'` around the code:

```
$ perl -E 'say 42'
```

