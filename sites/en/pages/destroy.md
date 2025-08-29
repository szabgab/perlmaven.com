---
title: "The destructor called DESTROY"
timestamp: 2021-03-19T07:30:01
tags:
  - destructor
  - DESTROY
  - END
published: true
author: szabgab
archive: true
description: "Add a destructor to your classes in Perl."
show_related: true
---


When you write Object Oriented Perl code you would create a constructor called **new** that you need to call explicitly.

You can (optionally) also create a destructor called **DESTROY** that will be called implicitly when the instance goes out of
scope or otherwise loses its last reference.


## The class

This is a very simple class-definition. The **new** method will receive the name of the class as the first parameter and
use [bless](/bless) to create a instance of the class.

It also defines a method called **DESTROY** that will be called when the instance is destroyed.

The interesting thing is that you can define the DESTROY function either as a regular function:

```
sub DESTROY {
}
```

or even without the **sub** keyword:

```
DESTROY {
}
```


{% include file="examples/MyZorg.pm" %}

## Call destructor when leaving scope

{% include file="examples/show_destructor_scope.pl" %}

Run it like this:

```
perl -I. show_destructor_scope.pl
```

The output is this:

```
Before calling new
Inside new for MyZorg
Instance of: MyZorg=HASH(0x55fa4be06470)
Before leaving scope
DESTROY for: MyZorg=HASH(0x55fa4be06470)
After leaving scope
```

## Call destructor when changing variable content

If we assign some new value to the only variable that refers to this object, then to it is destroyed.

{% include file="examples/show_destructor_reset.pl" %}

Run:

```
perl -I. show_destructor_reset.pl
```

Output:

```
Before calling new
Inside new for MyZorg
Instance of: MyZorg=HASH(0x55a3d0686470)
Before changing variable
DESTROY for: MyZorg=HASH(0x55a3d0686470)
After changing variable
```

## Call destructor when program ends

The destructor is also called when we reach the end of our program.

{% include file="examples/show_destructor_eof.pl" %}

Run:

```
perl -I. show_destructor_eof.pl
```

Output:


```
Before calling new
Inside new for MyZorg
Instance of: MyZorg=HASH(0x5580a0843470)
DESTROY for: MyZorg=HASH(0x5580a0843470)
```


## Call destructor before the END blocks

Perl allows you to create [END](/end) blocks (or END functions) that will be called at the very end of running the program.
The END blocks will be called **after** all the destructor were called.

{% include file="examples/show_destructor_end.pl" %}

Run:

```
perl -I. show_destructor_end.pl
```

Output:



```
Before calling new
Inside new for MyZorg
Instance of: MyZorg=HASH(0x561971eb1470)
DESTROY for: MyZorg=HASH(0x561971eb1470)
END
```
