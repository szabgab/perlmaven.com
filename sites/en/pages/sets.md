---
title: "Sets in Perl using Set::Scalar"
timestamp: 2021-02-23T17:30:01
tags:
  - sets
  - Set::Scalar
  - intersection
  - union
  - difference
  - symmetric_difference
published: true
author: szabgab
archive: true
description: "Sets are rarely used in programming, but when they are needed it is great to to be able to use them natively in the language or at least by installing a module."
show_related: true
---


In order to use sets easily in Perl we first need to install the [Set::Scalar](https://metacpan.org/pod/Set::Scalar) module from CPAN. You would usually use

```
cpanm Set::Scalar
```

to do this.


There are many additional ways to use the module, but let me show some of the basic examples using two sets, a few words in English and a few words in Spanish.

## Method calls


We can use method calls to do operations:

{% include file="examples/sets.pl" %}


## Operator overloading

We can also use overloaded operators:

{% include file="examples/sets_operators.pl" %}


## Sets and Venn diagrams

Check out the [Venn diagrams](https://en.wikipedia.org/wiki/Venn_diagram) on Wikipedia if you'd like to refresh your memory or if you need to learn about sets.

