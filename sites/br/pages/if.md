---
title: "Declarações Condicionais: if"
timestamp: 2014-10-04T08:30:00
tags:
  - if
  - else
  - elsif
  - indentation
  - else if
published: true
original: if
books:
  - beginner
author: szabgab
translator: leprevost
---


Até o momento, no [tutorial](/perl-tutorial) cada declaração foi feita de forma consecutiva, uma após a outra. Mas existem casos onde você deseja executar determinadas declarações somente se uma condição é atendida, ou seja, se a condição é avaliada como “verdade”.

O condicional `if` é utilizado para esta tarefa.


A estrutura básica do `condicional if` é: 

```perl
if (CONDIÇÃO) {
   DECLARAÇÃO;
   ...
   DECLARAÇÃO;
}
```

Por exemplo

```perl
use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age >= 18) {
    print "In most countries you can vote.\n";
}
```

Ambos parênteses ao redor da <b>condição</b> e as chaves `{}` são necessárias. 
(Uma nota especial para aqueles com experiência em programação em C: Mesmo que haja apenas uma declaração, esta ainda necessita ser envolta pelo par de chaves). 

A condição em si pode ser qualquer tipo de expressão Perl. Se for avaliada como [verdadeira](/valores-booleanos-em-perl), então as declarações dentro dos parênteses serão executadas. Se for avaliada como [falsa](/valores-booleanos-em-perl), serão então ignoradas. (Para saber o que significa uma condição verdadeira ou falsa, dê uma olhada no artigo sobre o assunto [valores booleanos](/valores-booleanos-em-perl).)

## Layout: Indentação

Como em Perl espaços vazios não possuem significado nós poderíamos ter ajustado o estilo do código de diferentes maneiras, sem causar impacto algum na sua execução, mas deixe-me demonstrar o porque este tipo de layout é recomendado. A parte mais importante aqui é certificar-se de que o código dentro das chaves não esteja no início da linha. Ele começa a ser escrito alguns caracteres à direita. Isto é chamado de <b>indentação</b>. Durante o tutorial iremos ver uma série de declarações que possuem blocos interno (um par de chaves), e em cada um deles nós iremos indentar o código à direita Esta indentação torna mais fácil para o leitor para ver qual parte do código está dentro do bloco e qual parte está do lado de fora. Existem linguagens, como Python, que forçam você a realizar tal indentação. Perl é muito mais flexível neste tópico, mas ainda é extremamente recomendado que sempre realize a indentação do seu código.

As pessoas adoram debater sobre o uso do caractere `tab` ou do caractere `espaço` para a indentação. Eu não acho que isso seja crítico. O importante é que o seu código esteja indentado de forma consistente.

Nestes exemplos eu utilizei 4 espaços, mas quando eu escrevo aplicações eu geralmente utilizo `TAB`. Quando eu tenho que editar código escrito por outras pessoas eu sempre tento manter o mesmo estilo que foi utilizado, isso se existe um.

## if - else

Existem casos onde nós desejamos realizar algo se uma condição é atendida (quando ela é verdadeira), e algo diferente se ela for falsa.
Para isso nós utilizamos a extensão `else` da condicional `if`:

```perl
use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age >= 18) {
    print "In most countries you can vote.\n";
} else {
    print "You are too young to vote\n";
}
```

Neste código, se a condição for verdadeira e `$age` for maior ou igual a 18, então o bloco `ih` é executado. Se a condição for falsa então o bloco `else` é executado.

Como podemos ver no primeiro exemplo, a parte `else` é opcional, mas se nós adicionarmos a palavra `else` nós também temos que adicionar as chaves.


## Declarações aninhadas

```perl
use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age >= 18) {
    print "In most countries you can vote.\n";
    if ($age >= 23) {
        print "You can drink alcohol in the USA\n";
    }
} else {
    print "You are too young to vote\n";
    if ($age > 6) {
        print "You must go to school...\n";
    }
}
```

Perl permite que declarações `if` sejam adicionadas, tanto no bloco `if` quanto `else`.

Note que o código dentro dos blocos internos está mais indentado à direita, possuindo 4 espaços a mais.

## elsif

Em outro exemplo nós podemos ver como podemos facilmente obter vários níveis de indentação:

```perl
use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age < 6) {
    print "You are before school\n";
} else {
    if ($age < 18) {
        print "You must go to school\n";
    } else {
        if ($age < 23) {
            print "In most countries you can vote.\n";
        } else {
            print "You can drink alcohol in the USA\n";
        }
    }
}
```

Este código funciona, mas possui dois problemas:

O primeiro é que a largura da tela possui limites. Se você indentar demais então ou suas linhas se tornarão larga demais e não caberão na tela ou você terá que embrulhar o código. Ambos tornam o código um pouco mais difícil de ser lido.

O segundo problema é que a maioria dos programadores tende a focar no que está do lado esquerdo da tela, dando pouca atenção àquilo que está do lado direito. Então ao indentar o seu código você envia a mensagem de que condicionais indentadas são menos importante.
Se está é a sua intenção então vá em frente e escreva o código desta maneira, por outro lado, se a razão de escrever condicionais aninhadas é simplesmente por ser a forma mais fácil de ser avaliada, então é melhor utilizar o condicional `elsif` e achatar a sua construção.

```perl
use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age < 6) {
    print "You are before school\n";
} elsif ($age < 18) {
    print "You must go to school\n";
} elsif ($age < 23) {
    print "In most countries you can vote.\n";
} else {
    print "You can drink alcohol in the USA\n";
}
```

Este código faz exatamente o que o código anterior faz, mas desta vez ao invés de blocos aninhados, nós utilizamos `elsif`, o que significa que não precisamos de um nível extra de indentação.
Isto também acaba passando a ideia de que os 4 casos possuem a mesma importância.

Quando você programa, lembre-se, o computador irá entender você de qualquer jeito, mas faça de forma que outras pessoas também possam entender suas intenções. Quem sabe, essa outra pessoa pode ser até mesmo você...

## else if em Perl

Perceba também que a sintaxe da construção “else if” possui muita diversidade entre as linguagens de programação. Em Perl ela é escrita como uma palavra única, tendo apenas um único ‘e’: ` elsif`.

## Blocos vazios

Apesar de normalmente não serem necessários, em Perl você também escrever blocos vazios:

```perl
use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age < 0) {
}
```

As vezes nós escrevemos assim quando estamos escrevendo um bloco pela primeira vez, organizando o seu esqueleto, para então apenas depois adicionar o código de dentro.

Nós podemos adicionar comentários internos.

```perl
use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age < 0) {
    # TODO
}
```

Na verdade há ainda um tipo especial de código que foi adicionado na versão 5.10 do perl:

```perl
use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age < 0) {
    ...
}
```

Os três pontos são chamados de `operador yada, yada`. É o que as pessoas escreveriam quando estão escrevendo bastante texto e querem deixar espaço para mais. Alguns escrevem ‘etc’ ou ‘bla bla bla’.

Desde de que a versão 5.10 foi lançada, essa construção se tornou válida em Perl. Ela irá lançar uma exceção do tipo `Unimplemented` (Não implementado), se executada.
Pode ser bastante útil, mas provavelmente um tanto prematura aprender este operador agora pelo [Tutorial Perl](/perl-tutorial).


