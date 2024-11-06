---
title: "Documentação em Perl com POD - Plain Old Documentation"
timestamp: 2013-04-05T10:50:59
tags:
  - POD
  - perldoc
  - =head1
  - =cut
  - =pod
  - =head2
  - documentation
  - documentação
  - pod2html
  - pod2pdf
published: true
original: pod-plain-old-documentation-of-perl
books:
  - beginner
author: szabgab
translator: leprevost
---


Programadores de forma geral não gostam muito de escrever a documentação de seus projetos. Parte da razão é que os programas
são basicamente arquivos de texto simples, mas em muitos casos os desenvolvedores são obrigados a escrever a
documentação em algum processador de texto.

Isso requer a aprendizagem do processador de texto assim como o investimento de muita energia em tentar fazer o documento
ter "boa aparência" em vez de "ter bom conteúdo".

Este não é o caso com Perl. Normalmente você escreveria a documentação de seus módulos direito no código fonte e confiaria
em alguma ferramenta externa para formatá-lo a fim de deixá-lo com boa aparência.


Neste episódio do [Tutorial Perl](/perl-tutorial) vamos conhecer o POD <i>Plain Old Documentation</i>,
que é a linguagem de marcação usada pelos desenvolvedores perl.

Veja abaixo como um simples pedaço de código perl aparenta ser com a documentação POD:

```perl
#!/usr/bin/perl
use strict;
use warnings;

=pod

=head1 DESCRIPTION

This script can have 2 parameters. The name or address of a machine
and a command. It will execute the command on the given machine and
print the output to the screen.

=cut

print "Here comes the code ... \n";
```

Se você salvar este código como `script.pl` e executá-lo usando `perl script.pl`,
o perl irá ignorar qualquer coisa entre as linhas `=pod` e o `=cut`.
Somente o código em si será executado.

Por outro lado, se você digitar o comando `perldoc script.pl`, o `perldoc`
irá desconsiderar todo o código. Ele vai buscar as linhas entre `=pod` e `=cut`,
para então formatá-las e exibi-las na tela.

Estas regras variam de acordo com o seu sistema operacional, mas elas são exatamente as mesmas que você viu quando aprendemos sobre a
[documentação padrão do Perl](/documentacao-do-perl-e-modulos-cpan).

A importância da utilização do POD incorporado é que seu código jamais será fornecido
acidentalmente sem a documentação, pois a documentação está dentro dos módulos e dos scripts.
Você também pode reutilizar as ferramentas e infra-estrutura da comunidade Open Source Perl
construído para si. Mesmo para os seus fins <i>in-house.</i>

## Muito simples?

O pressuposto aqui é que ao remover a maioria dos obstáculos presentes na escrita da
documentação, então mais pessoas vão escrever a documentação em seus projetos. Em vez de aprender como usar um processador
de texto para criar documentos com aparência agradável, você irá somente digitar um texto com alguns símbolos extras e então
obter um documento de aparência razoável. (Confira os documentos sobre [Meta CPAN](http://metacpan.org/)
para ver uma versão bem formatada do POD).

## A linguagem de marcação

Uma descrição detalhada da [linguagem de marcação POD](http://perldoc.perl.org/perlpod.html)
pode ser encontrada digitando na linha de comandos [perldoc perlpod](http://perldoc.perl.org/perlpod.html).

Existem também <i>tags</i> como a `=head1` e `=head2` utilizadas para sinalizar os cabeçalhos "mais importantes" e "um pouco menos importante".
Há também o `=over` utilizado para indentações e `=item`
para permitir a criação de <i>bullet points</i>, entre outros.

Há também o `=cut` para marcar o fim de uma seção POD e `=pod` para iniciar uma.
Embora esta marcação inicial não seja estritamente necessária.

Qualquer sequência que começa com um sinal de igual `=` como o primeiro caractere em uma linha irá ser interpretada como uma marcação POD,
e vai começar uma seção POD fechado por `=cut`

O POD ainda permite a incorporação de hiper-links usando a notação L&lt;nome-do-link>.

O texto entre as partes de marcação será mostrado como parágrafos de texto simples.

Se o texto não for iniciado no primeiro caractere da linha, ele será levado literalmente,
o que significa que será exatamente como você os digitou: longos textos irão permanecer longos e textos curtos permanecerão curtos.
Este exemplo é usado para exemplos de código.

Uma coisa importante a lembrar é que POD requer linhas vazias ao redor das <i>tags</i>.
Assim:

```perl
=head1 Título
=head2 legenda
Algum texto
=cut
```

Não vai fazer o que você está esperando.

## A Aparência

Como o POD é uma linguagem de marcação, ela não irá por si só definir como as coisas serão exibidas.
Ao usar o `=head1` estamos apenas indicando algo importante, `=head2` significa, por exemplo algo menos importante.

A ferramenta que é utilizada para apresentar o POD irá normalmente usar caracteres maiores para exibir o texto de uma head1 do que a de um
head2 que por sua vez irá ser exibida usando fontes maiores do que o texto normal. O controle está nas mãos da ferramenta de exibição.

O comando `perldoc` que vem com perl exibe o POD como uma página manual (<i>mand-page</i>). É uma ferramenta bastante útil em Linux.
Mas não tão boa assim no Windows.

O módulo [Pod::Html](https://metacpan.org/pod/Pod::Html) fornece outra ferramenta de linha de comando chamado `pod2html`.
Essa ferramenta é capaz de converter um texto POD em um documento HTML que você pode ver em seu navegador.

Há também ferramentas adicionais para geração de arquivos do tipo pdf ou arquivos mobi a partir do POD.

## Público Alvo

Depois de ver a técnica, vamos ver quem é o público alvo?

Os comentários de código (o texto que começa com um #) são explicações para
os programadores ou responsáveis pela manutenção do código. Neste caso é a
pessoa que precisa de recursos para realizar a manutenção do código.

A documentação escrita em POD é útil aos usuários. Pessoas que não irão
olhar o código fonte. No caso de uma aplicação, este são chamados de "usuários finais".
Ou seja, todos nós.

No caso dos módulos Perl, os usuários são outros programadores Perl que desejam
construir aplicações e outros módulos. A princípio eles não precisariam olhar seu código fonte.
Eles devem ser capazes de usar seu módulo apenas lendo a documentação via <b>perldoc</b>.

## Conclusão

Escrever a documentação do código e fazer com que pareça agradável não é nada
difícil de ser feita em Perl.

