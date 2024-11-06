---
title: "A função die."
timestamp: 2014-09-13T23:13:24
tags:
  - die
published: true
original: die
books:
  - beginner
author: szabgab
translator: leprevost
---


Quando você deseja sinalizar que algo deu mais ou menos errado você invoca a função [warn](/warn).

Quando você deseja sinalizar que algo deu muito errado, e quer jogar a toalha, você invoca a função `die`.


As pessoas que lidam com frequência com o Perl estão bem familiarizadas com a função `die`.
Uma das expressões mais comuns é utilizada no estilo `open or die` de se [abrir um arquivo](/abrindo-e-lendo-arquivos).

Uma chamada à função `die` irá imprimir um texto na saída de [erro padrão (STDERR)](https://perlmaven.com/stdout-stderr-and-redirection)
e em seguida terminará o programa sendo executado.

Ela possui as mesmas características que a função [warn](/warn) possui, ou seja se o texto que você passou a ela <b>não</b> terminar
com uma nova linha `/n`, o perl automaticamente inclui o nome do arquivo e o número da linha onde a função `die` foi chamada.

Isso pode ajudar a resolver os problemas identificando a sua origem.

## Lançando Exceções

Enquanto que em um simples script isso normalmente não é necessário, a função `die` na verdade lança exceções.
Em scripts simples você provavelmente não terá um código especialmente escrito para tratar essas exceções.
Nestes casos você simplesmente usa a função `die` ao invés de invocar a função [warn](/warn)
e então [>exit](https://perlmaven.com/how-to-exit-from-perl-script).


Em aplicações maiores, você provavelmente irá querer lançar exceções e em seguida capturá-las usando `eval`. 
Nós iremos lidar sobre isso em um outro artigo.


## Colecionando chamadas

De uma forma um pouco mais avançada, Perl fornece uma forma de se lidar com o sinal de chamada da função `die`,
assim como é feito com a `warn`. A grande diferença é que o gerenciador do sinal que coleta a chamada da função `die`
não impede que o programa seja interrompido. Neste caso é apenas interessante em casos onde você já capturou a exceção
(p.ex. usando a função `eval`) e está interessado em encontrar onde alguém capturou uma exceção,
mas não lidou de forma adequada.
Para estes casos veja o artigo [capturando chamadas](https://perlmaven.com/how-to-capture-and-save-warnings-in-perl).
