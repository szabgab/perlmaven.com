---
title: "undef, valor inicial e a função defined em Perl"
timestamp: 2013-04-03T08:57:07
tags:
  - undef
  - defined
  - definido
published: true
original: undef-and-defined-in-perl
books:
  - beginner
author: szabgab
translator: leprevost
---


Em algumas linguages existe uma forma especial de se dizer "este campo não possui valor".
No <b>SQL</b>, <b>PHP</b> e <b>Java</b> é através do `NULL`. Em <b>Python</b> é
`None` e em <b>Ruby</b> é chamado `Nill`.

Em Perl o valor é chamado `undef`.

Vamos ver alguns detalhes.


## De onde você recebe valores undef?

Quando você declara uma variável escalar sem atribuir um valor a ela, o conteúdo será definido como `undef`.

```perl
my $x;
```

Algumas funções retornam `undef` para indicar uma falha.
Outras podem retornar undef se elas não possuem nada a retornar.

```perl
my $x = faça_algo();
```

Você pode usar a função `undef` para resetar uma variável à `undef`:

```perl
# código
undef $x;
```

Você pode até mesmo utilizar o valor de retorno da função `undef` para atribuir `undef` a uma variável:

```perl
$x = undef;
```

Os parênteses após o nome da função são opcionais, e neste caso eu omiti para exemplificar.

Como você pode observar existe diferentes formas de atribuir `undef` a uma variável.
A questão aqui é, o que acontece quando você utiliza uma dessas variáveis?

Mas antes disso, vamos ver um outro tópico:

## Como verificar se o valor de uma variável não é definido?

A função `defined()` irá retornar [verdadeiro](/valores-booleanos-em-perl) se
o valor em questão não for <b>não definido</b>. E irá retornar [falso](/valores-booleanos-em-perl)
se o valor não for definido, ou <b>undef</b>.

Você pode utilizá-la da seguinte forma:

```perl
use strict;
use warnings;
use 5.010;

my $x;

# aqui em cima há algum código que define $x

if (defined $x) {
    say '$x é definida';
} else {
    say '$x é undef';
}
```


## Qual é o verdadeiro valor de undef?

Enquanto `undef` indica a ausência de valor, ainda assim não pode ser utilizado.
O Perl oferece dois valores padrão para serem utilizdos no lugar de undef.

Se você utiliza uma variável que é undef em uma operação numérica, ela atua como se fosse 0.

Se você a utiliza em uma operação de texto, ela atua como se fosse um texto vazio.

Veja os exemplos a seguir:

```perl
use strict;
use warnings;
use 5.010;

my $x;
say $x + 4, ;  # 4
say 'Foo' . $x . 'Bar' ;  # FooBar

$x++;
say $x; # 1
```

No exemplo acima a variável $x - que é undef por padrão - age como 0 na adição (+).
No caso da concatenação (.), age como se fosse um texto vazio, e novamente como 0
durante o auto incremento (++).

Mesmo assim, não é algo à prova de falhas. Se você tivesse pedido para ativar os avisos pelo pragma `use warnings`
([que é bastante recomendado](/instalando-o-perl))
então teria dois avisos de [valor não inicializado](/uso-de-valor-nao-inicializado)
para as duas primeiras operações, porém não para o auto incremento:

```
Use of uninitialized value $x in addition (+) at ... line 6.
Use of uninitialized value $x in concatenation (.) or string at ... line 7.
```

Depois iremos ver que isso é bastante conveniente em lugares onde você gostaria de contar coisas.

É claro que você pode também evistar os avisos através da inicialização das variáveis no valor incial correto
(0 ou um texto vazio, dependendo do que esteja fazendo), ou pela possibilidade de desligar seletivamente os avisos.
Nós vamos discturi isso em um outro artigo.

