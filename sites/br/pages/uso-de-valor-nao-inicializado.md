---
title: "Uso de valor não inicializado"
timestamp: 2013-03-20T23:45:56
tags:
  - undef
  - valor não inicializado
  - $|
  - alertas
  - buferização
published: true
original: use-of-uninitialized-value
books:
  - beginner
author: szabgab
translator: fredlopes
---


Esse é um dos alertas (warnings) mais comuns que você encontrará ao executar programas em Perl.

É só um alerta, que não fará seu programa parar, e será gerado apenas se a opção `warnings` estiver presente. O que é altamente recomendado.

A maneira mais comum de ligar os alertas é através da inclusão do comando `use warnings;` no começo de seu programa ou módulo.


O velho método é o de adicionar o parâmetro `-w` na primeira linha, que, em geral, se parece com essa:

`#!/usr/bin/perl -w`

Existem algumas diferenças, mas como `use warnings` está à disposição há mais de 12 anos, não há razão para evitá-lo. Em outras palavras:

Sempre `use warnings;`!

Vamos voltar agora ao alerta em questão.

## Uma explicação rápida

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.
(Uso de valor não inicializado $x em say em perl_warning_1.pl linha 6.)
```

Isso significa que a variável `$x` não tem nenhum valor (seu valor é o valor especial `undef`).
Ou ela nunca teve um valor, ou em algum momento lhe foi atribuído o valor `undef`.

Você deveria dar um olhada quando a variável recebeu seu último valor, ou pelo menos tentar entender por que aquela parte do código nunca foi executada.

## Um exemplo simples

O exemplo seguinte vai gerar o alerta em questão:

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
```

Perl é muito legal, e irá nos dizer qual arquivo gerou o alerta, e em qual linha.

## Somente um alerta

Como eu disse, isso é só um alerta. Se o programa tem mais comandos depois do `say`, eles serão executados:

```perl
use warnings;
use strict;
use 5.010;

my $x;
say $x;
$x = 42;
say $x;
```

Isso vai imprimir

```
Use of uninitialized value $x in say at perl_warning_1.pl line 6.

42
```

## Ordem confusa na saída

Tenha cuidado, no entanto, se seu código tem comandos antes da linha que gera o alerta, como neste exemplo:

```perl
use warnings;
use strict;
use 5.010;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

O resultado pode ser confuso:

```
Use of uninitialized value $x in say at perl_warning_1.pl line 7.
OK
42
```

Aqui, o resultado do primeiro `say` é visto <b>depois</b> do alerta, mesmo se ele foi chamado <b>antes</b> do código que gerou o alerta.

Esse comportamento estranho é o resultado da `buferização de ES (entrada e saída)`. Por padrão, Perl buferiza STDOUT, o canal padrão de saída, mas não buferiza STDERR, o canal padrão de erros.

Assim, enquanto a palavra 'OK' espera pelo despejo do buffer, a mensagem de alerta já chega à tela.

## Desligando a buferização

Para evitar isso, você pode desligar a buferização da STDOUT.

Isso é feito com o seguinte código: `$| = 1;` no começo do programa.

```perl
use warnings;
use strict;
use 5.010;

$| = 1;

print 'OK';
my $x;
say $x;
$x = 42;
say $x;
```

```
OKUse of uninitialized value $x in say at perl_warning_1.pl line 7.
42
```

(O alerta fica na mesma linha de <b>OK</b> porque não acrescentamos uma nova linha `\n` depois do OK.

## O escopo indesejado

```perl
use warnings;
use strict;
use 5.010;

my $x;
my $y = 1;

if ($y) {
  my $x = 42;
}
say $x;
```

Esse código também produz `Use of uninitialized value $x in say at perl_warning_1.pl line 11.`

Consegui cometer esse engano várias vezes. Sem prestar atenção, usei `my $x` dentro do bloco `if`, o que significa que criei outra variável $x, atribuí 42 a ela e usei-a fora do escopo no fim do bloco. (O `$y = 1` serve apenas para guardar lugar para algum código de verdade em condições reais. Está aí apenas para fazer esse exemplo ficar um pouco mais realista.)

Existem, é claro, casos em que preciso declarar uma variável dentro de um bloco `if`, mas isso não acontece sempre. Quando o faço por engano, encontrar o erro torna-se uma atividade penosa.

