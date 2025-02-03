---
title: "Deep recursion on subroutine"
timestamp: 2021-07-23T06:30:01
tags:
  - warnings
  - recursive
published: true
author: szabgab
archive: true
---


When calling a function in [recursion](/recursion) we have to be careful to check the stop condition before we call the recursion. If not, we can end up with an infinite recursion that will end only when we have exhausted the resources of our computer.

In order to protect the user from never ending recursions, perl has a hard limit on the number of recursion and if you reach that limit you'll get a warning: `Deep recursion on subroutine`. The rather arbitrary limit is 100.

Let's see an example.


## Recursive Factorial with an mistake

We used factorial in the example about [recursion](/recursion), so let's use it here too:

{% include file="examples/recursive_factorial_bad.pl" %}

If you run the above code it will just keep running and running and either it will choke your computer, crash when you run out of free memory, or you get fed up and press Ctrl-C. It won't even warn you!

Of course you'd not write such code as you [always use warnings](/always-use-warnings). As in this version:

{% include file="examples/recursive_factorial_warnings.pl" %}

This will also try to exhaust your computer, but at least it will give you a warning

<pre>
Deep recursion on subroutine "main::factorial" at recursive_factorial_warnings.pl line 7.
</pre>

## Fatal Warning

If you want to make sure your code stops when you encounter a recursion that has passed the limit of 100 deep recursive calls,
you can turn each warning into an exception by writing:

```
use warnings FATAL => 'all';
```

Alternatively you can look up the specific category in the [hierarchy of warnings](https://metacpan.org/pod/warnings)
and turn only the `recursive` warnings into fatal exceptions as we did in our example:

{% include file="examples/recursive_factorial_fatal_warnings.pl" %}

This will throw an exception once you reached the 100s iteration.

## How to deal with the Deep recursion on subroutine warning turned exception?

First of all, you probably need to look at the code and figure out what is the bug that causes the deep recursion?
Maybe you put the stop condition after the recursive call?

OK we can fix that by swapping the two lines with "return" and we get 720 as a result.

{% include file="examples/recursive_factorial_fixed.pl" %}

We can even call this passing 98 and we get 9.42689044888324e+153 as a result.

What if we pass 99 ?

We get the dreaded Deep recursion warning turned into exception.

This time however we really wanted to have more than 99 recursive calls.


## How to write deep recursions?

So what do you do if you really want to have a recursion that is more than 100 deep?

First of all you might want to reconsider. In almost every case when you feel the urge to have such deep recursions,
you are probably better off with a flat solution. So consider rewriting the algorithm.

If you cannot do that or don't want to do that, hey, this might be an school exercise in writing deep recursions :),
then you can turn off the warnings.

In this example we turned on all the warnings and then turned off specifically the `recursive warnings`.
I've included a lame print of an undefined value, just to show that while we don't get the 
`Deep recursion on subroutine` warning, we still get the [Use of uninitialized value](/use-of-uninitialized-value) warning.

{% include file="examples/recursive_factorial_no_warnings.pl" %}

```
9.33262154439441e+157
Use of uninitialized value $c in say at
```

## Finding the source of deep recursion

Recently I have encountered the Deep recursion problem in the script that sends out the notification email messages
to the subscribers of the Perl Maven site. I've reported it [here](https://github.com/PerlDancer/Dancer2/issues/1466).

One thing I don't know yet, is where that call comes from so the next thing I'll do is include `-d:Confess` in the calling 
of the script. After installing [Devel::Confess](https://metacpan.org/pod/Devel::Confess)


