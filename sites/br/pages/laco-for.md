---
title: "O Laço For"
timestamp: 2013-05-08T10:47:01
tags:
  - for
  - foreach
  - loop
  - laço
  - infinite loop
  - laço infinito
published: true
original: for-loop-in-perl
books:
  - beginner
author: szabgab
translator: leprevost
---


Nesta parte do [tutorial Perl](/perl-tutorial) nós iremos falar sobre
o <b>laço do tipo <i>for</i> em Perl</b>. Algumas pessoas o chamam de 
<b>laço for no estilo C</b>, mas na verdade essa estrutura está disponível
em diversas linguagens de programação.


## o laço for em Perl

A palavra reservada <b>for</b> pode ser utilizada em Perl de duas formas.
Pode ser usada da mesma forma que um laço <b>foreach</b> e pode também
ser usada como o laço tradicional de três parâmetros. Essa forma é também
conhecida como estilo C, porém existe em outras linguagens.

Eu irei descrever como funciona, apesar de que prefiro escrever o <h>foreach`
descrito na seção sobre [arrays](https://perlmaven.com/perl-arrays).

As duas palavras chave `for` e `foreach` podem ser usadas como 
sinônimos. O Perl irá descrobrir qual você deseja utilizar.

O <b>laço for escrito em estilo C</b> possui três partes na seção de controle.
De forma geral o código se parece da seguinte forma:

```perl
for (INICIALIZAÇÃO; TESTE; PASSO) {
  CORPO;
}
```

Como um exempĺo veja o código abaixo:

```perl
for (my $i=0; $i <= 9; $i++) {
   print "$i\n";
}
```

A parte INICIALIZAÇÃO será executada apenas uma vez quando a execução do código chegar ao laço.

Então, imediatamente após a inicialização o TESTE é executado. Se for falso, todo o laço é evitado.
Se o teste for verdadeiro então o CORPO é executado seguido pelo PASSO.

(Para o significado real de VERDADEIRO ou FALSO, veja [valores booleanos em Perl](/valores-booleanos-em-perl).)

Então novamente o TESTE é avaliado e o ciclo continua enquanto o valor do TESTE retornar verdadeiro.
Se parece da seguinte forma:

```
INICIALIZAÇÃO

TESTE
CORPO
PASSO

TESTE
CORPO
PASSO

...

TESTE
```


## foreach

O laço acima - indo de 0 a 9 pode também ser escrito em um <b>laço foreach</b>
e achoi até que a ideia fica mais clara:

```perl
foreach my $i (0..9) {
  print "$i\n";
}
```

Como eu havia escrito antes ambas formas são sinÔnimas então algumas pessoas
usam a palavra `for` mas escrevem um <b>laço foreach</b> dessa forma:

```perl
for my $i (0..9) {
  print "$i\n";
}
```

## As partes de um laço for em Perl

A INICIALIZAÇÃO serve, é claro, apra inicializar variáveis.

O TESTE é uma forma de expressão booleana que testa se o laço deverá continuar ou não.
è executada pelo menos uma vez. O TESTE é executado uma vez a mais do que o CORPO e o PASSO.

O CORPO é um conjunto de declarações, normalmente é algo que nós desejamos que seja executado
repetidamente, apesar de que as vezes um CORPO vazio pode fazer sentido também.

O PASSO é outro conjunto de ações que normalmente é utilizada para aumentar ou diminuir o valor
de um índice. Essa parte também pode ser deixada em branco se por exemplo, nós fazemos essa
mudança dentro do CORPO.

## Laços infinitos

Você pode escrever um laço infinito utilizando o <b>laço for</b>:

```perl
for (;;) {
  # faça algo
}
```

As pessoas normalmente escrevem com o `while` dessa forma:

```perl
while (1) {
  # faça algo
}
```

Também é descrito na parte sobre [laços while em Perl](/laco-while).

## perldoc

Você pode encontrar a descrição oficial do laço for na seção <b>perlsyn</b> da
[documentação do Perl](http://perldoc.perl.org/perlsyn.html#For-Loops).
