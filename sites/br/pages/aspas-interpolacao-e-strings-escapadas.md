---
title: "Strings em Perl: entre aspas, interpoladas e escapadas"
timestamp: 2013-05-31T17:15:03
tags:
  - strings
  - "'"
  - escape character
  - interpolation
  - quote
  - embedded characters
  - q
  - qq
published: true
original: quoted-interpolated-and-escaped-strings-in-perl
books:
  - beginner
author: szabgab
translator: aramisf
---


Entender como as strings funcionam é importante em toda linguagem de
programação, mas em Perl elas são parte da essência da linguagem.
Especialmente se você considerar que um dos acrônimos do Perl é <b>Practical
Extraction and Reporting Language</b> e para isso você precisa usar muitas
strings.


Strings podem ser colocadas dentro de aspas simples `'` ou duplas
`"` e elas tem um comportamento ligeiramente diferente.

## Strings com aspas simples

Se você coloca caracteres entre aspas simples `'`, então quase todos os
caracteres, exceto a aspa simples `'` e a contra-barra `\`, o
caractere de escape, são interpretados como são escritos no código.

```perl
my $name = 'Foo';
print 'Hello $name, how are you?\n';
```

A saída será:

```
Hello $name, how are you?\n
```

## Strings com aspas duplas

Strings colocadas entre aspas duplas `"` provêm interpolação (outras
variáveis embutidas na string serão substituídas pelo seu conteúdo), e elas
também substituem os caracteres escapados especiais, tais como `\n` por
uma quebra de linha e `\t` por uma tabulação.

```perl
my $name = 'Foo';
my $time  = "today";
print "Hello $name,\nhow are you $time?\n";
```

A saída será:

```
Hello Foo,
how are you today?

```

Nota, há um `\n` logo depois da vírgula e outro ao final da string.

Para strings simples tais como 'Foo' e "today" que não possuem os caracteres
`$`, `@`, e `\`, não faz diferença se forem colocadas
entre aspas duplas ou simples.

As duas linhas seguintas tem exatamente o mesmo resultado:

```perl
$name = 'Foo';
$name = "Foo";
```


## Endereços de Correio Eletrônico

Como `@` também interpola entre aspas duplas, escrever endereços de
correio eletrônico precisam de um pouco mais atenção.

Em aspas simples `@` não interpola.

Em aspas duplas esse código gera um erro:
<a href="/simbolo-global-requer-nome-de-pacote-explicito">Global symbol "@bar"
requires explicit package name at ... line ...</a>

e um alerta:
<b>Possible unintended interpolation of @bar in string at ... line ...</b>

Este último pode ser aquele que nos dá a melhor pista do que está realmente
acontecendo.

```perl
use strict;
use warnings;
my $broken_email  = "foo@bar.com";
```

Esse código, por outro lado, tendo o endereço de correio eletrônico entre
aspas simples, vai funcionar.

```perl
use strict;
use warnings;
my $good_email  = 'foo@bar.com';
```

E se você precisar de ambos interpolações de variáveis escalares e quiser
incluir arrobas `@` na string?

```perl
use strict;
use warnings;
my $name = 'foo';
my $good_email  = "$name\@bar.com";

print $good_email; # foo@bar.com
```

Você sempre pode <b>escapar</b> os caracteres especiais, neste caso a arroba
`@`, usando o chamado <b>caractere de escape</b> que é a contra-barra
`\`.

## Embutindo o cifrão $ em strings com aspas duplas

Do mesmo jeito se você quiser incluir um sinal `$` em uma string com
aspas duplas, você pode escapa-lo também:

```perl
use strict;
use warnings;
my $name = 'foo';
print "\$name = $name\n";
```

Vai imprimir:

```
$name = foo
```

## Escapando o escape

Existem casos onde você gostaria de incluir o escape na string. Se você
colocar uma contra-barra `\` em uma string, (seja ela com aspas simples
ou duplas), o Perl vai pensar que você quer escapar o próximo caractere e
fazer sua mágica.

Não se preocupe. Você pode dizer ao Perl para parar isso escapando o
caractere de escape:

Simplesmente coloque mais um escape antes dele:

```perl
use strict;
use warnings;
my $name = 'foo';
print "\\$name\n";:w
```

```
\foo
```

Entendo que escapar um escape é um pouco estranho, mas isto é basicamente como
a coisa funciona em todas as outras linguagens também.


Se você quiser entender como funciona esse esquema de escapes, tente algo
como:

```perl
print "\\\\n\n\\n\n";
```

veja o que é impresso:

```
\\n
\n
```

e tente explicar para si mesmo.

## Escapando aspas duplas

Vimos que você pode colocar variáveis escalares em strings envoltas por aspas
duplas e pode também escapar o sinal `$`.

Vimos que você pode usar o escape `\` e como pode escapa-lo também.

E se você quiser imprimir uma aspa dupla dentro de uma string envolta por
aspas duplas?


Este código tem um erro de sintaxe:

```perl
use strict;
use warnings;
my $name = 'foo';
print "The "name" is "$name"\n";
```

Quando o Perl ve aspas duplas logo antes da palavra "name" ele pensa que este
foi o final da string e então ele reclama que a palavra <b>name</b> é uma <a
href="/palavras-soltas-em-perl">palavra solta</a>.

Você já deve ter conjecturado, é preciso escapar as aspas duplas `"`
ali embutidas:

```perl
use strict;
use warnings;
my $name = 'foo';
print "The \"name\" is \"$name\"\n";
```

Isto vai imprimir:

```
The "name" is "foo"
```

Funciona, mas é um tanto difícil de ler.


## qq, o operator duplo-q

Aqui é onde você pode usar o `qq`, ou o operador duplo-q:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The "name" is "$name"\n);
```

Para olhos não treinados, o qq() pode parecer uma chamada de função, mas não
é. `qq` é outro operador e você verá em um segundo o que mais ele pode
fazer, mas antes deixe-me explicar.

Trocamos as aspas duplas `"` que costumavam envolver a string pelos
parêntesis do `qq`. Isso significa que as aspas duplas não são mais
especiais na string, e não é mais necessário escapá-las.
Isso faz o código ficar mais legível.
Até poderia dizer que ficou mais bonito, se eu não temesse a ira dos
programadores Python.

Mas e se você quisesse incluir os parêntesis na sua string?

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The (name) is "$name"\n);
```

Sem problemas, contanto que eles estejam pareados (ou seja, ter a mesma
quantidade de parêntesis abertos `(` e fechados `)`, e sempre
ter um parentesis aberto `(` antes de seu correspondente fechado
`)`) o Perl pode entender.

Eu sei. Você vai querer fechar parêntesis antes de abrir, só para quebrar a
regra:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq(The )name( is "$name"\n);
```

De fato, o Perl lhe dará um erro de sintaxe sobre "name" ser uma<a
href="/palavras-soltas-em-perl">palavra solta</a>. O Perl não pode entender
tudo, pode?

Claro que é possível escapar os parêntesis dentro da string `\)` e
`\(`, mas já descemos nessa toca de coelho.
Não, obrigado!

Deve haver um caminho melhor.

Lembra que escrevi que o `qq` é um operador e não uma função? Então ele
pode fazer truques, certo?

E se trocarmos os parêntesis que envolvem a string por chaves? `{}`:

```perl
use strict;
use warnings;
my $name = 'foo';
print qq{The )name( is "$name"\n};
```

Funciona e imprime a string que queríamos:

```
The )name( is "foo"
```

(contudo, não sei porquê eu iria querer imprimir uma coisa desse tipo...)

Então o <a
href="http://perl.plover.com/yak/presentation/samples/slide027.html">cara da
segunda fila</a> levanta a mão e pergunta: "E se você quiser parêntesis e
chaves na sua string, ambos descasados? (link em inglês)

Você quer dizer assim, certo?

```perl
use strict;
use warnings;
my $name = 'foo';
print qq[The )name} is "$name"\n];
```

imprime isto:

```
The )name} is "foo"
```


... deve haver uma forma de utilizar os colchetes também, certo?


## q, o operator q-único

Semelhante ao `qq` existe também um operador chamado `q`. Ele
também permite que você selecione os delimitadores da sua string, mas isso
funciona como uma aspa simples `'` funciona: <b>SEM</b> interpolação de
variáveis.

```perl
use strict;
use warnings;
print q[The )name} is "$name"\n];
```

imprime:

```
The )name} is "$name"\n
```


