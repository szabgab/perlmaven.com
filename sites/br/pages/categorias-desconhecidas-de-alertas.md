---
title: "Categoria de alertas desconhecida"
timestamp: 2013-04-10T10:45:56
tags:
  - ;
  - alertas
published: true
original: unknown-warnings-category
books:
  - beginner
author: szabgab
translator: fredlopes
---


Não acho que essa seja uma mensagem de erro comum em Perl. Pelo menos não me lembro de tê-la visto antes, mas recentemente ela me pegou durante um treinamento em Perl.


## Categoria de alertas desconhecida '1'

A mensagem de erro toda parecia-se com essa:

```
Unknown warnings category '1' at ola_mundo.pl line 4
BEGIN failed--compilation aborted at ola_mundo.pl line 4.
(Categoria de alertas desconhecida '1' em ola_mundo.pl linha 4
BEGIN falhado--compilação abortada em ola_mundo.pl linha 4)
Olá, mundo!
```

Isso foi muito perturbador, principalmente porque o código era muito simples:

```
use strict;
use warnings

print "Olá, mundo!";
```

Prestei bastante atenção e não vi nenhum problema no código. Como você pode ver, ele imprimiu "Olá, mundo!".

Isso me pegou de jeito, e levou bastante tempo para eu notar o que você provavelmente já notou:

o problema é a falta do ponto-e-vírgula depois do comando `use warnings`. Enquanto perl executa o comando print, ele imprime a cadeia de caracteres, e a função `print` retorna 1 indicando que foi bem-sucedida.

Perl pensa que escrevi `use warnings 1`.

Há muitas categorias de alertas, mas nenhuma delas é chamada de "1".

## Categoria desconhecida 'Zé' de alertas

Este é outro caso do mesmo problema.

A mensagem de erro se parece com essa:

```
Unknown warnings category 'Zé' at ola.pl line 4
BEGIN failed--compilation aborted at ola.pl line 4.
(Categoria desconhecida 'Zé' de alertas em ola.pl linha 4
BEGIN falhado--compilação abortada em ola.pl linha 4.)
```

e o código de exemplo está mostrando como a interpolação em cadeias de caracteres funciona. Este é, pode-se dizer, o segundo exemplo que ensino, logo depois do "Olá, mundo".

```perl
use strict;
use warnings

my $name = "Zé";
print "Hi $name\n";
```

## Ponto-e-vírgula faltando

É claro que esses são apenas casos especiais do problema genérico de esquecer um ponto-e-vírgula. Perl só consegue perceber isso no comando seguinte.

É geralmente uma boa ideia checar a linha imediatamente anterior ao lugar indicado na mensagem de erro. Talvez lá esteja faltando um ponto-e-vírgula.


