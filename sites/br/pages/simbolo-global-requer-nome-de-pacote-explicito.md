---
title: "Símbolo Global requer nome explícito de pacote"
timestamp: 2014-02-20T02:00:00
tags:
  - strict
  - my
  - package
  - global symbol
published: true
original: global-symbol-requires-explicit-package-name
books:
  - beginner
author: szabgab
translator: aramisf
---


<b>Global symbol requires explicit package name</b> é uma mensagem de erro
comum do Perl, e na minha humilde opinião, bastante enganosa. Ao menos para
iniciantes.

A tradução rápida para isto seria "Você precisa declarar a variável usando
<b>my</b>."


## O exemplo mais simples

```perl
use strict;
use warnings;

$x = 42;
```

E o erro é

```
Global symbol "$x" requires explicit package name at ...
```

Apesar da mensagem de erro estar correta, ela é de pouca utilidade para o
programador Perl iniciante, que provavelmente não aprendeu ainda o que é um
pacote.
Tampouco sabem o que pode ser mais explícito que $x

Este erro é gerado pelo <b>use strict</b>.

A explicação na documentação é:
<i>
Isto gera um erro em tempo de compilação se você acessar uma variável que não
foi declarada através de "our" ou "use vars", ou ainda, que não foi localizada
através do "my()", ou que não foi totalmente qualificada.
</i>

Com sorte, o programador iniciante vai iniciar todos os seus programas com
<b>use strict</b>, e provavelmente aprenderá sobre <b>my</b> muito antes de
quaisquer outras possibilidades.

Não sei se o texto corrente pode e deveria ser modificado no Perl. Este não é
o objetivo deste texto. O objetivo é ajudar os iniciantes a entender em sua
própria linguagem o que esta mensagem de erro significa.

Para eliminar a mensagem de erro acima, é necessário escrever:

```perl
use strict;
use warnings;

my $x = 42;
```

Ou seja, é preciso <b>declarar a variável usando my antes de sua primeira
utilização</b>.

## A solução ruim

A outra "solução" é remover o <b>strict</b>:

```perl
#use strict;
use warnings;

$x = 23;
```

Isso funcionaria mas este código vai gerar um aviso do tipo:
[Name "main::x" used only once: possible typo at ...](/nome-usado-apenas-uma-vez)

Em qualquer caso, você não dirigiria um carro sem usar o cinto de segurança,
dirigiria?

## Exemplo 2: escopo

Outro caso que vejo com frequência entre iniciantes parece com isto:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
my $y = 2;
}

print $y;
```

O erro que obtemos é o mesmo mostrado acima:

```
Global symbol "$y" requires explicit package name at ...
```

o que é surpreendente para muitas pessoas. Especialmente quando elas começam a
programar.
Afinal de contas, elas declararam `$y` usando `my`.

Primeiro, aí está um pequeno problema visual. Falta a identação de `my $y =
2;`. Se estivesse identado com alguns espaços ou um tab à direita, como no
próximo exemplo, a fonte do problema talvez seria mais óbvia:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
}

print $y;
```

O problema é que a variável `$y` está declarada dentro do bloco (o par
de chaves), o que significa que ela não existe fora deste bloco.
Isto é chamado <a href="/escopo-das-variaveis-em-perl">o <b>escopo</b> da
variável</a>.

Toda idéia do <b>escopo</b> é diferente entre as principais linguagens de
programação.
Em Perl, um bloco formado por chaves cria um escopo.
O que está declarado dentro, usando `my` não será acessível fora do
bloco.

(A propósito, o `$x = 1` está lá apenas para ter uma condição
aparentemente legítima que cria o escopo. Em outras palavras, a condição
`if ($x) {` está lá para fazer o exemplo parecer real.)

A solução é chamar o `print` dentro do bloco:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
    print $y;
}
```

ou declarar a variável fora do bloco (e não dentro!):

```perl
use strict;
use warnings;

my $x = 1;
my $y;

if ($x) {
    $y = 2;
}

print $y;
```

O caminho que você escolher depende da tarefa em questão. Estas são apenas as
possíveis soluções sintaticamente corretas.

Claro, se esquecermos de remover o `my` de dentro do bloco, ou se
`$x` for falso, então obteremos um aviso <a
href="/uso-de-valor-nao-inicializado">Uso de valor não iniciado</a>.

## Os outros meios

As explicações sobre o que o `our` e o `use vars` fazem, ou como
podemos qualificar completamente o nome de uma variável ficam para outro
artigo.

