---
title: "Acrescentando texto em arquivos (appending)"
timestamp: 2013-04-23T22:30:01
tags:
  - files
  - append
  - acrescentar
  - open
  - >>
published: true
original: appending-to-files
books:
  - beginner
author: szabgab
translator: leprevost
---


Neste capítulodo [tutorial Perl](/perl-tutorial) nós iremos ver <b>como acrescentar informação em arquivos existentes utilizando Perl</b>.

No episódio anterior nós aprendemos [como escrever em arquivos](/escrevendo-em-arquivos-com-perl).
Isso é muito útil quando estamos criando um arquivo, mas há casos onde nós desejamos manter o arquivo original, 
e apenas adicionar novas linhas a ele.

O caso mais comum é quando estamos escrevendo um arquivo de histórico, ou <i>log</i>.


Ao escrever

```perl
open(my $fh, '>', 'report.txt') or die ...
```

Abrimos um arquivo para ecrita utilizando o sinal `>`, que irá automaticamente deletar o conteúdo do arquivo, caso haja algum.

Se nós desejamos <b>acrescentar</b> algo ao final do arquivo nós devemos utilizar o sinal <b> maior do que</b> `>>`, como no exemplo abaixo:

```perl
open(my $fh, '>>', 'report.txt') or die ...
```

Ao invocar essa função, iremos abrir o arquivo para acrescentar informações nele, isso significa que o arquivo irá permanecer intacto
e qualquer coisa que for impresso pelas funções `print()` e `say()` serão acrescentadas ao final.

Veja abaixo um exemplo completo:

```perl
use strict;
use warnings;
use 5.010;

my $filename = 'report.txt';
open(my $fh, '>>', $arquivo) or die "Não foi possível abrir o arquivo '$arquivo' $!";
say $fh "Meu primeiro relatório escrito em perl";
close $fh;
say 'pronto';
```

Se você executar esse script várias vezes, você verá que o arquivo irá crescer.
Para cada vez que for executado, será acrescentado uma nova linha ao arquivo.
