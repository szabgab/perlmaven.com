---
title: "Operadores Numéricos"
timestamp: 2014-10-29T09:28:00
tags:
  - +
  - "-"
  - "*"
  - /
  - "%"
  - ++
  - --
  - +=
  - "*="
  - "-="
  - /=
  - "%="
published: true
original: numerical-operators
books:
  - beginner
author: szabgab
translator: leprevost
---


Assim como a maioria das demais linguagens de programação, Perl possui um conjunto básico de operadores numéricos:
`+` para adição, `-` para subtração, `*` para multiplicação, `/` para divisão:


```perl
use strict;
use warnings;
use 5.010;

say 2 + 3;   # 5
say 2 * 3;   # 6
say 9 - 5;   # 4
say 8 / 2;   # 4

say 8 / 3;   # 2.66666666666667
```

Note que Perl vai automaticamente mudar para número de ponto flutuante quando necessário, então quando nós dividimos 8 por 3 nós pegamos um valor de ponto flutuante.

```perl
use strict;
use warnings;
use 5.010;

say 9 % 2;   # 1
say 9 % 5;   # 4
```

O operador `%` é conhecido como operador de módulo. Ele retorna o valor do resto da divisão.

Os mesmos operadores numéricos podem ser utilizados em [variáveis escalares](/variaveis-escalares) contendo números:

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
my $y = 3;

say $x + $y;  # 5
say $x / $y;  # 0.666666666666667
```

## Operadores simplificados

A expressão `$x += 3;` é a forma simplificada da versão `$x = $x + 3;`, ambos possuem exatamente o mesmo efeito e o mesmo resultado.

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
say $x; # 2

$x = $x + 3;
say $x; # 5

my $y = 2;
say $y;  # 2
$y += 3;
say $y;  # 5
```

De forma geral, a construção `VARIÁVEL OPERADOR= EXPRESSÃO` é igual à `VARIÁVEL = VARIÁVEL OPERADOR EXPRESSÃO`, porém é mais fácil de ser lida e menos suscetível a erros ( Não precisamos escrever o nome da variável novamente).
Você pode usá-la com operadores binários:

`+=`, `*=`, `-=`, `/=`, até mesmo `%=`

(operadores binários atuam nos valores.)

## Auto incremento e auto decremento

Perl também fornece os operadores `++` para auto incremento e `--` auto decremento.
Eles aumentam e diminuem, respectivamente, os valores da variável escalar em 1 unidade.

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
say $x; # 2
$x++;
say $x; # 3

$x--;
say $x; # 2
```

Ambos operadores `$x++`, `$x--` e as versões `++$x`, `--$x` comportam-se da mesma forma que em outras linguages. Caso não esteja familiarizado, então este não é o momento pata se aprofundar neles.

Esses operadores podem ser utilizados como parte de grandes expressões quando as versões prefixo e sufixo são realmente importantes, mas na maioria dos casos eu acredito que seja melhor evitar tais expressões. Elas podem ser interessantes, mas um verdadeiro pesadelo para dar manutenção.
Nós teremos no tutorial um artigoo para explicar os efeitos de curto-circuito e as suas vantagens e desvantagens 

Em adição, o operador de auto-incremento também pode ser empregado em textos, como é explicado no artigo sobre [operadores textuais](/operadores-textuais).


