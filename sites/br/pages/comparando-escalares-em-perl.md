---
title: "Comparando escalares em Perl"
timestamp: 2013-05-27T15:56:56
tags:
  - eq
  - ne
  - lt
  - gt
  - le
  - ge
  - ==
  - !=
  - <
  - >
  - <=
  - >=
published: true
original: comparing-scalars-in-perl
books:
  - beginner
author: szabgab
translator: aramisf
---


Na seção anterior do [Tutorial Perl](/perl-tutorial) introduzimos
as [variáveis escalares](/variaveis-escalares) e vimos como números
e strings são instantaneamente convertidos um no outro. Vimos brevemente sobre
a condicional <b>if</b> mas não vimos como comparar escalares. É disto que
trata esta parte.


Dadas duas variáveis $x e $y, como podemos compara-las?
Serão 1, 1.0 e 1.00 iguais? O que dizer sobre "1.00"?
O que é maior: "foo" ou "bar"?

## Dois conjuntos de operadores de comparação

O Perl possui dois conjuntos de operadores de comparação. Como vimos com os
operadores binários de adição (+), concatenação (.) e repetição (x), aqui
também o operador é o responsável por definir como os operandos se comportarão
e de que forma eles serão comparados.

Os dois conjuntos de operadores são os seguintes:

```
Numérico   String         Significando
==            eq           igual
!=            ne           diferente
<             lt           menor que
>             gt           maior que
<=            le           menor ou igual a
>=            ge           maior ou igual a
```

Os operadores à esquerda compararão os valores como números enquanto os
operadores à direita (a coluna do meio) vão comparar os valores baseados na
tabela ASCII ou com base nas configurações locais de linguagem do sistema
(locale).

Vejamos alguns exemplos:

```perl
use strict;
use warnings;
use 5.010;

if ( 12.0 == 12 ) {
  say "TRUE";
} else {
  say "FALSE";
}
```

Neste caso simples o Perl vai imprimir TRUE pois o operador `==`
compara os dois números e o Perl não se preocupa se o número está escrito como um
inteiro ou como número em notação de ponto flutuante.

Uma situação mais interessante seria comparar

```
"12.0" == 12
```

que também é TRUE pois o operador `==` converte a string em um número.

```
 2  < 3  é TRUE porque < compara os dois números.

 2  lt 3 também é TRUE pois 2 antecede 3 na tabela ASCII.

12 > 3  é obviamente TRUE.

12 gt 3 retorna FALSE.
```

Isto pode surpreender algumas pessoas no início, mas se você pensar um pouco,
a forma como o Perl compara duas strings é letra por letra. Então "1" é
comparado com "3" e como eles são diferentes e "1" aparece antes de "3" na
tabela ASCII, o Perl decide neste ponto que a string 12 é menor que a string
3.

Você deve se certificar que está comparando as coisas como você realmente
quer!

```
"foo" == "bar" será TRUE
```

Isto também lhe dará dois alertas (warnings) se(!) você habilitou os alertas
através do `use warnings;`. A razão para o alerta é que você está usando
duas strings como se fossem números na comparação numérica == e isto é o que gera os
alertas. Como mencionado anteriormente, o Perl vai olhar o lado esquerdo de
cada string e converte-las nos números que ele encontrar. Como as duas strings
começam com uma letra, ambas serão transformadas em 0.
0 == 0 e por isto temos TRUE.

OTOH (On The Other Hand - por outro lado):

```
"foo"  eq "bar" retorna FALSE
```

Então você tem que ter certeza de comparar os valores como você os quer!

O mesmo acontece quando você compara

```
"foo"  == "" retorna TRUE
```

e

```
"foo"  eq "" retorna FALSE
```


Esta tabela pode ser útil para ver os resultados:

```
 12.0   == 12    TRUE
"12.0"  == 12    TRUE
"12.0"  eq 12    FALSE
  2     <   3    TRUE
  2    lt   3    TRUE
 12     >   3    TRUE
 12    gt   3    FALSE ! (cuidado, pode não ser óbvio a primeira vista)
"foo"  ==  ""    TRUE  ! (Você recebe alertas se usar o pragma "warnings")
"foo"  eq  ""    FALSE
"foo"  == "bar"  TRUE  ! (Você recebe alertas se usar o pragma "warnings")
"foo"  eq "bar"  FALSE
```

Por fim, um exemplo onde as pessoas podem cair em uma armadilha é quando se
recebe alguma entrada do usuário e depois de remover cuidadosamente a quebra
de linha do final da entrada, tenta-se verificar se a string dada é vazia.

```perl
use strict;
use warnings;
use 5.010;

print "input: ";
my $name = <STDIN>;
chomp $name;

if ( $name == "" ) {   # errado! aqui você precisa usar eq ao invés de == !
  say "TRUE";
} else {
  say "FALSE";
}
```

Se você rodar este script e digitar "abc" você vai receber TRUE como retorno,
como se o Perl pensasse que "abc" é igual à string vazia.
