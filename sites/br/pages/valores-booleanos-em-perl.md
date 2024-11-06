---
title: "Valores Booleanos em Perl"
timestamp: 2013-03-29T21:56:27
tags:
  - undef
  - true
  - verdadeiro
  - false
  - falso
  - booleano
published: true
original: boolean-values-in-perl
books:
  - beginner
author: szabgab
translator: leprevost
---


O Perl ainda não possui um tipo especial booleano,
na documentação do Perl você pode ocasionalmente observar que uma função retorna valor "booleano".
As vezes a documentação a documentação diz que a função retorna valor verdadeiro ou falso.
Então, qual deles é verdade?


O Perl não possui um tipo específico para valores booleanos, entretanto todo valor escalar - se verificado
utilizando <b>if</b> irá retornar verdadeiro ou falso. Então, dessa forma você pode escrever:

```perl
if ($x eq "foo") {
}
```

e você também pode escrever

```perl
if ($x) {
}
```

No primeiro caso será avaliado se o conteúdo da variável <b>$x</b> é o mesmo que
o texto "foo", enquanto que no segundo caso será avaliado se a própria variável $x
é verdadeira ou falsa.

## Quais valores são verdadeiros ou falsos em Perl?

É uma questão bem simples. Permita-me citar a documentação:

<pre>
O número 0, os textos '0' e '', a lista vazia "()" e o "undef" são todos considerados falsos
em contexto booleano. Todos os demais casos são considerados verdadeiros.
A negação de um valor verdadeiro por "!" ou "not" retornará um tipo especial de valor falso.
Quando avaliado como texto, será tratado como '', e quando avaliado como número serpa tratado como 0.

Retirado do perlsyn, da seção "Truth and Falsehood".
</pre>

Então os seguintes valores escalares são considerados falsos:

* undef - o valor não definido.
* 0  o número 0, mesmo quando escrito como 000 ou 0.0.
* ''   o texto vazio.
* '0'  o texto que contém um único dígito 0.

Todas os demais valores escalares são verdadeiros, incluindo o seguintes:

* 1 qualquer número diferente de 0.
* ' '   o texto contendo apenas um espaço.
* '00'   dois ou mais caracteres em um texto.
* "0\n"  um 0 seguido de um caracter de nova linha.
* 'verdade'
* 'falso'   sim, até mesmo o texto 'falso' é avaliado como verdadeiro.

Eu acredito que as coisas funcionam dessa forma porque o [Larry Wall](http://www.wall.org/~larry/),
criador do Perl possui de forma geral uma visão positiva do mundo.
Ele provavelmente acredita que existem poucas coisas ruins e falsas no mundo.
A maioria das coisas é verdadeira.


