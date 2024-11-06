---
title: "O Jogo de Adivinhar Números"
timestamp: 2013-04-20T17:45:54
tags:
  - rand
  - random
  - int
  - integer
published: true
original: number-guessing-game
books:
  - beginner
author: szabgab
translator: leprevost
---


Neste capítulo do [tutorial Perl](/perl-tutorial) nós iremos realizar um pequeno, porém, divertido, jogo.
Este foi o primeiro jogo que escrevi enquanto estava no ensino médio, antes mesmo do Perl 1.0 ser liberado.


Para que possamos escrever este jogo precisamos antes aprender sobre dois simples, porém não relacionados tópicos:

<b>Como gerar números aleatórios em Perl</b> e
<b>Como recuperar a parte inteira de um número</b>.

## Parte inteira de um número fracionário

A função `int()` retorna a parte inteira de seu parâmetro:

```perl
use strict;
use warnings;
use 5.010;

my $x = int 3.14;
say $x;          # irá imprimir 3

my $z = int 3;
say $z;          # também irá imprimir 3.

my $w = int 3.99999;
say $w;          # até mesmo isso irá imprimir 3.

say int -3.14;   # irá imprimir -3
```

## Números Aleatórios

Ao chamar a função `rand()` do Perl, teremos como retorno um número fracionário aleatório, entre 0 e $n.
O valor poderá ser 0, mas não $n.

Se `$n = 42` então uma chamada à função `rand($n)` irá retornar um número aleatório entre 0 e 42.
O valor pode ser 0 mas não 42. Pode ser, por exemplo 11.264624821095826.

Se nós não passarmos um valor então `rand()` irá utilizar o valor padrão, retornando um valor entre 0 e 1, incluindo 0 mas excluindo 1.

A combinação de `rand()` com `int` nos permite gerar números aleatórios inteiros.

```perl
use strict;
use warnings;
use 5.010;

my $z = int rand 6;
say $z;
```

Irá retornar um número entre 0 e 6. Podendo ser 0 mas não podendo ser 6. Então poderá ser qualquer um dos seguintes números: 1,2,3,4,5.

Se adicionarmos 1 ao resultado então teremos qualquer um dos números 1,2,3,4,5,6, que seria a mesma coisa que jogar um dado de seis faces.

## Exercício: O Jogo de Adivinhar O Número

Este é o início de um jogo que iremos escrever. Um simples porém divertido jogo.

Escreva um script onde ao utilizar a função `rand()` o computador "pensa" em um número
entre 1 e 200. O usuário deverá adivinhar o número.

Após o usuário escrever seu palpite o computador avisa se o número é maior ou menor do que o valor gerado.

Neste ponto <b>não</b> há necessidade de permitir que o usuário adivinhe várias vezes.
Nós iremos chegar lá em poucos capítulos. É claro que não impedirei que leia sobre
os [laços while](/laco-while) em Perl, você ler o artigo e deixar que por enquanto, o usuário
faça várias tentativas.
