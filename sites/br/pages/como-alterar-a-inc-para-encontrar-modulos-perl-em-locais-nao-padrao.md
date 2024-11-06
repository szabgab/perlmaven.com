---
title: "Como alterar a @INC para encontrar módulos Perl em locais não padrão?"
timestamp: 2013-05-30T19:10:00
tags:
  - @INC
  - use
  - PERLLIB
  - PERL5LIB
  - lib
  - -I
published: true
original: how-to-change-inc-to-find-perl-modules-in-non-standard-locations
books:
  - beginner
author: szabgab
translator: aramisf
---


Ao usar módulos que não estão instalados nos diretórios padrão do Perl,
precisamos alterar a variável @INC para que o Perl possa encontra-los. Existem
alguns meios de fazer isso, resolvendo diferentes casos de uso.

Vejamos primeiramente esses casos de uso:



## Carregando o seu módulo Perl privado

Você tem um script e está começando a mover algumas partes do seu código para
um novo módulo chamado `My::Module`.
Você gravou o módulo em `/home/foobar/code/My/Module.pm`.

Seu script Perl agora começa assim:

```perl
use strict;
use warnings;

use My::Module;
```

Quando você executa o script você recebe uma mensagem de erro amigável como esta:

```
Can't locate My/Module.pm in @INC (@INC contains:
   /home/foobar/perl5/lib/perl5/x86_64-linux-gnu-thread-multi
   /home/foobar/perl5/lib/perl5
   /etc/perl
   /usr/local/lib/perl/5.12.4
   /usr/local/share/perl/5.12.4
   /usr/lib/perl5 /usr/share/perl5
   /usr/lib/perl/5.12
   /usr/share/perl/5.12
   /usr/local/lib/site_perl
   .).
   BEGIN failed--compilation aborted.
```

O Perl não consegue encontrar o seu módulo.

## Atualizando um módulo Perl

Você está pensando em atualizar um módulo proveniente do CPAN em um sistema
qualquer. Você não quer instalar este módulo no local padrão ainda. Antes você
gostaria de coloca-lo em um diretório privado, testa-lo, e instalar no sistema
somente quando estiver certo de que o módulo funciona bem.

Neste caso também você "instala" o módulo em um diretório privado, por
exemplo, em /home/foobar/code e de alguma forma você pretende convencer o Perl
a encontrar aquela versão do módulo, e não a que está instalada no sistema.

## O comando use

Quando o Perl encontra `use My::Module;` ele percorre os elementos do
vetor @INC que contém nomes de diretórios. Em cada diretório ele verifica se
existe um subdiretório chamado "My" e se dentro deste subdiretório existe um
arquivo chamado "Module.pm".

O primeiro arquivo encontrado pelo Perl será carregado na memória.

Se ele não encontrar o arquivo, você recebe as mensagens de erro acima.

`@INC` é definida quando o Perl é compilado e ela é embutida no código
binário. Você não pode mudar isso a não ser que você recompile o Perl. Não é
algo que faríamos diariamente.

Por sorte o vetor `@INC` pode ser modificado de diversas maneiras ao
executarmos um script. Vamos ver essas soluções e discutir quando cada uma
delas é mais apropriada.

## PERLLIB e PERL5LIB

Você pode definir a variável de ambiente PERL5LIB (ainda que PERLLIB funcione
do mesmo modo, eu recomendaria usar PERL5LIB ao invés da PERLLIB por ela
deixar claro que é com relação ao Perl 5) da mesma forma que você define a
variável de ambiente PATH. Todo diretório listado nessa variável será
adicionado ao início da `@INC`.

No <b>Linux/Unix</b> ao usar o <b>Bash</b>, você pode escrever

```
export PERL5LIB=/home/foobar/code
```

Você pode adicionar este comando no arquivo ~/.bashrc para disponibiliza-la
sempre que fizer login.

No <b>Windows</b> você pode fazer o mesmo na janela do programa cmd digitando

```
set PERL5LIB = c:\path\to\dir
```

Para uma solução mais perene siga estes passos:

Clique com o botão direito em <b>Meu Computador</b> e clique em
<b>Propriedades</b>.

Na janela <b>Propriedades do Sistema</b>, clique na aba <b>Avançado</b>.

Na seção Avançada, clique no botão <b>Variáveis de Ambiente</b>.

Na janela Variáveis de Ambiente, na seção "Variáveis do usuário para Foo Bar"
clique em <b>Nova</b> e digite o seguinte:

Nome da Variável: PERL5LIB

Valor da Variávle: c:\path\to\dir

Então clique OK 3 vezes. As janelas que você abrir <b>depois</b> disso vão
conhecer esta variável. Digite isso na janela de comando, para ver o valor
recentemente definido:

```
echo %PERL5LIB%
```

<hr>

Isso irá adicionar o diretório privado /home/foobar/code (ou c:\path\to\dir)
para o início da <b>@INC</b> para <b>todo script</b> que for executado no
mesmo ambiente.

No <b>modo sujo</b>, que será explicado em um artigo separado, as variáveis de
ambiente PERLLIB e PERL5LIB são ignoradas.

## use lib

Adicionar uma instrução `use lib;` ao script vai adicionar o diretório
à `@INC` para aquele script específico.
Independentemente de quem e em qual ambiente for executado.

Você precisa apenas se certificar que a instrução use lib foi utilizada antes
de tentar carregar o módulo:

```perl
use lib '/home/foobar/code';
use My::Module;
```

Uma nota aqui. Vi muitas empresas onde instruções `use lib` foram
adicionadas a módulos para que os mesmos carreguem suas dependências. Não
considero isso uma boa prática.
Acho que o lugar certo de modificar `@INC` é o script principal ou até
melhor, fora do script como nas duas outras soluções.

## -I na linha de comando

(Isto é um i maiúsculo)

A última solução é a mais temporária.
Adicionar um parâmetro `-I /home/foobar/code` ao Perl ao executar o
script.

<b>perl -I /home/foobar/code  script.pl</b>

Isso vai adicionar /home/foobar/code ao início da @INC <b>para esta execução
específica</b> do script.

## Então qual delas usar?

Se você deseja somente testar a nova versão de um módulo, eu recomendaria o
parâmetro da linha de comando:
`perl -I /path/to/lib`.

Se você está instalando um conjunto de módulos em um diretório privado então
eu provavelmente usaria `PERL5LIB` embora também veremos que o
`local::lib` faz isso por você.

`use lib` é usado em dois casos:

<ol>
<li>Quando você tem um local fixo, porém num ambiente não padronizado na
empresa, onde se põe os módulos em um local padronizado comum.</li>
<li>Quando você está desenvolvendo uma aplicação e você gostaria de ter
certeza que o script sempre carrega os módulos de seus caminhos relativos.
Vamos discutir isto em outro artigo.</li>
</ol>

