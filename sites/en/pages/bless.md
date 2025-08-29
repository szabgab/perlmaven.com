---
title: "bless"
timestamp: 2021-03-17T09:00:01
tags:
  - bless
  - OOP
  - constructor
  - new
published: true
author: szabgab
archive: true
description: "Perl uses the bless keyword to associate a reference with a package thereby creating an instance of a class."
show_related: true
---


The **bless** function in Perl is used to associate a reference (usually a reference to a hash) with a package to create an instance.


## The constructor

The de-facto standard name for the constructor of a class in Perl is the **new** method. When called with the arrow-notation
it will receive the name of the class as the first parameter. (We don't want to assume that the name passed there is the name of our package
to allow for inheritance.)

Inside the constructor we create a reference to a hash, then we call **bless** and pass the reference to this hash and the name of the class.
This operation will associate the reference with the given package name. It will also return the blessed reference, but it will also change the argument
we passed in.

{% include file="examples/MyFruit.pm" %}

Of course you don't need that much code to create the instance, I only wanted to show each step separately. You'll often encounter code like this
with implicit return:

```
sub new {
    my ($class) = @_;

    bless {}, $class;
}
```

## The usage

The way we can then use the class looks like this:

{% include file="examples/use_my_fruit.pl" %}

We run the code (we need to add the **-I.** to ensure perl will find the module in the current directory)

`perl -I. use_my_fruit.pl`

The output will look like this:

```perl
Inside new for MyFruit
Self is still only a reference HASH(0x55d920554470)
Self is now associated with the class: MyFruit=HASH(0x55d920554470)
The instance: MyFruit=HASH(0x55d920554470)
```

