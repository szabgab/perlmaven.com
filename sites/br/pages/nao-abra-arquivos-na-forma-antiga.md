---
title: "Não Abra Arquivos na Forma Antiga"
timestamp: 2013-05-02T00:45:17
tags:
  - open
published: true
original: open-files-in-the-old-way
books:
  - beginner
author: szabgab
translator: leprevost
---


Previamente no [Tutorial Perl](/perl-tutorial)
nós vimos como abrir arquivos para leitura e escrita.
Infelizmente, quando você busca pela web, ou entçao olha códigos antigos
você irá se deparar com uma sintaxe um tanto diferente.

Vamos ver o que é, qual é o problema e como evitá-la?.


## Então, o que devo fazer?

Antes de explicar o que você não deve fazer, deixe-me fornecer a você <i>links</i> para artigos explicando
o que você deve fazer:

Leia [como abrir arquivos para leitura no estilo moderno](https://perlmaven.com/open-and-read-from-files)
ou o artigo sobre [escrever em arquivos utilziando o Perl](https://perlmaven.com/writing-to-files-with-perl).

Agora vamos retornar ao antigo, e não tão bom assim, modo de programar.

## A forma antiga e não recomendada

Até o lançamento do perl 5.6 - isto é, meados de 2000 - nos costumávamos escrever código como este
para abrir um arquivo para escrita:

```perl
open OUT, ">$filename" or die ...;
```

e código como este para leitura:

```perl
open IN, $filename or die ...;
```

A parte "or die" é a mesma que utilizamos hoje em dia.

Como você pode ver a função `open` recebe dois parâmetros. O primeiro é um conjunto de letras, 
geralmente em caixa alta. Esta é a estrutura que receberá o <i>filehandle</i>. O segundo parâmetro
é um combinado do modo de abertura com o caminho do arquivo que deve ser aberto.

Ou seja, no primeiro caso você vê o sinal 'maior do que' significando que nós estamos abrindo o arquivo
para escrita, mas no segundo exemplo nós omitimos o modo de abertura. Isso funciona porquê a função
`open()` funciona em modo de leitura por padrão.

Existem duas grandes diferenças:

## Filehandle glob

A primeira diferença está no uso da estranha variável sem o sinal de `$` na frente
para receber o <i>filehandle</i>.
(Isto na verdade é uma <b>palavra solta (bareword)</b>, mas uma que não dispara o erro
[Bareword not allowed while "strict subs" in use](https://perlmaven.com/barewords-in-perl)).

Funciona da mesma forma que antigamente nos primórdios do Perl, mas há vários problemas:

É global a todo o seu script, então se alguma outra pessoa utilizar o mesmo nome (IN, ENTRADA, OUT, SAIDA, por exemplo)
irá ocorrer colisão com as suas variáveis.

É também um tanto difícil passar essas variáveis às suas funções.

## Abertura com 2 parâmetros

A segunda diferença é o fato de que nesses exemplos a função `open` apenas possui dois parâmetros.

E se a variável `$filename`, que você está usando para abrir o arquivo para leitura, contém >/etc/passwd ?

Ops.

O `open IN, $filename` irá na verdade abrir o arquivo para escrita.

Você acaba de deletar o arquivo de senhas do seu sistema Linux.

Nada Bom.

## É necessário fechar o filehandle

Outra vantagem de usar <b>variáveis definidas dentro de um escopo</b> como <i>filehandles</i>
é que elas irão fechar automaticamente quando saírem de escopo.

## Como evitar estes problemas?

A melhor saída é evitar ambas práticas utilizando o comando "new", (disponível desde 2000 !)
<a href="/open-and-read-from-files">utilizando a função open com 3 parâmetros através de variável escalar
definida dentro de um escopo</a> para armazenar o <i>filehandle</i>.

Existem ainda políticas no [Perl::Critic](http://www.perlcritic.com/)
que irão ajudá-lo a analizar o seu código e localizar todos os locais onde foram utilizadas
as formas descritas acima.

## O Bom e o Ruim para leitura

Ruim:

```perl
open IN, $filename or die ...;
```

Bom:

```perl
open my $in, '<', $filename or die ...;
```

## O Bom e o Ruim para escrita

Ruim:

```perl
open IN, ">$filename" or die ...;
```

Bom:

```perl
open my $in, '>', $filename or die ...;
```
