---
title: "Como criar um Módulo Perl para reutilização de código?"
timestamp: 2013-05-12T01:25:00
tags:
  - package
  - use
  - Exporter
  - import
  - @INC
  - @EXPORT_OK
  - $0
  - dirname
  - abs_path
  - Cwd
  - File::Basename
  - lib
  - 1;
published: true
original: how-to-create-a-perl-module-for-code-reuse
books:
  - advanced
author: szabgab
translator: aramisf
---


Você talvez esteja criando cada vez mais scripts para os seus sistemas, os
quais precisam usar um mesmo conjunto de funções.

Você já dominou a antiga técnica de copiar-e-colar, mas você não está
satisfeito com o resultado.

Você provavelmente conhece muitos módulos Perl que lhe permitem usar suas
funções e você também quer criar um.

Contudo, você não sabe como criar tal módulo.


## O módulo

```perl
package My::Math;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(add multiply);

sub add {
  my ($x, $y) = @_;
  return $x + $y;
}

sub multiply {
  my ($x, $y) = @_;
  return $x * $y;
}

1;
```

Grave isto em algumdir/lib/My/Math.pm (ou algumdir\lib\My\Math.pm no Windows).

## O Script

```perl
#!/usr/bin/perl
use strict;
use warnings;

use My::Math qw(add);

print add(19, 23);
```

Grave isto em algumdir/bin/app.pl (ou algumdir\bin\app.pl no Windows).

Agora execute <b>perl algumdir/bin/app.pl</b>. (ou <b> algumdir\bin\app.pl</b>
no Windows).

Será impresso um erro como este:

```
Can't locate My/Math.pm in @INC (@INC contains:
...
...
...
BEGIN failed--compilation aborted at somedir/bin/app.pl line 9.
```

## Qual é o problema?

No script carregamos o módulo usando a palavra chave `use`.
Especificamente através da linha com o `use My::Math qw(add);`.
Isto vasculha os diretórios listados na variável padrão`@INC`, procurando um
subdiretório chamado <b>My</b> e naquele subdiretório um arquivo chamado
<b>Math.pm</b>

O problema é que o seu arquivo .pm não está em nenhum dos subdiretórios padrão
do perl: não está em nenhum dos diretórios listados em @INC.

Você pode mover seu módulo, ou mudar o conteúdo da sua variável @INC.

A primeira sugestão pode ser problemática, especialmente em sistemas onde
existe uma forte separação entre o administrador do sistema e o usuário. Por
exemplo, em sistemas UNIX e Linux apenas o usuário "root" (o administrador)
tem permissão de escrita nesses diretórios.
Então, em geral é mais fácil e mais correto modificar a variável @INC.

## Mude @INC a partir da linha de comando

Antes de tentarmos carregar o módulo, temos que nos certificar de que o módulo
está na variável @INC.

Tente isto:

<b>perl -Ialgumdir/lib/ algumdir/bin/app.pl</b>.

Isso vai imprimir a resposta: 42.

Nesse caso, a chave `-I` do perl nos ajudou a adicionar o caminho do
diretório à @INC.



## Mude @INC de dentro do script

Porque sabemos que o diretório "My", que contém nosso módulo, está em um lugar
fixo <b>relativo</b> ao script, temos outra possibilidade de mudar o script:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/lib';

use My::Math qw(add);

print add(19, 23);
```

e execute novamente com este comando:

<b>perl algumdir/bin/app.pl</b>.

Agora funciona.

Expliquemos a mudança:

## Como a variável @INC modificada aponta para um diretório relativo

Esta linha:
`use lib dirname(dirname abs_path $0) . '/lib';`
adiciona o diretório lib (relativo ao script) ao início da `@INC`.

`$0` contém o nome do script atual.
`abs_path()` de `Cwd` retorna o caminho absoluto do script.

Dado um caminho para um arquivo ou diretório, a chamada para
`dirname()` de `File::Basename` retorna uma parte do caminho
referente ao diretório, retirando apenas a parte relativa ao nome do arquivo.

Em nosso caso, $0 contém app.pl

abs_path($0) retorna  .../algumdir/bin/app.pl

dirname(abs_path $0)   retorna  .../algumdir/bin

dirname(dirname abs_path $0)   retorna  .../algumdir

Este é o diretório raiz do nosso projeto.
dirname(dirname abs_path $0) . '/lib' então aponta para  .../algumdir/lib

Então o que temos aí é basicamente

`use lib '.../algumdir/lib';`

mas sem deixar escrito no código o caminho real da árvore inteira.

Todo trabalho dessa chamada é adicionar o '.../algumdir/lib' como o primeiro
elemento de @INC.

Uma vez que isto esteja feito, a chamada subsequente para `use My::Math
qw(add);` vai encontrar o diretório 'My' em '.../algumdir/lib' e o
'Math.pm' em '.../algumdir/lib/My'.


A vantagem desta solução é que o usuário do script não tem que lembrar de
colocar o -I... na linha de comando.

Existem outras <a href="https://perlmaven.com/how-to-change-inc-to-find-perl-modules-in-non-standard-locations">formas de
modificar @INC</a> para você usar em outras situações.

## Explicando o use

Como eu escrevi anteriormente, a chamada para o `use` vai olhar para o
diretório My e o arquivo Math.pm dentro dele.

O primeiro que ele encontra será carregado na memória e a função
`import` de My::Math será chamada com os parâmetros que seguem o nome
do módulo. Em nosso caso `import( qw(add) ) que é o mesmo que chamar
`import( 'add' )`.


## A explicação do script

Não há muito mais a explicar no script. Depois da declaração `use`
terminar sua chamada para a função `import`, podemos então chamar a
recém importada função <b>add</b> do módulo My::Math. Como se eu tivesse
declarado a função no mesmo script.

O que é mais interessante é ver as partes do módulo.


## A explicação do módulo

Um módulo em Perl é um escopo no arquivo correspondendo ao escopo daquele módulo.
A palavra chave `package` cria tal escopo. Um nome de módulo My::Math
se refere ao um arquivo My/Math.pm. Um nome de módulo como A::B::C se refere a
um arquivo A/B/C.pm localizado em algum lugar nos diretórios listados em @INC.

Como você lembra, a declaração `use My::Math qw(add);` no script vai
carregar o módulo e depois chamar a função `import`. A maioria das
pessoas não quer implementar sua própria função import, então elas carregam o
módulo `Exporter` e importam a função 'import'.

Sim, é um pouco confuso. O importante a lembrar é que o Exporter lhe fornece o
import.

Esta função import vai procurar o array `@EXPORT_OK` dentro do módulo
que você está escrevendo e preparar as funções nele contidas para a importação
sob demanda.

Ok, talvez eu precise esclarecer:
O módulo "exporta" funções e o script as "importa".


A última coisa que preciso mencionar é o `1;` no final do módulo.
Basicamente a declaração use está executando o módulo e nele ela precisa ver
algum tipo de declaração final com algum valor verdadeiro. Pode ser qualquer
coisa. Alguns põe `42;`, outros, os bem-humorados colocam
`"FALSE"`. Afinal de contas, toda string não vazia <a
href=/valores-booleanos-em-perl> é considerada verdadeira em Perl</a>.
Isto confunde quase todo mundo. Existem ainda aqueles que citam poemas!


"As últimas palavras."

Na real isto é legal, contudo pode confundir alguns à primeira vista.

Existem também duas funções no módulo. Decidimos exportar ambas, mas o usuário
(autor do script) quis importar apenas uma das subrotinas.


## Conclusão

Com exceção de algumas linhas que expliquei acima, é bastante simples criar um
módulo Perl.
Claro que existem outras coisas que você poderá aprender sobre módulos que
aparecerão em outros artigos, mas não há nada que lhe impeça de transferir
algumas funções comuns para um módulo.

Talvez mais um aviso sobre como chamar seu módulo:

## Nomeando módulos

É altamente recomendado usar letras maiúsculas como a primeira letra de toda
palavra do nome do módulo e letras minúsculas no restante.
Também é recomendável usar um escopo com vários níveis de profundidade.

Se você trabalha em uma empresa chamada Abc, eu recomendaria que todos os
módulos fossem precedidos pelo nome de escopo Abc::. Se dentro da empresa
existe um projeto chamado Xyz, então todos os módulos a ele pertencentes
deveriam estar em Abc::Xyz::.

Então se você tem um módulo que lida com configurações, você poderia chamar o
pacote de Abc::Xyz::Config que faz referência ao arquivo
.../projectdir/lib/Abc/Xyz/Config.pm.


Por favor evite chama-lo apenas de Config.pm. Isso vai confundir o Perl (que
vem com seu próprio Config.pm) e você.

