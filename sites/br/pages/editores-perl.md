---
title: "Editores, IDEs e ambientes de desenvolvimento para Perl"
timestamp: 2013-03-17T10:05:23
tags:
  - IDE
  - editor
  - Padre
  - vim
  - emacs
  - Eclipse
  - Komodo
published: true
original: perl-editor
books:
  - beginner
author: szabgab
translator: leprevost
---


Scripts Perl ou programas escritos em Perl não passam de simples arquivos de texto.
Você pode utilizar de qualquer editor de texto para criá-los, entretanto você não deve utilizar processadores de texto, como o MS Word, por exemplo. 
Deixe-me sugerir a você alguns editores e IDEs .

Aliás, este artigo é parto do [Tutorial Perl](/perl-tutorial).


## Editor ou IDE?

Para programar em Perl você pode utilizar tanto um editor de texto quanto um <b>ambiente integrado de desenvolvimento</b>, ou na sigla em inglês; IDE.
Primeiramente irei descrever os editores das plataformas mais comuns que você poderá utilizar, e em seguida as IDEs que são geralmente, independente de plataforma.

## Unix / Linux

Se você está trabalhando com Linux ou Unix, então os editores mais comuns são:
[Vim](http://www.vim.org/) e
[Emacs](http://www.gnu.org/software/emacs/).
Ambos são diferentes em filosofia entre si e comparados aos demais editores existentes.

Se você está familiarizado com um dos dois, eu os recomendo.
Para cada um deles existem extensões especiais ou modos de uso que provêm melhor suporte ao Perl, mas mesmo sem estes adendos são editores muitos eficientes para se programar em Perl.

Se você não está familiarizado com ambos os editores, então eu sugiro que separe a sua curva de aprendizado em Perl da sua curva de aprendizado dos editores de texto.

Ambos os editores são muito poderosos e demandam tempo para serem dominados.

Provavelmente é melhor focar nos seus estudos em Perl no momento,  e em outro momento aprender um pouco mais sobre eles.
Enquanto que ambos são nativos dos sistemas Unix/Linux, ambos <b>Emacs</b> e <b>Vim</b> estão disponíveis para todos os principais sistemas operacionais.

## Editores para Perl em Windows

Em Windows muitas pessoas utilizam os chamados “editores de programação”.

* [Ultra Edit](http://www.ultraedit.com/) é um editor comercial.
* [TextPad](http://www.textpad.com/) é um <i>shareware</i>.
* [Notepad++](http://notepad-plus-plus.org/) é um editor open source e gratuito.

Eu tenho utilizado bastante o <b>Notepad++</b> e eu o mantenho instalado em meu computador Windows por ser bastante útil.

## Mac OSX

Eu não possuo Mac mas de acordo com voto popular, [TextMate](http://macromates.com/) é o editor mais utilizado em Mac para programação em Perl.

## IDEs Perl

Nenhum dos softwares mencionados acima é uma IDE, ou seja, nenhum deles provê alguma forma de depuração em tempo real para Perl. Eles também não oferecem auxílio específico para a linguagem.

[Komodo](http://www.activestate.com/) da  ActiveState custa algumas centenas de dólares. Possui uma versão gratuita com capacidades limitadas.

Pessoas que já utilizem da IDE [Eclipse](http://www.eclipse.org/) talvez já saibam da existência de um plugin para programação em Perl chamado EPIC. Há também um projeto chamado [Perlipse](https://github.com/skorg/perlipse).

## Padre, a IDE Perl

Em Julho de 2008 eu comecei a escrever uma <b>IDE para Perl escrita em Perl</b>. é chamada de Padre - <i>Perl Application Development and Refactoring Environment</i> ou
[Padre, a IDE Perl](http://padre.perlide.org/).

Muitas pessoas uniram-se a mim no projeto. É atualmente distribuída pelas principais distribuições de Linux e pode também ser instalada pelo CPAN, veja em [download](http://padre.perlide.org/download.html) para maiores detalhes.

Em alguns aspectos ainda não é tão poderosa quanto Eclise ou Komodo, mas em outros aspectos específicos ao Perl é atualmente melhor que ambas.
Ainda por cima seu desenvolvimento é bastante ativo. Se você está procurando por um <b>editor para Perl</b> ou uma <b> IDE Perl</b>, eu recomendo que façam o teste.

## A Grande Pesquisa Sobre Editores Para Perl

Em Outubro de 2009 eu iniciei uma pesquisa e perguntei [Quais editores ou IDEs vocês estão utilizando para desenvolvimento em Perl?](http://perlide.org/poll200910/) 
Agora é possível seguir de acordo com a maioria ou então, escolher você mesmo pela sua ferramenta favorita.

## Em Seguida

A próxima parte do tutorial é uma pequena introdução sobre [Perl na linha de comandos](/perl-na-linha-de-comandos).
