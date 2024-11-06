---
title: "Variável 'my' mascara declaração anterior no mesmo escopo"
timestamp: 2014-11-12T22:01:56
tags:
  - my
  - scope
published: true
original: my-variable-masks-earlier-declaration-in-same-scope
books:
  - beginner
author: szabgab
translator: aramisf
---


Este erro de compilação aparecerá se, por engano, você tentou declarar a mesma
variável mais de uma vez dentro do mesmo escopo.

```
"my" variable ... masks earlier declaration in same scope at ... line ...
```

Como isto pode acontecer, e como funciona o processo de declarar novamente as
variáveis a cada iteração de um laço?

Se eu não posso escrever `my $x` duas vezes em um escopo, então como
posso esvaziar esta variável?


Vejamos as diferenças entre os breves casos a seguir:

## Script simples

```perl
use strict;
use warnings;

my $x = 'this';
my $z = rand();
my $x = 'that';
print "OK\n";
```

Neste caso recebo o seguinte alerta em tempo de compilação:

```
"my" variable $x masks earlier declaration in same scope at ... line 7. )
```

Você sabe que isso é apenas um alerta, porque executar o script também
imprimirá "OK".


## Bloco dentro de uma condicional

```perl
use strict;
use warnings;

my $z = 1;
if (1) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

Isso gera o seguinte alerta:

```
"my" variable $x masks earlier declaration in same scope at ... line 7.
```

Em ambos os casos, declaramos `$x` duas vezes no mesmo escopo, o que
vai gerar um alerta em tempo de compilação.

No segundo exemplo, declaramos `$z` duas vezes também, mas isto não
gerou nenhum alerta. Isto ocorre porque o `$z` dentro do bloco é um
[escopo à parte](/escopo-das-variaveis-em-perl).

## O escopo de uma função

Mesmo código, mas em uma função:

```perl
use strict;
use warnings;

sub f {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
f(1);
f(2);
```

Aqui também, você é alertado (uma vez) em tempo de compilação para a variável
`$x`, mesmo que ela seja 'trazida à existência' repetidamente, uma vez
para cada chamada da função.
Tudo bem quanto a isso. A variável `$z` não gera o alerta:
o Perl pode criar a mesma variável duas vezes, é você quem não deveria
fazê-lo. Ao menos não dentro de um mesmo escopo.

## O escopo de um laço for

Mesmo código, mas em um laço:

```perl
use strict;
use warnings;

for (1 .. 10) {
    my $x = 'this';
    my $z = rand();
    my $x = 'that';
}
```

Isto também vai gerar (apenas uma vez!) o alerta citado anteriormente para a
variável `$x`, mas nenhum para `$z`.

Neste código o mesmo acontece para <b>cada</b> iteração:
o Perl vai alocar memória para a variável `$z` a cada iteração.

## O que o "my" realmente significa?

O significado do `my $x` é que você diz ao Perl, e mais especificamente ao
`strict`, que você gostaria de usar uma variável privada chamada
<b>$x</b> no [escopo atual](/escopo-das-variaveis-em-perl).
Sem isso, o Perl vai procurar uma declaração nos escopos superiores e se ele
não conseguir encontrar uma declaração em lugar algum, ele vai gerar um erro
em tempo de compilação <a
href="/simbolo-global-requer-nome-de-pacote-explicito">Símbolo Global requer
nome explícito de pacote</a>.
Cada início de bloco, cada chamada para função, cada iteração de um laço é um
novo mundo.

Por outro lado, escrever `my $x` duas vezes no mesmo escopo significa
apenas que você quer dizer a mesma coisa duas vezes ao Perl. Isto não é
necessário e costuma significar que há um erro em algum lugar.

Em outras palavras, o alerta que recebemos está relacionado à
<b>compilação</b> do código e não à execução. Está relacionado à declaração da
variável pelo desenvolvedor, e não à alocação de memória feita pelo Perl
durante a execução.

## Como esvaziar uma variável existente?

Se não podemos escrever `my $x` duas vezes no mesmo escopo, então
como podemos definir a variável como "vazia"?

Antes de tudo, se uma variável é declarada dentro de um escopo, ou seja, entre
duas chaves quaisquer, então ela automaticamente desaparece quando a execução
deixa o [escopo](/escopo-das-variaveis-em-perl).

Se você só quer "esvaziar" a variável escalar no escopo atual, atribua a ela
um `undef`, e se a variável for um <a
href="https://perlmaven.com/undef-on-perl-arrays-and-hashes">array ou hash</a>, então esvazie-a
atribuindo uma lista vazia:

```perl
$x = undef;
@a = ();
%h = ();
```

Enfim, para fins de esclarecimento. "my" diz ao Perl que você gostaria de usar
uma variável. Quando o Perl alcança o código onde você tem "my variável" ele
aloca memória para a variável e seu conteúdo.
Quando o Perl alcança o código `my $x = undef;` ou `@x = ();` ou
`undef @x;` ele remove o conteúdo que a variável possuía.
