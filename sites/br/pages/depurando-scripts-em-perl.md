---
title: "Depurando Scripts em Perl"
timestamp: 2013-05-02T19:45:57
tags:
  - -d
  - Data::Dumper
  - print
  - debug
  - debugging
  - $VAR1
  - $VAR2
published: true
original: debugging-perl-scripts
books:
  - beginner
author: szabgab
translator: leprevost
---


Qando eu estudei ciências da computação na universidade, nós aprendemos muito sobre como escrever programas, mas pelo o que eu me lembro,
ninguém nos ensinou sobre a depuração de código.
Ouvimos sobre o mundo simpático onde se cria coisas novas, mas ninguém nos disse que a maior parte do tempo nós iríamos 
utilizar tentando entender o código de outras pessoas.


Acontece que enquanto nós prezamos principalmente escrever um programa, nós gastamos
muito mais tempo tentando entender o que nós (ou outros) escrevemos, passamos mais tempo 
tentando entender o por que do código se comportar de tal forma, do que passamos 
escrevendo-o pela primeira vez.

## O que é depuração?

Antes de executarmos um programa tudo está estável e funcionando.

Após a execução do programa algo de inesperado acontece, e o código passa a estar num estado de erro.

A tarefa agora é descobrir em que ponto foi que algo errado aconteceu, e assim poder corrigi-lo.

## O que é desenvolvimento e o que é um <i>bug?</i>

Basicamente, a programação consiste em mudar o mundo aos poucos movendo os dados por entre variáveis.

Em cada etapa do programa alterarmos alguns dados em uma determinada variável no programa, ou algo no "mundo real" (Por exemplo no disco ou na tela).

Quando você escreve um programa você antecipadamente pensa em cada passo: qual valor que deverá ser alocado para determinada variável.

Um bug ocorre quando você pensa ter colocado valor X em alguma variável enquanto na realidade o valor colocado foi Y.

Em determinado ponto, geralmente no final do programa, você pode perceber isso quando o programa imprime um valor incorreto.

Durante a execução do programa os bugs podem se manifestar na forma de avisos ou até 
mesmo na finalização anormal do programa.

## Como depurar?

A maneira mais simples para depurar um programa é executá-lo, e em cada etapa para verificar se todas as variáveis estão mantendo os valores esperados.
Você pode fazer isso utilizando um <b>depurador</b> ou você pode <b>imprimir os valores</b> das variáveis ao longo do programa.

A linguagem Perl vem com um poderoso depurador de linha de comando. Enquanto eu recomendo aprender a usá-lo, ele pode ser um pouco intimidante no começo.
Eu preparei um vídeo onde eu mostro o <href="/using-the-built-in-debugger-of-perl">os comandos básicos do depurador do Perl</a>.

IDEs, como o [Komodo](http://www.activestate.com/),
<a href="http://eclipse.org/"> Eclipse </ a> e o
[ Padre, a IDE em Perl ](http://padre.perlide.org/) vem
equipados com um depurador gráfico. Em algum momento eu vou preparar um vídeo sobre
alguns desses também.

##  Imprimindo declarações

Muitas pessoas estão usando a estratégia antiga de adicionar instruções de impressão no código.

Em uma linguagem onde a compilação e construção podem ter um monte de declarações de impressão, essa estratégia é considerada um mau caminho para depuração de código.
Já em Perl não é bem assim, onde até mesmo a compilação de grandes aplicações pode ocorrer em segundos.

Ao adicionar declarações de impressão deve-se tomar o cuidado de adicionar delimitadores em torno dos valores. Desta forma é possível perceber quando há espaços 
vazios a frente ou atrás dos valores que estão causando problemas. Este é um problema difícil de se perceber sem um delimitador:

Valores escalares podem ser impressos desta forma:

<pre class="prettyprint linenums languague-perl">
print "<$ nome_do_arquivo> \ n";
</pre>

Aqui, os sinais de menor ou igual e maior ou igual estão ali apenas para tornar mais fácil 
para o leitor para ver o conteúdo exato da variável:

<pre class="prettyprint">
<Caminho/para/o/arquivo
>
</pre>

Se o caso acima acontecer ao ser impresso pode-se rapidamente notar que há uma nova linha à direita no final da variável $nome_do_arquivo. 
Provavelmente você se esqueceu de usar o <b>chomp</b>.

## Estruturas de dados complexas

Nós ainda não aprendemos nem mesmo sobre variáveis escalares ainda, mas deixe-me passar à frente aqui e mostrar a você como eu faria para imprimir o 
conteúdo das estruturas de dados mais complexas. Se você está lendo isto como parte do tutorial Perl, então você provavelmente vai querer pular para o próximo a artigo
e voltar mais tarde. Isso não vai significar muito para você agora.

Caso contrário, continue lendo.

Para estruturas complexas de dados (referências, matrizes e hashes), você pode usar o 
módulo <b>Data::Dumper</b>

<pre class="prettyprint linenums languague-perl">
use Data::Dumper qw (dumper);

print Dumper \ @um_array;
print Dumper \% uma_hash;
print Dumper $uma_referencia;
</pre>

Este código irá imprimir algo parecido com isto, o que ajuda a entender o conteúdo das variáveis, mas mostra apenas um nome genérico como <b>$var1</b> e <b>$var2</b>.

<pre class="prettyprint">
$var1 = [
       'A',
       'B',
       'C'
     ];
$var1 = {
       'A' => 1,
       'B' => 2
     };
$var1 = {
       'C' => 3,
       'D' => 4
     };
</pre>

Eu recomendaria a adição de um pouco mais de código e imprimir o nome da variável desta forma:

<pre class="prettyprint linenums languague-perl">
print '@um_array:' . Dumper \ @um_array;
</pre>

Resultando em:

<pre class="prettyprint">
@um_array: $var1 = [
        'A',
        'B',
        'C'
      ];
</pre>

ou com o Data::Dumper desta forma:

<pre class="prettyprint linenums languague-perl">
print Data::Dumper->Dump([\@um_array, \%uma_hash, $uma_referencia],
   [qw(um_array uma_hash uma_referencia)]);
</pre>

resultando

<pre class="prettyprint">
$um_array = [
            'A',
            'B',
            'C'
          ];
$uma_hash = {
          'A' => 1,
          'B' => 2
        };
$uma_referencia = {
               'C' => 3,
               'D' => 4
             };
</pre>

Há maneiras mais agradáveis para imprimir estruturas de dados, mas neste momento 
<b>Data::Dumper</b> é bom o suficiente para as nossas necessidades e está disponível em todas as instalações perl. 
Vamos discutir outros métodos mais tarde.
