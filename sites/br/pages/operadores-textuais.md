---
title: "Operadores textuais: concatenação (.), repetição (x)"
timestamp: 2014-10-30T09:48:00
tags:
  - x
  - .
  - ++
published: true
original: string-operators
books:
  - beginner
author: szabgab
translator: leprevost
---


Em adição aos [operadores numéricos](/operadores-numericos) o Perl possui dois operadores utilizados especialmente em textos.
Um deles é o `.` para concatenação, e o outro é `x` para repetições.


```perl
use strict;
use warnings;
use 5.010;

my $x = 'Hello';
my $y = 'World';

my $z = $x . ' ' . $y;
say $z;
```

A execução do código acima gera o seguinte resultado:

```
Hello World
```

A função juntou o texto da variável e o elemento literal em um único texto.

Na verdade, no exemplo acima não precisaríamos ter que utilizar o operador `.` de concatenação para chegar no resultado. A linguagem fornece a função de interpolação de variáveis em texto, então poderíamos apenas escrever:


```perl
my $z = "$x $y";
```

e isso acabaria dando o mesmo resultado.

## Quando a interpolação não é a resposta certa

Obviamente existem casos onde a concatenação não pode ser substituída pela interpolação. Veja o seguinte código como exemplo:

```perl
use strict;
use warnings;
use 5.010;

my $x = 2;
my $y = 3;

my $z = 'Take ' . ($x + $y);

say $z;
```

O resultado será

```
Take 5
```

Por outro lado, se substituirmos a concatenação pela interpolação: 

```perl
my $z = "Take ($x + $y)";
```

Então nós temos:

```
Take (2 + 3)
```

Você deve ter notado que eu também mudei de aspas simples para aspas duplas quando eu quis utilizar a interpolação. Nós discutiremos isso mais a fundo em outro artigo.

## Operador de repetição x

O operador `x` espera um texto do seu lado esquerdo e um número ao seu lado direito.
Ele retornará o texto do lado esquerdo repetido tantas vezes quanto foi definido pelo valor do lado direito.

```perl
use strict;
use warnings;
use 5.010;

my $y = 'Jar ';

my $z = $y x 2;
say $z;

say $y x 2 . 'Binks';
```

resulta:

```
Jar Jar 
Jar Jar Binks
```

Eu imagino que este operador seja pouco utilizado, mas pode ser bastante útil nesses raros casos.
Por exemplo, quando você quer adicionar uma linha com o mesmo tamanho do seu título:

```perl
use strict;
use warnings;
use 5.010;


print "Please type in the title: ";
my $title = <STDIN>;
chomp $title;

say $title;
say '-' x length $title;
```

Aqui, a linha que imprimimos abaixo do título possui exatamente o mesmo tamanho (em número de caracteres) do título.

```
$ perl report.pl 
Please type in the title: hello
hello
-----

$ perl report.pl 
Please type in the title: hello world
hello world
-----------
```

## Utilizando ++ em textos

Apesar de imaginar que o operador de auto incremento (`++`) [atue somente em números](/operadores-numericos), o Perl possui um uso especial para o operador `++` em textos.

O operador pega o último caractere de um texto e o incrementa em uma unidade, de acordo com a tabela ASCII. Tanto letras de caixa baixa quanto de caixa alta. Se nós incrementarmos um texto que termine com a letra ‘y’, ele irá mudar o caractere para ‘z’. Se o texto terminar em ‘z’, então o incremento irá mudá-lo para a letra ‘a’, mas nesse caso a letra à esquerda irá mudar também

```perl
use strict;
use warnings;
use 5.010;

my $x = "ay";
say $x;
$x++;
say $x;


$x++;
say $x;

$x++;
say $x;

$x--;
say $x;
```

O resultado é:

```
ay
az
ba
bb
-1
```

Como você pode ver, o operador `--` não funciona em textos.
