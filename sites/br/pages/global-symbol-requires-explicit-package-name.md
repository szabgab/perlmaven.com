---
title: "Global symbol requires explicit package name"
timestamp: 2014-09-15T08:53:00
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
translator: leprevost
---


<b>Global symbol requires explicit package name</b>  é uma mensagem bastante comum, e na minha opinião, bastante enganadora. Pelo menos para os iniciantes.

Uma rápida tradução seria algo do tipo “Você precisa declarar a variável utilizando <b>my</b>.


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

Enquanto que a mensagem de erro está correta, é de pouca utilidade para o programador iniciante em Perl.
Muito provavelmente ele ainda não aprendeu sobre o uso de pacotes.
Ou então não saiba ainda o que pode ser mais explícito do que $x.

Este erro é gerado pelo uso do pragma <b>use strict</b>

A explicação encontrada na documentação é a seguinte:

<i>
Isso gera um erro em tempo de compilação se você tentar acessar uma variável que não fora declarada através do comando “our” ou “use vars”, localizado via “my()”, ou então, não qualificada inteiramente.
</i>

É de se esperar que um iniciante comece todos os seus scripts com <b>use strict</b>, e dessa forma irá provavelmente aprender sobre <b>my</b> muito antes de qualquer outra possibilidade.

Eu não sei se o texto atual pode, ou então deve, ser modificado na documentação, este não é o ponto deste artigo. O objetivo é auxiliar iniciantes a entender em sua linguagem, o que a mensagem significa.

Para eliminar o erro acima você precisa escrever :

```perl
use strict;
use warnings;

my $x = 42;
```

Ou seja, você precisa <b>declarar a variável antes de utilizá-la pela primeira vez</b>.

## A má solução

A outra “solução” seria remover o <b>strict</b>:

```perl
#use strict;
use warnings;

$x = 23;
```

isso funcionaria também, porém o código acima geraria a seguinte mensagem de aviso:
[Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo).

De qualquer forma, normalmente você não dirigiria um carro sem cintos de segurança, certo?

## Exemplo 2: escopo

Outra situação que normalmente vejo iniciantes fazendo se parece com o seguinte:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
my $y = 2;
}

print $y;
```

O erro que obtemos é o mesmo que o acima:

```
Global symbol "$y" requires explicit package name at ...
```

o que gera surpresa em muitas pessoas, especialmente quando elas estão começando a programar.
Afinal de contas, a variável `$y` foi declarada utilizando `my`.

Primeiro, há um pequeno problema visual.  A indentação da linha `my $y = 2;` está faltando.
Se fosse indentado alguns espaços à direita, como no próximo exemplo, a fonte do problema ficaria mais óbvia.

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
}

print $y;
```

O problema é que a variável `$y` está declarada dentro de um bloco (aquele par de chaves) o que significa que a variável não existe fora desse bloco. Isso é chamado de <a href="/escopo-das-variaveis-em-perl"><b>escopo</b> de uma variável</a>.

A ideia toda do <b>escopo</b> difere um pouco entre diferentes linguagens de programação.
No Perl, um bloco cercado por chaves gera um escopo novo.
O que está declarado dentro desse bloco utilizando `my` não será visível fora do bloco.

A solução seria chamar a função `print` dentro do bloco:

```perl
use strict;
use warnings;

my $x = 1;

if ($x) {
    my $y = 2;
    print $y;
}
```

ou então declarar a variável fora do bloco ( e não do lado de dentro!):

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

Qual forma é a melhor depende da sua tarefa, estas são apenas exemplos de soluções corretas.

Obviamente, se nós esquecermos de remover o `my` de dentro do bloco, ou se `$x` for falsa, nós obteremos uma viso do tipo [Use of uninitialized value](uso-de-valor-nao-inicializado) .

## Outras formas

A explicação das funcionalidades dos comandos `our` e `use vars` foi deixado para outro tutorial.
