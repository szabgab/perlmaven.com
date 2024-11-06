---
title: "Arrays em Perl"
timestamp: 2013-05-14T06:08:12
tags:
  - @
  - array
  - arrays
  - length
  - size
  - foreach
  - Data::Dumper
  - scalar
  - push
  - pop
  - shift
published: true
original: perl-arrays
books:
  - beginner
author: szabgab
translator: leprevost
---


Neste espisódio do [Tutorial Perl](/perl-tutorial) nós iremos aprender sobre <b>arrays em Perl</b>.
Esse artigo será um resumo sobre o funcionamento de <i>arrays</i> em Perl. Iremos ver mais adiante
maiores detalhes sobre o seu funcionamento.

Em Perl, nomes de variáveis do tipo array iniciam com o símbolo `@`.

Por conta da nossa insistência no uso do pragma `strict` você precisa declarar essas variáveis utilizando
a palavra-chave `my` antes do nome da variável.


Lembre-se, todo os exemplos abaixo iniciam da seguinte forma:

```perl
use strict;
use warnings;
use 5.010;
```

Declare um array:

```perl
my @names;
```

Declare e atribua valores:

```perl
my @names = ("Foo", "Bar", "Baz");
```


## Depurando arrays

```perl
use Data::Dumper qw(Dumper);

my @names = ("Foo", "Bar", "Baz");
say Dumper \@names;
```

O resultado é:

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz'
      ];
```

## Laço foreeach e arrays em perl

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $n (@names) {
  say $n;
}
```

Irá imprimir:

```
Foo
Bar
Baz
```

## Acessando um elemento de um array

```perl
my @names = ("Foo", "Bar", "Baz");
say $names[0];
```

NOte que quando acessando um único elemento do array, o símbolo colocado na frente do nome da variável muda 
de `@` para `$`. Isso pode causar um pouco de confusão em algumas pessoas, mas de você parar
para pensar, é algo um tanto quanto óbvio.

O sínbolo `@` significa algo no plural e o `$</hl\> algo no singular. Quando acessando um único
elemento de um array, a variável se comporta como uma variável escalar.

## Índices de um array

O índice de um array inicia em 0. O maior índice é sempre armazenado em uma variável chamada
`$#nome_do_array`, ou seja:

```perl
my @names = ("Foo", "Bar", "Baz");
say $#names;
```

Irá imrimir 2 porque os índices são 0,1 e 2.

## Comprimento ou tamanho de um array

Em Perl não há uma função especial para recuperar o tamanho de um array, mas há 
várias formas de se obter esse valor. Um delas por exmeplo, é somar 1 ao 
maior índice do array. No caso acima `$#names + 1` é o <b>tamanho</b>
ou <b>comprimento</b> do array.

Além disso a função `scalar` pode ser utilizada para obter o tamanho de um array:

```perl
my @names = ("Foo", "Bar", "Baz");
say scalar @names;
```

Irá imprimir 3.

A função `scalar` é um tipo de invocação onde - entre outras coisas - realiza a 
conversão entre arrays e scalars. Por conta de uma decisão arbitrária, porém inteligente, esssa
conversão resulta no tamanho do array.

## Iterando os índices de um array

Em determinados casos a iteração sobre os valores do array não é o suficiente.
Nós poderemos precisar de ambas informações, os valores e os índices.
Neste caso nós precisamos iterar sobre os índices e obter os valores utilizando
os índices:

```perl
my @names = ("Foo", "Bar", "Baz");
foreach my $i (0 .. $#names) {
  say "$i - $names[$i]";
}
```

imprime:

```
0 - Foo
1 - Bar
2 - Baz
```

## Função push em arrays

`push` adiciona um novo valor ao final do array, aumentando o seu tamanho:

```perl
my @names = ("Foo", "Bar", "Baz");
push @names, 'Moo';

say Dumper \@names;
```

Resulta em:

```
$VAR1 = [
        'Foo',
        'Bar',
        'Baz',
        'Moo'
      ];
```


## Função pop em array

`pop` remove o último elemento de um array:

```perl
my @names = ("Foo", "Bar", "Baz");
my $last_value = pop @names;
say "Last: $last_value";
say Dumper \@names;
```

Resultando em:

```
Last: Baz
$VAR1 = [
        'Foo',
        'Bar',
      ];
```

## Função shift em array

`shift` irá retornar o último elemento à esquerda do array
e irá mover todos os demais elementos uma casa à esquerda.

```perl
my @names = ("Foo", "Bar", "Baz");

my $first_value = shift @names;
say "First: $first_value";
say Dumper \@names;
```

O resultado é:

```
First: Foo
$VAR1 = [
        'Bar',
        'Baz',
      ];
```

