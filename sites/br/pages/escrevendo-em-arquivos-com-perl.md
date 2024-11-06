---
title: "Escrevendo em Arquivos com Perl"
timestamp: 2013-04-19T16:45:56
tags:
  - open
  - close
  - write
  - die
  - open or die
  - ">"
  - encoding
  - UTF-8
published: true
original: writing-to-files-with-perl
books:
  - beginner
author: szabgab
translator: leprevost
---


Vários programas escritos em Perl lidam com arquvios de texto, como por exemplo arquivos
de configuração ou arquivos de histórico, então para que o nosso conhecimento seja útil
é importante que possmos aprender desde o início a manipular arquivos.

Primeiramente vamos ver como fazemos para escrever em um arquivo.


Antes que você escrever algo em um arquivo você precisa <b>abrir</b> o arquivo, pedindo
ao sistema operacional (Windows, Linux, OSX, etc) abrir um canal de comunicação
entre o seu programa e o arquivo em si. Para isso o Perl fornece a função `open`,
possuindo uma sintaxe um pouco incomun.

```perl
use strict;
use warnings;

my $arquivo = 'report.txt';
open(my $fh, '>', $arquivo) or die "Não foi possível abrir o arquivo '$arquivo' $!";
print $fh "Meu primeiro relatório gerado pelo Perl\n";
close $fh;
print "pronto\n";
```

Este é um bom exemplo funcional e nós logo iremos retornar a ele, mas antes vamos iniciar com um exemplo
um pouco mais simples:

## Exemplo Simples

```perl
use strict;
use warnings;

open(my $fh, '>', 'report.txt');
print $fh "Meu primeiro relatório gerado pelo Perl\n";
close $fh;
print "pronto\n";
```

Esse exemplo também precisa de uma explicação. A função <b>open</b> necessita de 3 parâmetros.

O primeiro, `$fh` é uma variável escalar que nós declaramos dentro da função `open`.
Nós pederíamso também ter declarado a variável antes, mas geralmente dessa forma o código fica um
pouco mais limpo, mesmo que parece um pouco estranho de início. O segundo parâmetro define a forma como
iremos abrir o arquivo.
Neste caso, utilizamos o sinal de <i>maior que</i> (`&gt;`) significando que iremos abrir o arquivo
para escrita.
O terceiro parâmetro é o caminho do arquivo que gostaríamos de abrir. 

Quando esta função é invocada, é colocado dentro da variável `$fh` um símbolo especial.
Este símbolo é chamado de <i>file-handle</i> (podemos traduzir como 'manipulador de arquivos).
No momento não nos importamos muito com o conteúdo desta variável; iremos somente utilizá-la
no futuro. Apens lembre-se que no momento o conteúdo do arquivo está apenas no disco e <b>NÃO</b>
na variável `$fh`.

Uma vez estando aberto, podemos utilizar o <i>file-handle</i> `$fh` junto da função `print()`.
O seu uso se assemelha bastante com o uso do `print` visto anteriormente em outros tutoriais,
porém agora o primeiro parâmetro é o próprio <i>file-handle</i> <b>não</b> sendo seguido por vírgula.

A chamada ao print() irá imprimir no arquivo o texto definido.

Então, na linha seguinte nós fechamos o <i>file-handle</i>. Mesmo não sendo
algo estritamente necessário em Perl. O Perl irá automaticamente fechar todos os
<i>file-handles</i> quando a variável sair do seu escopo, ou então quando o scritp terminar.
Em todos os casos, consideramos uma oa prática realizar o fechamento de forma explícita.

A últina linha `print "pronto\n"` está lá somente para que o nosso exemplo fique mais didático.

## Lidando com Erros

Vamos utilizar o exemplo acima novamente e substituir o nome do arquivo por um caminho que não existe.
Por exemplo:

```perl
open(my $fh, '>', 'algum_caminho_qualquer/report.txt');
```

Agora quando executar o programa verá a seguinte menssagem de erro:

```
print() on closed file-handle $fh at ... # impressão realizada em arquivo fechado
done
```

Na verdade isto é apenas um aviso; o script continuará executando e por isso que precisamos de
algo como o "pronto" impresso na tela.

Além disso, nós somente pudemos ver a mensagem de erro porque nós pedimos para receber avisos
ao utilizar o pragma `use warnings`.
Experimente comentar essa linha e perceba que agora o script é silencioso quando falha em tentar abrir o arquivo.
Dessa forma você não perceberia até o seu cliente, ou até mesmo, seu chefe reclamar.

De qualquer forma ocorreu um erro. Nós tentamos abrir um arquivo, nós falhamos e ainda assim tentamos
escrever algo no arquivo.

Nós deveríamos ter avaliado se a função `open()` funcionou corretamente antes de proceder.

Por sorte, a função retorna valor <a href="/valores-booleanos-em-perl">VERDADEIRO caso tenha sucesso e
FALSO se falhar</a>, então podemos escrever o seguinte:

## Open or die

```perl
open(my $fh, '>', 'algum_caminho_qualquer/report.txt') or die;
```

Esta é a forma "padrão" do idioma <b>open or die</b> (abra ou morra). Muito commum em Perl..

`die` é a função que irá lançar uma exceção e então terminar o script.

"open or die" (abra ou morra) é uma expressão lógica. Como você deve ter visto em uma edição
anterior do tutorial, o "or" (ou) em Perl é avaliado por curto-circuíto, assim como
em outras linguagens. Isto significa que se a parte da esquerda for VERDADE, nós já sabemos que
o restante da declaração também será VERDADE, fazendo com que o lado direito não seja executado.
Por outro lado, se o lado esquerdo for FALSO então o lado direito é executado também e o resultado
será proveniente da expressão como um todo.

Neste caso nós tiramos proveito desse curto-circuito para escrever expressões.

Caso o `open()` funcione corretamente então retornará VERDADEIRO e a parte da direita
nunca será executada, levando o script a executar a próxima linha.

Caso o `open()` falhe, então retornará FALSO. Neste caso o lado direito será executado,
lançando uma exceção e em seguida matando a execução do código.

No exemplo acima nós não realizamos uma avaliação do valor de retorno propriamente dito.
Nós não nos importamos. Apenas tiramos proveito do retorno para o "efeito colateral".

Se você experimentar executar o código acima com as alterações, irá receber uma mensagem de erro:

```
Died at ...
```

e NÃO irá imprimir "pronto".

## Uma Forma Melhor de Reportar Erros

Ao invés de apenas chamar a função `die` sem parâmetros, nos podemos adicionar uma pequena explicação do
que ocorreu.

```perl
open(my $fh, '>', 'algum_caminho_qualquer/report.txt')
  or die "Não foi possível abrir o arquivo 'algum_caminho_qualquer/report.txt'";
```

irá imprimir:

```
  Não foi possível abrir o arquivo 'algum_caminho_qualquer/report.txt' ...
```

Dessa forma é melhor mas em algum momento alguém irá tentar alterar para o caminho correto do arquivo ...

```perl
open(my $fh, '>', 'caminho_correto_com_erro_de_digitação/report.txt')
  or die "Não foi possível abrir o arquivo 'algum_caminho_qualquer/report.txt'";
```

...mas você ainda assim receberá a mensagem antiga porque foi alterado apenas
o conteúdo da função `open()`, e não a mensagem de erro. 

É melhor usarmos uma variável para os nomes de arquivos:

```perl
my $arquivo = 'caminho_correto_com_erro_de_digitação/report.txt';
open(my $fh, '>', $arquivo) or die "Não foi possível abrir o arquivo '$arquivo'";
```

Agora nós temos a mensagem de erro correta, mas ainda não sabemos porquê houve uma falha.
Indo um passo a diante, nós podemos utilizar `$!` - uma variável interna do Perl - para
imprimir a mensagem de erro proveniente do sistema operacional sobre a falha:

```perl
my $arquivo = 'caminho_correto_com_erro_de_digitação/report.txt'';
open(my $fh, '>', $arquivo) or die "Não foi possível abrir o '$arquivo' $!";
```

Isso irá imprimir:

```
Não foi possível abrir o arquivo 'caminho_correto_com_erro_de_digitação/report.txt' No such file or directory ... 
```

Agora sim, muito melhor!

Com isso nós retornamos ao nosso exemplo original.

## Maior do que?

O sinal <i>maior do que</i> no início da função pode ser um pouco obscuro,
mas se você está familiarizado com o sinal de direcionamento utilizado la linha de comandos então este
caso é familiar a você. Caso contrário pense apenas que o sinal atua como uma flecha indicando a direção do
fluxo de dados:
para dentro do arquivo, no lado direito da expressão.

## Caracteres não latinos?
Em casos em que precise lidar com caracteres que não fazem parte da table ASCII, você provavelmente precisará salvá-los
como UTF-8. Para fazer isso você precisa avisar ao Perl que irá abrir um arquivo com codificação UTF-8.

```perl
open(my $fh, '>:encoding(UTF-8)', $arquivo)
  or die "Não foi possível abrir o arquivo '$arquivo'";
```
