---
title: "Baixe e Instale o Perl"
timestamp: 2013-01-29T23:00:00
tags:
  - download
  - install
  - Windows
  - Linux
  - UNIX
  - Mac OSX
  - DWIM Perl
  - ActivePerl
  - Citrus Perl
published: true
original: download-and-install-perl
books:
  - beginner
author: szabgab
translator: aramisf
---


Nesta seção do [Tutorial Perl](/perl-tutorial) nós veremos de onde
<b>baixar o Perl</b> e como instala-lo.

O Perl é mantido e distribuído por um time dedicado de voluntários que se
autodenominam <b>Portadores do Perl 5</b>. Uma vez por ano eles liberam uma
versão do Perl com alterações nos módulos (<i>major version</i>), e algumas
outras vezes ao ano eles liberam pequenas correções (geralmente correções de
<i>bugs</i>, são as <i>minor versions</i>).


Quando o artigo original desta tradução foi escrito (29/01/2013), a última
<i>major version</i> era 5.16 (liberada em Maio de 2012) com 5.16.2 (Novembro
2012) sendo a <i>minor release</i> mais recente.
O [README no CPAN](http://www.cpan.org/src/README.html) sempre
contém a informação mais atualizada.

Você provavelmente sempre verá um versionamento maior que a versão estável
mais recente - 5.17.7 (quando este artigo foi escrito).
Esta é uma previsão mensal da árvore de desenvolvimento. É apenas para pessoas
que acompanham de perto o desenvolvimento do Perl.
Não é indicado para humanos comuns e definitivamente não indicado para uso em
produção!

## Portadores do Perl 5 Porters distribuidores a jusantes

O que os Portadores do Perl 5 liberam é o código fonte do Perl.
Esse código é utilizado por vários <b>distribuidores</b> ou <b>fabricantes</b>
(também conhecidos como distribuidores a jusantes) e é reempacotado em um
formato binário já compilado.
A maioria de nós usa o Perl de tais <b>distribuidores a jusantes</b>.

Geralmente dentro de poucos meses de qualquer versão liberada, os diversos
distribuidores a jusantes incluem a última revisão do Perl, mas isso não chega
necessariamente aos usuários finais.

Se você usa Linux você obtém a nova versão somente se você atualiza o seu
sistema. Isso pode acontecer frequentemente em uma máquina doméstica, mas
ocorre com menor frequência em corporações e servidores. Eles tendem a
atualizar somente depois de um intervalo de 2 a 5 anos. Em alguns casos, o
intervalo pode ser ainda maior.

Isso significa que o tão chamado <b>sistema Perl</b> em distribuições Linux
estará desatualizado alguns anos.

## Microsoft Windows

Existe um número de distribuições Perl no Windows.

Atualmente eu recomendo a distribuição <a
href="http://dwimperl.szabgab.com/windows.html">DWIM Perl para Windows</a>.  É uma
derivada da muito bem sucedida distribuição <a
href="http://strawberryperl.com/">Strawberry Perl</a> com centenas de módulos
extra do Perl, provenientes do CPAN. (Nota de esclarecimento: Eu sou o
mantenedor do DWIN Perl).

Apesar de vim com o Padre, <a href="http://padre.perlide.org/">a IDE do
Perl</a>, ela também inclui o <a href="http://moose.perl.org/">Moose, o
framework de programação Perl orientado a objetos pós moderno</a>.

Sozinha, ela permite <a href="http://perldancer.org/">desenvolvimento web com
o framework Perl Dancer</a>.
Existe uma postagem sobre <a
href="https://perlmaven.com/getting-started-with-perl-dancer">começando a usar o Perl
Dancer</a> (em inglês).

Ela também inclui módulos para ler e escrever arquivos do Microsoft Excel e
vem com muito mais extensões.

No primeiro episódio do [Tutorial Perl](/perl-tutorial) eu
expliquei, e mostrei no screencast, <a href="/instalando-o-perl">como instalar
Perl no Windows</a>.

Outra distribuição Perl para Windows é a <a
href="http://www.activestate.com/activeperl">ActivePerl</a>. Ela foi criada
pela [ActiveState](http://www.activestate.com/). É recomendada caso
você esteja planejando comprar um suporte ou uma licença de redistribuição.

Uma terceira distribuição é a <a href="http://www.citrusperl.com/">Citrus
Perl</a>. É especialmente interessante se você planeja desenvolver uma
aplicação desktop multiplataforma para Windows, Linux e Mac OSX. Ela incluiu
um wrapper do [wxWidgets](http://www.wxwidgets.org/) para as 3
plataformas.

Atualizar uma dessas distribuições Perl geralmente envolve a remoção das
antigas e a instalação da nova. E então a instalação dos módulos adicionais.

## Linux

Toda distribuição Linux moderna vem com o Perl instalado. Em alguns casos, não
é o pacote completo que foi disponibilizado pelos Portadores do Perl 5, e na
maioria dos casos, não é nem a versão mais recente.

Estar um pouco desatualizado não seria um problema, mas em alguns casos você
ficará estancado com uma versão do Perl de 5 a 7 anos atrás. Você encontra
tais casos especialmente em distribuições Linux com política de suporte
prolongado. Por exemplo, o Ubuntu LTS. Claro, todo software nessas
distribuições é bastante antigo, não somente o Perl.
Estabilidade tem um preço!

Um dos contras de se ter uma versão antiga do Perl, é que podem existir
módulos CPAN que não oferecem suporte à esta versão.

Para se começar a usar o Perl, a versão que vem com o sistema operacional é
suficiente, mas em algum ponto você poderá querer instalar a versão mais nova.
Iremos mais a fundo neste tema em outro artigo, mas por hora é suficiente
dizer que isso ficou muito fácil recentemente, graças ao desenvolvimento do <a
href="http://www.perlbrew.pl/">Perlbrew</a>.

Em algumas distribuições Linux nem todos os pacotes "básicos" do Perl estão
inclusos por padrão. Por exemplo muitas distribuições deixam de lado a
documentação. Você pode ler pelo <a href="http://perldoc.perl.org/">site do
perldoc</a>, ou pode instalar manualmente com o sistema de gestão de pacotes
do seu sistema operacional.

Por exemplo, no Debian ou Ubuntu você pode instalar a documentação do Perl
usando:

```
sudo aptitude install perl-doc
```

## Mac OSX

Não tenho experiência com o Mac OSX, mas até onde sei, a situação é similar ao
que acontece no Linux.

## UNIX

No lado UNIX a situação não é lá muito boa. Algumas das principais
distribuições UNIX ainda fornecem o Perl da linha 5.005 que é baseada em uma
versão distribuiída em 1995. Se possível, baixe e instale uma versão recente
do Perl e use-a para qualquer desenvolvimento novo.

## Baixe, compile e instale o Perl

Você pode baixar o código fonte do Perl do <a
href="http://www.cpan.org/src/README.html">CPAN</a> e então seguir as
instruções naquela página:

```
wget http://www.cpan.org/src/5.0/perl-5.16.2.tar.gz
tar -xzf perl-5.16.2.tar.gz
cd perl-5.16.2
./Configure -des -Dprefix=$HOME/localperl
make
make test
make install
```

Uma vez feito isso você pode verificar sua nova versão do Perl digitando

```
$HOME/localperl/bin/perl -v
```

para tornar este o Perl padrão, você provavelmente queira adicionar ao seu
.bashrc

```
export PATH=$HOME/localperl/bin/:$PATH
```

## Instruções do site Learn Perl

O site learn Perl também tem suas
<a href="http://learn.perl.org/installing/">abordagens recomendadas para
instalar o Perl</a>.
Veja ela também.
