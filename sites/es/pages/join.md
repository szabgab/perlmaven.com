---
title: "join"
timestamp: 2013-12-07T19:45:56
tags:
  - join
published: true
original: join
books:
  - beginner
author: szabgab
translator: davidegx
---


Creo que no hay mucho que decir acerca de la función `join` excepto que
es la función opuesta a `split`.


Esta función recibe varios elementos de una lista o un array y los une en una sola cadena.

```perl
use strict;
use warnings;
use v5.10;

my @names = ('Foo', 'Bar', 'Moo');
my $str = join ':', @names;
say $str;                       # Foo:Bar:Moo

my $data = join "-", $str, "names";
say $data;                      # Foo:Bar:Moo-names


$str = join '', @names, 'Baz';
say $str;                       # FooBarMooBaz
```

El primer parámetro de <b>join</b> es el "conector", la cadena
que se usará para unir el resto de parámetros.
El resto de parámetros de join serán convertidos en una lista
y cada uno de los elementos se unirá con el "conector" dado.

Este "conector" puede ser cualquier cadena, incluso la cadena vacía.

