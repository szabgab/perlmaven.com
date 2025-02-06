---
title: Can't locate object method "..." via package "1" (perhaps you forgot to load "1"?)
timestamp: 2015-02-05T18:30:01
tags:
  - context
published: true
books:
  - beginner
author: szabgab
archive: true
---


This is a fun error message.


Given a function and a function call that look like these:

```perl
sub do_something {
    my $object = @_;

    $object->method;
}

print "before\n";
do_something('some data');
print "after\n";
```

We get the following output:

```
$ perl code.pl

before
Can't locate object method "method" via package "1" (perhaps you forgot to load "1"?) at code.pl line 4.
```

This is a run-time error, as we can see by the fact that 'before' was printed but 'after' not.

If we had called the function this way:

```perl
print "before\n";
do_something();
print "after\n";
```

we would get:

```
before
Can't locate object method "method" via package "0" (perhaps you forgot to load "0"?) at code.pl line 4.
```


By this difference, can you already guess what was that `package "1"</h> that is now `package "0"`?


## The explanation

The problem is that in the `do_something` subroutine we assigned the `@_` to a scalar variable that put it in [SCALAR context](/scalar-and-list-context-in-perl).
In scalar context an array will return its size. The [number of elements of the array](/length-of-an-array). In the first case there was one parameter and so perl assigned
the number 1 to the variable `$object`. In the second case there were no parameters and thus Perl assigned the number 0 to `$object`.

What if we call `do_something` with two parameters?

```perl
do_something('foo', 'bar');
```

```
Can't locate object method "method" via package "2" (perhaps you forgot to load "2"?) at code.pl line 4.
```

Not surprisingly (any more), perl assigned the number 2 to `$object`.

The solution is to put the left-hand-side of the assignment in parentheses, thereby providing [LIST context](/scalar-and-list-context-in-perl) to the array
that will then copy its elements to the list on the left hand side. If the list contains a single scalar variable then the first element of the
array will be assigned to that variable.

So the function declaration should look like this:

```perl
sub do_something {
    my ($object) = @_;

    $object->method;
}
```


