---
title: "Perl na linha de comandos"
timestamp: 2013-03-23T19:46:15
tags:
  - comando
  - one-liner
  - -v
  - -e
  - -p
  - -i
published: true
original: perl-on-the-command-line
books:
  - beginner
author: szabgab
translator: leprevost
---


Enquanto a maior parte dos [Tutoriais Perl](/perl-tutorial) lidam
com scripts salvos em um arquivo, nós também veremos alguns exemplos
de <b>one-liners</b>.

Mesmo que você esteja utilizando o [Padre](http://padre.perlide.org/)
ou alguma outra IDE que lhe permita executar seus scripts a partir do editor,
é muito importante se familiarizar com a linha de comandos (ou o <b>shell</b>)
e ser capaz de utilizar o perl.


Se você está utilizando o Linux, abra uma janela do terminal. Você deverá ver
o <b>prompt</b> provavelmente terminando com um sinal $.

Se você está utilizando Windows abra a janela de comandos: Clique em

Início -> Executar -> escreva "cmd" (sem as aspas) -> ENTER

Você verá a janela preta do CMD com o <b>prompt</b> que se parece dessa forma: 

<pre>
c:\>
</pre>

## Verificando a versão do Perl

Abra o terminal e digite `perl -v`. Verá algo parecido com isso impresso:

```
C: \> perl -v

This is perl 5, version 12, subversion 3 (v5.12.3) built for MSWin32-x86-multi-thread

Copyright 1987-2010, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

Com base nisso, eu posso ver que eu tenho a versão 5.12.3 do Perl instalada no meu Windows.

## Imprimindo um número

Agora digite `perl -e "print 42"`.
Isto irá imprimir o número <b>42</b> na tela. No Windows, o <b>prompt</b> irá aparecer direto na próxima linha

```
c:>perl -e "print 42"
42
c:>
```

No Linux você vai ver algo parecido com isto:

```
gabor@pm:~$ perl -e "print 42"
42gabor@pm:~$
```

O resultado está no início da linha, imediatamente seguido do <b>prompt</b>.
Esta diferença baseia-se no comportamento dos dois interpretadores na linha de comandos.

Neste exemplo, vamos usar o flag `-e` que diz ao perl,
"Não espere um arquivo. A próxima coisa na linha de comando é na verdade um código Perl."

Os exemplos acima são, naturalmente, não muito interessantes. Deixe-me mostrar um exemplo um pouco mais complexo.
exemplo, sem explicá-lo:

## Substituindo Java por Perl

Este comando: `perl -i.bak -p -e "s/\bJava\b/Perl/" resume.txt`
irá substituir todas as ocorrências da palavra <b>Java</b> pela palavra <b>Perl</b> em seu
currículo, mantendo um backup do arquivo.

No Linux você pode até escrever `perl -i.bak -p -e "s/\bJava\b/Perl/" *.txt`
para substituir Java por Perl em <b>todos</b> os seus arquivos de texto.

Em uma seção mais tarde nós vamos falar mais sobre os <i>one-liners</i> e você irá aprender como usá-los.
O conhecimento sobre os <i>one-liners</i> é uma arma muito poderosa em suas mãos.

Aliás se você está interessado em outros exemplos muito bons de <i>one-liners</i>, eu recomendo a leitura <a href="http://www.catonmat.net/blog/perl-book/">Perl One-Liners explained</ a>
por Peteris Krumins.

## Em seguida

A próxima parte será sobre
[Documentação do núcleo do Perl e documentação de módulos do CPAN](/documentacao-do-perl-e-modulos-cpan).

