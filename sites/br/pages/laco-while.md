---
title: "O laço while"
timestamp: 2013-04-17T12:45:51
tags:
  - while
  - while (1)
  - loop
  - laço
  - infinite loop
  - laço infinito
  - last
published: true
original: while-loop
books:
  - beginner
author: szabgab
translator: leprevost
---


Neste capitulo do [tutorial Perl](/perl-tutorial) nós iremos ver <b>como os laços do tipo while funcionam em Perl</b>.


```perl
use strict;
use warnings;
use 5.010;

my $contador = 10;

while ($contador > 0) {
  say $contador;
  $contador -= 2;
}
say 'pronto';
```

O laço `while` possui uma condição, exemplificada no caso acima avaliando se a variável $contador é maior do que 0,
seguido de um bloco de código envolto por chaves.

Quando a execução do código acima atinge o ponto inicial do laço while, ocorre então a verificação da condição onde a mesma é testada
retornando um valor [verdadeiro ou falso](/valores-booleanos-em-perl). Caso seja `FALSA` o bloco é ignorado e a próxima
declaração do código é realizada, imprimindo 'pronto' na tela.

Se a condição do laço `while` for `VERDADEIRA` então o bloco é executado. Após isso a execução retorna ao ponto de
teste e a condição é testada novamente. Caso dessa vez seja falsa, o bloco é ignorado e o texto 'pronto'
é impresso na tela. Se for verdadeira o bloco é executado novamente, e em seguida retornando ao ponto de teste...

Esse processo se repete enquanto a condicional testada retornar valor verdadeiro, ou seja:

`while` (condição-for-verdadeira) { faça algo }`

## Laços infinitos

No código exemplo acima nós sempre reduzimos o valor da variável, dessa forma garantimos que em algum momento a condicional seria falsa.
Se por algum motivo a condicional nunca se tornar falsa você terá um `laço infinito`. O seu programa ficará preso
em um pequeno bloco de execução e nunca conseguirá escapá-lo.

Isso aconteceria se nós por exempĺo, estivéssemos esquecido de reduzir o valor da variável `$contador`, ou se nós estivéssemos aumentando o seu valor.

Se nesse caso fosse um acidente, então nós teríamos um <i>bug</i>.

Por outro lado, em alguns casos o uso <b>proposital</b> de laços infinitos pode deixar o seu programa mais simples de escrever e fácil de ser lido.
E nós adoramos código fácil de ser lido!
Se nós fossemos utilizar um laço infinito, poderíamos utilizar uma condição que sempre seja verdadeira.

Então podemos escrever:

```perl
while (42) {
  # faça algo aqui
}
```

É claro que pessoas que não possuam as [referências culturais adequadas](http://en.wikipedia.org/wiki/Answer_to_Life,_the_Universe,_and_Everything#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29)
irão se perguntar o porque de usar 42, então podemos utilizar o sempre entediante número 1 em laços infinitos.

```perl
while (1) {
  # faça algo aqui
}
```

Naturalmente, observando que a execução do código não possui escapatória do laço, você se perguntaria como pode então o programa encerrar a sua execução,
talvez sendo interrompido externamente?

Para isso, existem diferentes resoluções:

Uma das soluções é utilizar a declaração `last` dentro do laço.
Dessa forma, a execução irá ignorar o resto do bloco e não irá realizar mais as avaliações da condicional.
Efetivamente terminando a execução do laço. As pessoas normalmente utilizam essa declaração dentro de alguma condicional.

<ode lang="perl">
use strict;
use warnings;
use 5.010;

while (1) {
  print "Qual linguagem de programação você está aprendendo agora? ";
  my $nome = <STDIN>;
  chomp $nome;
  if ($nome eq 'Perl') {
    last;
  }
  say 'Errado! Tente novamente!';
}
say 'pronto';
```

Neste exemplo nós fazemos uma pergunta ao usuário e esperamos que seja capaz de responder com a resposta correta.
Caso não responda 'Perl', ficará preso no laço eternamente.

Então a conversa poderá seguir da seguinte forma:

```
Qual linguagem de programação você está aprendendo agora?
>  Java
Errado! Tente novamente!
Qual linguagem de programação você está aprendendo agora?
>  PHP
Errado! Tente novamente!
Qual linguagem de programação você está aprendendo agora?
>  Perl
pronto
```

Como pode observar, uma vez o usuário digitando a resposta correta, a declaração `last` é invocada e o resto do bloco
iincluindo `say 'Errado! Tente novamente!';` é ignorado e a execução segue adiante após o `laço while`.

