---
title: "Variáveis Escalares"
timestamp: 2013-05-27T01:27:00
tags:
  - strict
  - my
  - undef
  - say
  - +
  - x
  - .
  - sigil
  - $
  - @
  - %
  - FATAL warnings
published: true
original: scalar-variables
books:
  - beginner
author: szabgab
translator: aramisf
---


Nesta seção do [Tutorial Perl](/perl-tutorial), vamos aprender
sobre as estruturas de dados disponíveis no Perl e como podemos utiliza-las.

No Perl 5 existem basicamente 3 estruturas. <b>Escalares, arrays e hashes</b>.
A última também é conhecida em outras linguagens como dicionário, tabela de
consulta ou array associativo.


Variáveis em Perl são sempre precedidas com um sinal chamado <b>selo</b>.
Esse sinal é `$` para escalares, `@` para arrays, e `%` para hashes.

Um escalar pode conter um único valor tal como um número ou uma string. Ele
pode também conter uma referência para outra estrutura de dados que vamos
aprender posteriormente.

O nome do escalar sempre começa com um `$` (cifrão) seguido por letras
números e sublinhados. Um nome de variável pode ser `$nome` ou
`$um_nome_longo_e_descritivo`. Pode ser ainda
`$NomeLongoEDescritivo`, formato este que costuma ser chamado
"CamelCase", mas a comunidade Perl geralmente prefere nomes com letras
minúsculas separadas por sublinhados.

Como sempre usamos <b>strict</b>, devemos sempre declarar nossas variáveis
antes de usá-las, usando o <b>my</b>. (Posteriormente você vai aprender sobre
<b>our</b> e algumas outras formas, mas por enquanto vamos focar somente na declaração
<b>my</b>). Podemos inclusive definir um valor imediatamente, como neste
exemplo:

```perl
use strict;
use warnings;
use 5.010;

my $name = "Foo";
say $name;
```

ou podemos declarar a variável antes e só atribuir um valor depois:

```perl
use strict;
use warnings;
use 5.010;

my $name;

$name = "Foo";
say $name;
```

Preferimos a primeira forma se a lógica do código permitir.

Se declaramos uma variável, mas ainda não lhe atribuímos nada, então ela tem
um valor chamado [undef](/undef-e-definido-em-perl) que é
semelhante ao <b>NULL</b> dos bancos de dados, mas que tem um valor
ligeiramente distinto.

Podemos verificar se uma variável é `undef` ou não usando a função
`defined`:

```perl
use strict;
use warnings;
use 5.010;

my $name;

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

$name = "Foo";

if (defined $name) {
  say 'defined';
} else {
  say 'NOT defined';
}

say $name;
```

Podemos definir uma variável escalar como `undef` atribuindo
`undef` a ela:

```perl
$name = undef;
```

As variáveis escalares podem armazenar tanto números quanto strings. Então posso escrever:

```perl
use strict;
use warnings;
use 5.010;

my $x = "hi";
say $x;

$x = 42;
say $x;
```

e simplesmente vai funcionar.

Como isto funciona juntamente com operadores e sobrecarga de operadores em
Perl?

Geralmente o Perl funciona de forma oposta a outras linguagens. Ao invés dos
operandos determinarem como o operador irá se comportar, o operador diz aos
operandos como eles devem se comportar.

Por exemplo, se eu tenho duas variáveis que contêm números, então o operador
decide se elas realmente se comportam como números, ou se elas se comportam
como strings:

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = 4;
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

`+`, o operador de adição numérica, soma os dois números, então ambos
`$y` e `$z` agem como números.

`+`, concatena duas strings, então ambos `$y` e `$z` agem
como strings. (Em outras linguagens você pode chamar isto de adição de
strings.)

`x`, o operador de repetição, repete a string do lado esquerdo o número
de vezes indicado pelo número ao lado direito, então neste caso, `$z`
se comporta como uma string e `$y` como um número.

Os resultados seriam os mesmos se eles tivessem sido criados como strings:

```perl
use strict;
use warnings;
use 5.010;

my $z = "2";
say $z;             # 2
my $y = "4";
say $y;             # 4

say $z + $y;        # 6
say $z . $y;        # 24
say $z x $y;        # 2222
```

Mesmo se um deles for criado como número e o outro como string:

```perl
use strict;
use warnings;
use 5.010;

my $z = 7;
say $z;             # 7
my $y = "4";
say $y;             # 4

say $z + $y;        # 11
say $z . $y;        # 74
say $z x $y;        # 7777
```

O Perl converte automaticamente números para strings e strings para números
conforme requerido pelo operador.

Chamamos isso de <b>contextos</b> numéricos e <b>contextos</b> de string.

Os casos acima são fáceis. Quando convertemos um número em uma string é como
se colocássemos aspas ao seu redor. Ao converter uma string em um número em
uma string, existem casos simples como vimos, quando toda a string consiste
apenas de dígitos. O mesmo aconteceria se houvesse um ponto decimal na string,
tal como em `"3.14"`.
A questão é: E se a string tiver caracteres que não são parte de nenhum
número? ex. `"3.14 is pi"`.
Como isto se comportaria em uma operação numérica (também conhecido como
contexto numérico)?

Até isso é simples, mas pode exigir alguma explicação.

```perl
use strict;
use warnings;
use 5.010;

my $z = 2;
say $z;             # 2
my $y = "3.14 is pi";
say $y;             # 3.14 is pi

say $z + $y;        # 5.14
say $z . $y;        # 23.14 is pi
say $z x $y;        # 222
```

Quando uma string está em um contexto numérico o Perl olha para o lado
esquerdo da string, e tenta converte-la em um número. Enquanto esta conversão
fizer sentido, a parte convertida se torna o valor numérico da variável.
Dentro do contexto numérico (`+`) a string `"3.14 is pi"` é
considerada como o número `3.14`.

De certa forma isto é completamente arbitrário, mas este é seu comportamento e
convivemos com isso.

O código acima também vai gerar um alerta na saída de erro padrão
(`STDERR`):

```
Argument "3.14 is pi" isn't numeric in addition(+) at example.pl line 10.
```

considerando que você usou <b>use warnings</b> o que é altamente recomendável.
Usar os alertas vai te ajudar a perceber quando algo não está ocorrendo
exatamente como o esperado.
Espero que o resultado de `$x + $y` agora esteja claro.

## Fundamento

Para deixar claro, o Perl não converteu `$y` para 3.14. Ele apenas utilizou
seu valor numérico para a adição.
Isto provavelmente também explica o resultado de `$z . $y`.
Neste caso o Perl está usando o valor original da string.

Você pode estar se perguntando por que `$z x $y` mostra 222 ao passo que
tínhamos 3.14 no lado direito do operador, mas o Perl parece poder apenas
repetir uma string um número inteiro de vezes... O Perl silenciosamente
arredonda o valor do número à direita na operação. (Se você quer mesmo
compreender a fundo, você pode reconhecer que o contexto "numérico" mencionado
anteriormente tem na verdade diversos sub-contextos, um deles sendo o contexto
"inteiro". Na maioria dos casos, o Perl faz o que parece ser "a coisa certa"
para a maioria das pessoas que não são programadores. para a maioria das
pessoas que não são programadores)

Mais que isso, nós nem mesmo vemos o alerta de "conversão parcial de string
para número" que vimos no caso do `+`.

Isto não ocorre por causa da diferença no operador. Se comentarmos a adição
veremos o alerta nesta operação. A razão para a falta de um segundo alerta é
que quando o Perl gerou o valor numérico da string `"3.14 is pi"` ele
também armazenou secretamente um espaço para a variável `$y`. Então
efetivamente `$y` agora armazena ambos, uma string e um valor numérico,
e o Perl usará o valor adequado em qualquer nova operação, evitando a conversão.

Existem mais três coisas que eu gostaria de apontar. Uma é o comportamento de
uma variável contendo `undef`, a outra é o `alerta de
fatalidade` e a terceira é evitar a "conversão automática de string para
número".

## undef

Se dentro de uma variável eu tenho um `undef` que muitos diriam que é o
mesmo que "nada", isto ainda assim pode ser usado.
Dentro do contexto numérico ele vai agir como 0, e em um contexto de string,
como a string vazia.

```perl
use strict;
use warnings;
use 5.010;

my $z = 3;
say $z;        # 3
my $y;

say $z + $y;   # 3
say $z . $y;   # 3

if (defined $y) {
  say "defined";
} else {
  say "NOT";          # NOT
}
```

Com dois alertas:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.

Use of uninitialized value $y in concatenation (.) or string at example.pl line 10.
```

Como você pode ver, a variável ainda é `undef` no final, e a
condicional vai imprimir "NOT".


## Alertas de Fatalidade

O outro ponto é que algumas pessoas preferem que a aplicação lance uma exceção
forte ao invés de um alerta suave. Se esta é a sua maneira, você pode
modificar o início do script e escrever

```perl
use warnings FATAL => "all";
```

Tendo isso escrito no código, o script vai imprimir o número 3, e então lançar
a seguinte exceção:

```
Use of uninitialized value $y in addition (+) at example.pl line 9.
```

Esta é a mesma mensagem do primeiro alerta, mas dessa vez o script interrompe
sua execução. (Claro, a menos que a exceção seja tratada, mas vamos tratar
disso em outro momento.)

## Evitando a conversão automática de string para número

Se você quiser evitar a conversão automática de strings quando não houver uma
conversão exata, você pode verificar se a string parece um número quando você
recebe-la do mundo exterior.

Para isso vamos carregar o módulo <a
href="https://metacpan.org/pod/Scalar::Util">Scalar::Util</a>, e usar a
subrotina `looks_like_number` que ela provê.

```perl
use strict;
use warnings FATAL => "all";
use 5.010;

use Scalar::Util qw(looks_like_number);

my $z = 3;
say $z;
my $y = "3.14";

if (looks_like_number($z) and looks_like_number($y)) {
  say $z + $y;
}

say $z . $y;

if (defined $y) {
  say "defined";
} else {
  say "NOT";
}
```


## Sobrecarga de Operador

Por fim, é possível ter sobrecarga de operadores no caso onde os operandos
diriam ao operador o que ele deve fazer, mas vamos deixar isto como um tópico
avançado.


