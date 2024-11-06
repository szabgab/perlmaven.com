---
title: "Instalando o Perl, imprimindo 'Olá Mundo', Segurança (use strict, use warnings)"
timestamp: 2013-03-12T18:45:56
tags:
  - strict
  - warnings
  - say
  - print
  - chomp
  - scalar
  - $
published: true
original: installing-perl-and-getting-started
books:
  - beginner
author: szabgab
translator: leprevost
---


Esta é a primeira parte do [Tutorial Perl](/perl-tutorial).


Neste artigo você aprenderá como instalar o Perl no Microsoft Windows e como começar a usar a linguagem em Windows, Linux e Mac.

Você receberá direcionamentos para organizar e configurar seu ambiente de desenvolvimento, ou em menores palavras:
Qual editor de texto ou IDE usar para escrever código em Perl?

Também vamos conferir o clássico exemplo do “Olá Mundo”.

## Windows

Para trabalhar no Windows iremos utilizar o pacote [DWIM Perl](http://dwimperl.szabgab.com/). Nele podemos encontrar o tradicional compilador/interpretador perl, a IDE de desenvolvimento PADRE, escrita em Perl e mais um conjunto de extensões presentes no [CPAN.](http://padre.perlide.org/)

Para que possamos começar, entre na página do [DWIM Perl](http://dwimperl.szabgab.com/) e clique no link para realizar o Download do <b>DWIM Perl for Windows</b>.

Baixe para a sua máquina o executável <i>.exe</i> e instale-o em seu sistema. Antes de prosseguir com a instalação certifique-se de que não há outras versões do Perl instaladas.

Você até poderia ter em seu sistema mais de uma versão instalada e configurada, porém isso requer alguns cuidados extras.
Por enquanto vamos instalar apenas uma versão do Perl.

## Linux

A maioria das distribuições modernas do Linux já possuem uma versão recente do Perl. Por enquanto usaremos a própria versão do sistema operacional. No caso do editor de texto, você poerá instalar o Padre - a maioria das distribuições oferecem o Padre em seus repositórios nativos de software, pelo gerenciador de pacotes do sistema. Caso contrário, você pode utilizar qualquer editor de texto tradicional . Se você está mais familiarizado com vim ou Emacs, use aquele que você preferir. Outra boa opção simples é o Gedit.

## Apple

Eu acredito que o Mac também possua Perl instalado em seus sistema, ou caso não tenha, você pode facilmente instalar a linguagem a partir das ferramentas de instalação do sistema.

## Editor e IDE

Mesmo que eu esteja recomendando, você não precisa utilizar a IDE Padre para escrever seus códigos. Na próxima parte eu
irei listar alguns [editores e IDEs](/editores-perl) que poderão ser utilizados para programar em Perl. Mesmo que escolha um outro editor, eu recomendo - para usuários de Windows - instalar o pacote DWIM mencionado acima.

O pacote DWIM possui várias extensões em Perl empacotadas, dessa forma realizar a sua instalação seria uma economia de tempo.

## Video

Se você preferir poderá também assistir o vídeo <a href="http://www.youtube.com/watch?v=c3qzmJsR2H0">Hello world with
Perl</a> disponível no YouTube. Neste caso você também pode acessar o [curso iniciante do Perl Maven](https://perlmaven.com/beginner-perl-maven-video-course)

## Primeiro programa

Seu primeiro programa se parecerá com isso:

```perl
use 5.010;
use strict;
use warnings;

say "Olá Mundo";
```

Deixe-me explicá-lo passo a passo:

## Olá mundo

Uma vez que tenha instalado o DWIM Perl você pode clicar em “Iniciar -> Todos os Programas -> DWIM Perl -> Padre” que irá abrir o editor com um arquivo vazio.

Digite:

```perl
print "Olá Mundo\n";
```

Como você pode ver, as declarações em perl terminam com um ponto e vírgula ( ; ).
O <b>\n</b> é o sinal utilizado para denotar uma nova linha.
O texto é demarcado com aspas duplas ( " ).
A função <b>print</b> imprime algo na tela.
Quando é executado, o perl irá imprimir o texto na tela e ao final irá imprimir uma nova linha.

Salve o arquivo como ola.pl e então você poderá executar o código selecionando "Run -> Run Script". Você irá ver uma janela separada aparecer na tela com o resultado.

Pronto é isso, você escreveu seu primeiro script.

Agora vamos melhorá-lo um pouco:

## Perl na linha de comandos

Se você não estiver utilizando o Padre ou uma das opções descritas em [IDEs](/editores-perl), não será possível executar seu script a partir do próprio editor. Ao menos não pelas configurações padrão. Você precisar abrir o shell (ou o cmd no Windows), mudar para o diretório do script salvo e digitar: 

<b>perl ola.pl</b>

Dessa forma que você conseguirá rodar seu programa na linha de comandos.

## say() Ao Invés De print()

Vamos melhorar um pouco o nosso script Perl de uma linha:

Antes de tudo vamos declarar qual a versão mínima do Perl que desejamos utilizar:

```perl
use 5.010;
print "Olá Mundo\n";
```

Uma vez que tenha digitado isso, você pode rodar os script novamente selecionando “Run->Run Script” ou pressionando <b>F5</b>.
Isso também fará com que o texto seja automaticamente salvo.

Geralmente é boa prática declarar qual é a versão mínima desejada do perl que o seu código exige.

Neste caso também ocorre o adicionamento de algumas características do perl que incluem a palavra-chave <b>say</b>.
<b>say</b> funciona como o <b>print</b>, mas é mais prático de se digitar e automaticamente adiciona ao final do seu texto uma nova linha.

Você pode alterar seu código para que fique da seguinte forma:

```perl
use 5.010;
say "Olá Mundo";
```

Nós substituímos o <b>print</b> por <b>say</b> e removemos o <b>\n</b> do final do texto.

A versão atual do perl que você está usando é provavelmente a versão 5.12.3 ou 5.14.
A maioria das distribuições modernas de Linux possuem a versão 5.10 ou superior.

Infelizmente ainda é possível encontrar sistemas utilizando versões mais antigas do perl.
Nestes casos, não será possível utilizar a função <b>say()</b>, e ainda assim é possível que seja necessário alguns ajustes para que os exemplos acima funcionem. Eu irei indicar quando estiver utilizando características da linguagem que necessitem a versão 5.10 ou superior.

## Segurança

Em adição a todo script eu fortemente recomendo a realização de algumas outras modificações no comportamento do Perl. Para isto, adicionamos 2 características chamadas de <i>pragmata</i>. Elas são muito similares às chamadas <i>compiler flags</i> em outras linguagens:

```perl
use 5.010;
use strict;
use warnings;

say "Olá Mundo";
```

Neste caso a palavra chave `use` indica ao perl que carregue e ative cada um dos <i>pragmas</i>.

`strict` e `warnings` irão ajudá-lo a capturar alguns erros e enganos comuns em seu código ou até mesmo em alguns casos prevenir que você os realize.
Ambos são extremamente úteis.

## Entrada do usuário

Agora vamos melhorar o nosso exemplo perguntando ao usuário o seu nome e incluindo o resultado na resposta.

```perl
use 5.010;
use strict;
use warnings;

say "Qual é o seu nome? ";
my $nome = &lt;STDIN>;
say "Olá $nome, como você está?";
```

<b>$nome</b> é chamada de variável escalar.

Variáveis são declaradas utilizando a função <b>my</b>.
(Na verdade este é uma das obrigações que o <b>pragma</b> `strict` adiciona ao código).

Variáveis escalares sempre iniciam com o sinal <b>$</b>.
O &lt;STDIN&gt; é a função que lê uma linha de texto gerada pelo teclado.

Digite o texto acima e execute o código pressionando o F5.

O programa irá perguntar o seu nome, digite a resposta e aperte o ENTER para que o perl saiba que você terminou de digitar.

Você irá perceber que o resultado está um pouco desformatado: A vírgula após o nome aparece numa linha nova. Isso ocorre porque o ENTER pressionado, foi incluído na variável <b>$nome</b>.

## Descartando novas linhas

```perl
use 5.010;
use strict;
use warnings;

say "Qual é o seu nome? ";
my $nome = &lt;STDIN>;
chomp $nome;
say "Olá $nome, como você está?";
```

Este tipo de situação é muito comum em Perl, de tal maneira que existe uma função especial chamada <b>chomp</b> que remove o caractere de nova linha do final de textos.

## Conclusão

Em todo script que escrever você  <b>sempre</b> deverá adicionar <b>use strict;</b> e <b>use warnings;</b> como as duas primeiras declarações do seu código. É também muito recomendado que adicione <b>use 5.010;</b>.

## Exercício 1

Eu prometi exercícios:

Experimento executar o seguinte script:

```perl
use strict;
use warnings;
use 5.010;

say "Olá ";
say "Mundo";
```

O texto não apareceu em apenas uma linha. Por quê? Como consertar o código?

## Exercício 2

Escreva um script que peça ao usuário dois números, um após o outro.
Então imprima a soma dos dois números.

## O que vem em seguida?

A próxima parte do tutorial será sobre [editores, IDEs e ambientes de desenvolvimento em Perl](/editores-perl).


