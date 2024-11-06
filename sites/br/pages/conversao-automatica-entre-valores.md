---
title: "Conversão Automática entre texto e número em Perl"
timestamp: 2013-03-25T15:36:15
tags:
  - Scalar::Util
  - casting
  - conversão
  - tipo
  - texto
  - número
published: true
original: automatic-value-conversion-or-casting-in-perl
books:
  - beginner
author: szabgab
translator: leprevost
---


Imagine que você está preparando sua lista de compras e escreve o seguinte

```
"2 pães"
```

ao terminar e entregar ao seu colega você de imediato recebe uma reclamação
sobre um erro de conversão.
Apesar de tudo, o "2" neste caso é um texto, e não um número.

Isso seria bastante frustrante, não é?


## Conversão de tipos em Perl

Na maioria das linguagens de programação o tipo do operando define como a operação irá se comportar.
Ou seja, ao `adicionar` dois números ocorre uma operação de adição numérica, enquanto que
<i>adicionar</i> dois textos acaba por concatená-las.
Esta característica chama-se sobrecarga de operador.

O Perl de forma geral trabalha de forma diferente.

Na linguagem Perl o operador é o elemento que define como os operandos serão utilizados.

Isto significa que se você estiver utilizando operadores numéricos (i.e. adição), então
ambos os valores serão automaticamente convertidos em números. Se você estiver utilizando um
operador de texto (i.e. concatenação) então ambos os valores serão automaticamente convertidos
em texto.

Programadores C provavelmente chamariam esta conversão de <i>casting</i> mas esta palavra
normalmente não é utilizada no mundo do Perl. Provavelmente porque a coisa toda acontece
de forma automática.

O Perl não se importa se você escrever algo como um número ou como um texto.
Ele irá realizar a conversão entre ambos de forma automática baseando-se no contexto.

A conversão `número => texto` é fácil.
É apenas uma questão de onde se deve posicionar "" ao redor do valor numérico.

Já a conversão `texto => número` pode fazer você pensar um pouco.
Para o Perl, se o texto se parece como um número, então acaba sendo fácil.
O valor numérico simplesmente é igual, sem as aspas.

Caso haja algum caracter que impessa o perl de realizar a conversão total do texto para número,
então o perl aproveitará o máximo do lado esquerdo do texto para o valor numérico, ignorando o resto.

Deixe-me mostrar alguns exemplos:

```
Original   Como texto   Como número

  42         "42"        42
  0.3        "0.3"       0.3
 "42"        "42"        42
 "0.3"       "0.3"       0.3

 "4z"        "4z"        4        (*)
 "4z3"       "4z3"       4        (*)
 "0.3y9"     "0.3y9"     0.3      (*)
 "xyz"       "xyz"       0        (*)
 ""          ""          0        (*)
 "23\n"      "23\n"      23
```

Em todos os casos onde a conversão de texto para número não é perfeita,
exceto o último, o perl irá soltar um aviso (<i>warning</i>).
Bom, assumindo que você esteja utilizando `use warnings`, como
recomendado.

## Exemplos

Agora que você já viu a tabela vamos ver no código:

```perl
use strict;
use warnings;

my $x = "4T";
my $y = 3;
```

A concatenação converte ambos os valores em texto.

```perl
print $x . $y;    # 4T3
```

A adição numérica converte ambos os valores em número:

```perl
print $x + $y;  # 7
                # Argument "4T" isn't numeric in addition (+) at ...
```

## O argumento não é numérico (Argument isn't numeric)

Este é o aviso que você recebe quando o perl está tentando converter um texto
em um número e a conversão não é perfeita.

Existe ainda uma série de outros avisos e erros comuns em Perl.
Por exemplo [Global symbol requires explicit package name](/simbolo-global-requer-nome-de-pacote-explicito)
e [Use of uninitialized value](/uso-de-valor-nao-inicializado).

## Como evitar os avisos?

É bom que o perl possa lhe avisar (quando é pedido para que o faça) quando a conversão não ocorre de forma perfeita, mas não há
uma função como por exemplo <b>is_number</b> que irá verificar se o texto em questão é na verdade um número?

Sim e não.

Perl não possui uma função <b>is_number</b>, quase como que se os programadores Perl se comprometessem
a saber o que é um número. Infelizmente o resto do mundo não concorda exatamente com esta forma de pensar. Existem
sistemas onde ".2" é aceito como número, já em outros não.
Mais comum ainda quando "2." não é aceito, mas já em outros é totalmente aceito.

Existem ainda lugares em que 0xAB é considerado um número. Um número hexadecimal.

Portanto não há uma função do tipo <b>is_number</b>, mas há sim uma função menos comprometedora chamada
<b>looks_like_number</b>.

Ela faz exatamente o que você está imaginando. Ela irá verificar se um texto se parece com um número para o Perl.

Essa função pode ser utilizada através do módulo [Scalar::Util](http://perldoc.perl.org/Scalar/Util.html),
e você pode utilizá-la da seguinte forma:

```perl
use strict;
use warnings;

use Scalar::Util qw(looks_like_number);

print "Quantos pães eu devo comprar?";
my $paes = <STDIN>;
chomp $paes;

if (looks_like_number($paes)) {
    print "Eu dou conta...\n";
} else {
    print "Sinto muito, eu não entendi\n";
}
```

Não se esqueça do leite também!
