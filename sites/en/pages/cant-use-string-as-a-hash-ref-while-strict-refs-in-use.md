---
title: Can't use string (...) as an HASH ref while "strict refs" in use at ...
timestamp: 2018-08-04T20:30:01
tags:
  - warnings
published: true
author: szabgab
archive: true
---


A less frequently seen error, but nevertheless an annoying one.
It usually stems from incorrect use of an Object Oriented module.


In our example we used the excellent [DateTime](https://metacpan.org/pod/DateTime) module to create a string representing the Year, Month, and Day. The module has a method called `ymd` that will return the date in YYYY-MM-DD format.

However this is a method of a DateTime object and not the DateTime class.

So when someone write the following code and runs it:

{% include file="examples/datetime_ymd_incorrectly.pl" %}

we get:

```
Can't use string ("DateTime") as a HASH ref while "strict refs" in use at .../DateTime.pm line 682.
```

Unfortunately it looks as if the error was in the DateTime module (line 682) while the actual problem was the way we called it.

The correct way to use this is by first creating a DateTime object with one of the constructors. e.g. using `now`
and then calling `ymd` on the object representing the current time:

{% include file="examples/datetime_ymd_correctly.pl" %}

```
2017-08-11
```


## Can't use string (...) as an HASH ref while "strict refs" in use at ...

So what is this error message?

As you might know [strict](/strict) has 3 parts. This error was triggered by the part called
`strict refs` that disables [Symbolic references](/symbolic-reference-in-perl). Which is a good thing.

The error manifested itself inside the DateTime module where we had code that effectively did something like this:

{% include file="examples/datetime_ymd_error.pl" %}

In which we are trying to use the content of `$self` which is `DateTime` in our case, as a reference to a HASH.

Some people might blame `strict` for the error and try to turn it off, but that will just bring us a silent error that
will bite us later.

