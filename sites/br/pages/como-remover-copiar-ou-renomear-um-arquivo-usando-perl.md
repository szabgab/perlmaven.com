---
title: "Como remover, copiar ou renomear um arquivo usando Perl"
timestamp: 2013-05-30T15:47:00
tags:
  - unlink
  - remove
  - rm
  - del
  - delete
  - copy
  - cp
  - rename
  - move
  - mv
  - File::Copy
published: true
original: how-to-remove-copy-or-rename-a-file-with-perl
books:
  - beginner
author: szabgab
translator: aramisf
---


Muitas pessoas que vem do mundo da <b>administração de sistemas</b> e da
confecção de scripts Unix ou Linux, tentarão continuar usando os comandos unix
básicos tais como <b>rm</b>, <b>cp</b> e <b>mv</b> para tais operações,
executando-os com a crase ou com a chamada <b>system</b>, mesmo que estejam
escrevendo script em Perl.

Isso funciona em sua plataforma corrente, mas também abre mão de um dos
benefícios cruciais que o Perl trouxe para o mundo da administração de
sistemas Unix.

Vejamos como podemos executar essas operações usando o Perl de uma maneira que
seja independente de plataforma e sem <b>recorrer ao shell</b>.


## Remover

O nome da respectiva função em Perl é `unlink`.

Ela remove um ou mais arquivos do sistema de arquivos.
É similar ao comando `rm` no Unix ou ao <b>del</b> no Windows.

```perl
unlink $file;
unlink @files;
```

Esta função usa `$_`, a <a
href="https://perlmaven.com/the-default-variable-of-perl">variável padrão do Perl</a> (em inglês) se nenhum
parâmetro é fornecido.

Para ver a documentação completa acesse <a
href="http://perldoc.perl.org/functions/unlink.html">perldoc -f unlink</a>.

## rename

Renomea ou move um arquivo. É semelhante ao comando `mv` no Unix e ao
`rename` no DOS/Windos.

```perl
rename $old_name, $new_name;
```

Como isto nem sempre funciona em todos os sistemas de arquivos, a alternativa
recomendada é a função `move` do módulo `File::Copy`:

```perl
use File::Copy qw(move);

move $old_name, $new_name;
```

Documentação (em inglês):

[perldoc -f rename](http://perldoc.perl.org/functions/rename.html).

[perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).

## Copiar

Não existe uma função do Perl para copiar. A maneira padrão de copiar um
arquivo é através da função `copy` do módulo File::Copy.

```perl
use File::Copy qw(copy);

copy $old_file, $new_file;
```

Ele é semelhante ao comando `cp` no Unix e ao comando `copy` no
Windows.

Para ver a documentação visite [perldoc File::Copy](http://perldoc.perl.org/File/Copy.html).


