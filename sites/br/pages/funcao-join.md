---
title: "A Função join"
timestamp: 2013-05-21T20:45:56
tags:
  - join
published: true
original: join
books:
  - beginner
author: szabgab
translator: leprevost
---


Eu acho que não ha muito o que dizer sobre a função `join` exceto que atua como o oposto da função `split`.


Essa função pode receber vários elementos de uma lista ou array e juntá-los em um único texto.

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

O primeiro parâmetro do <b>join</b> é o "conector",
o texto que irá conectar todos os demais parâmetros.
O resto dos parâmetros da função são "achatados" em uma lista
e os elementos dessa lista serão colados pelo "conector".

O "conector" pode ser qualquer texto, até mesmo um texto vazio.
