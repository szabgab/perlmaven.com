---
title: "Manipulando arrays em Perl: shift, unshift, push, pop"
timestamp: 2014-09-26T14:45:55
tags:
  - array
  - shift
  - unshift
  - push
  - pop
published: true
original: manipulating-perl-arrays
books:
  - beginner
author: szabgab
translator: aramisf
---


Assim como acessar elementos individuais de um array, o Perl
também provê diversos outros meios de lidar com os mesmos. Em particular,
existem funções que tornam muito fácil o uso dos arrays do Perl como pilhas ou
filas.


## pop

A função `pop` remove e retorna o último elemento de um array.

Neste primeiro exemplo, você pode ver como, dado um array de 3 elementos, a
função `pop` remove o último elemento (aquele que possui maior índice)
e o retorna.

```perl
my @names = ('Foo', 'Bar', 'Baz');
my $last_one = pop @names;

print "$last_one\n";  # Baz
print "@names\n";     # Foo Bar
```

No caso especial do array original ser vazio, a função `pop` retornará
[undef](/undef-e-definido-em-perl).

## push

A função `push` pode adicionar um ou mais valores ao final do array.
(Bem, ela também pode adicionar 0 valor, mas isto não é lá muito útil, é?)

```perl
my @names = ('Foo', 'Bar');
push @names, 'Moo';
print "@names\n";     # Foo Bar Moo

my @others = ('Darth', 'Vader');
push @names, @others;
print "@names\n";     # Foo Bar Moo Darth Vader
```

Neste exemplo começamos com um array com dois elementos.
Então empilhamos um único valor escalar no final do nosso array e ele acaba
sendo extendido para um array de 3 elementos.

Na segunda chamada para `push`, nós empilhamos o conteúdo do array
`others` no final do array `@names`, extendendo-o para um array
de 5 elementos.

## shift

A função `shift` move todo o array uma posição para a esquerda.
Considerando que o início do array está no lado esquerdo. O elemento que
estava no início do array vai "cair" fora do array e se tornar o valor
retornado pela função. (Se o array for vazio, <b>shift</b> retornará <a
href="/undef-e-definido-em-perl">undef</a>.)

Depois da operação, o array ficará um elemento menor.

```perl
my @names = ('Foo', 'Bar', 'Moo');
my $first = shift @names;
print "$first\n";     # Foo
print "@names\n";     # Bar Moo
```

Isto é muito parecido com o `pop`, mas funciona na ponta de menor
índice.

## unshift

É a operação contrária ao `shift`. `unshift` vai tomar um ou
mais valores (ou 0, se você preferir) e coloca-lo no início do array, movendo
todos os outros elementos para a direita.

Você pode passar a ele um único valor escalar, e então este valor passará a
ser o primeiro elemento do array. Ou, como no segundo exemplo, você pode
passar um segundo array e então os elementos deste segundo array
(`@others` no nosso caso) será copiado no início do array principal
(`@names` no nosso caso) movendo os outros elementos para índices
maiores.

```perl
my @names = ('Foo', 'Bar');
unshift @names, 'Moo';
print "@names\n";     # Moo Foo Bar

my @others = ('Darth', 'Vader');
unshift @names, @others;
print "@names\n";     # Darth Vader Moo Foo Bar
```

