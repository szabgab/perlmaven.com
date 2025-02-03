---
title: "Don't put & in-front of subroutines in Perl"
timestamp: 2015-04-19T13:30:01
tags:
  - &
published: true
books:
  - beginner
author: szabgab
archive: true
---


Once in a while I see people calling subroutines in perl like this:

```
&some_sub($param);
```

That `&amp;` character at the beginning should not be there.


Instead of repeating the explanation let me just point you to the article by Dave Cross:

[Subroutines and Ampersands](http://perlhacks.com/2015/04/subroutines-and-ampersands/)

The only place where you need to put &amp; in-front of the subroutine name is when you take a refernce to it:

```
my $ref = \&some_sub;
```

