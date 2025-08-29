---
title: "What return is expected from a function?"
timestamp: 2021-02-25T17:30:01
tags:
  - Want
  - howmany
  - want
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


Perl is very different from most other programming languages in that functions in Perl can be made aware of their environment, especially they can chechk what kind of data is
expected from them? A scalar, a list? Maybe nothing?

This expectation might be different every place the function is called. In order to know what is expectation in the current call, the function can use the
slightly incorrectly named [wantarray](/wantarray) function.

However Perl can be a lot more precize telling a function what is expected from it. Using the [Want](https://metacpan.org/pod/Want)
module the function can know exactly how many values it needd to return.


## What type of data structure is expected from us?

In this example I created a function cleverly named **func** with the only goal to print the name of the specific context
in which the function was called in.

Values can be VOID if the result of the function is not assigned to any variable and it is not used in any other way.

It can be SCALAR if the result is assigned to a scalar variable, or if it is called in any other scalar context.

It can be LIST if the function was called in list context.

These correspond to the 3 cases that the wantarray function can also identify. However, the want function can be more precize and
it can tell if a reference is expected. For example an ARRAY or HASH reference. It will be CODE if a reference to a function is expected.

There are a few other cases you can find in the documentation of the module.

{% include file="examples/want.pl" %}


## How many return values are expected in this call?

The **howmany** function can tell the number of values we are expected to return. It will be **undef** if the expected number of elements is
not known or unlimited. That is in LIST context if the function is not assigned to a list of scalar variables.

On the other hand, if the function was called in void context, scalar context, or in some other way where it is possible to tell exactly
how many values are exected then the **howmany** function is going to return that number.

{% include file="examples/howmany.pl" %}

{% youtube id="nv1QFKSRrxs" file="perl-context-wantarray-and-want.mkv" %}

