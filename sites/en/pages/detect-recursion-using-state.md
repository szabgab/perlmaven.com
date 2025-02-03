---
title: "Detect recursion using state variables"
timestamp: 2021-04-16T08:30:01
tags:
  - state
  - Carp
  - confess
published: true
author: szabgab
archive: true
---


As you might know [Perl version 5.10](/what-is-new-in-perl-5.10--say-defined-or-state) has introduce a keyword called `state` that allows the creation of so-called [state](/static-and-state-variables-in-perl)
variables. These are very similar to the static variables of C. You declare them insied a function. They are scoped to the function so you cannot reach them from the outside, but they never get destroyed and they are initialized only once.

[Dave Horsfall](http://horsfall.org/) suggested to use this feature to detect unwanted recursion. Or calling the same function twice.


The idea is to add a small construct to every function:

```
confess 'recursion' if state $recursed++;
```

The code will look like this:

{% include file="examples/detect_recursion.pl" %}

Then if we run the script we get the following exception:

<pre>
recursion at examples/detect_recursion.pl line 9.
    main::a() called at detect_recursion.pl line 21
    main::c() called at detect_recursion.pl line 15
    main::b() called at detect_recursion.pl line 10
    main::a() called at detect_recursion.pl line 25
</pre>

That is, when a() called again deep down the call stack, the state variable already has a value
and this Perl will call `confess` that will raise an exception with a nice stack-trace.


## False alarms

While this idea can be used in some of the cases, in other it might generate false alarms.

In this case we call the same function twice. One after the other, but not in a recursion.

{% include file="examples/detect_recursion_falsly.pl" %}

```
recursion at detect_recursion_falsly.pl line 8.
    main::a() called at detect_recursion_falsly.pl line 12
```

## Comments

If all of the exits from a function do a

$recursed--

then I *think* the false alarm goes away.

sub a {
    #say 'enter a';
    confess 'recursion' if state $recursed++;
    b();
    $recursed--;
}
sub b {
    #say 'enter b';
    confess 'recursion' if state $recursed++;
    c();
    $recursed--;
}
 
sub c {
    #say 'enter c';
    confess 'recursion' if state $recursed++;
    a();
    $recursed--;
}

Also, I thought that declaring and modifying the state variable in the

state

declaration was outlawed recently. Of was that just for

my

?

