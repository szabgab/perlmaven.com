---
title: "Pinto -- O Seu CPAN Personalizado"
timestamp: 2013-05-03T16:30:02
tags:
  - cpan
  - pinto
published: true
original: pinto-tutorial
author: thalhammer
translator: leprevost
---


<i>
Este é um artigo escrito por um convidado, [Jeffrey Ryan Thalhammer](http://twitter.com/thaljef), autor do projetos Pinto
e Perl::Critic.
Até o dia 7 de Maio, Jeff estará [levantando fundos](https://www.crowdtilt.com/campaigns/specify-module-version-ranges-in-pint)
para financiar o desenvolvimento do elemento que irá permitir você a <b>especificar uma série de diferentes versões pelo Pinto.</b>
</i>

Uma das melhores coisas no Perl são os módulos <i>open source</i> que estão disponíveis pelo CPAN.
Mas mantê-los é um trabalho árduo. Toda semana centenas de novos lançamentos ocorrem e você 
nunca sabe quando uma nova versão de um módulo pode introduzir um <i>bug</i> que quebrará a sua aplicação.


This article was originally published on [Pragmatic Perl](http://pragmaticperl.com/)

Uma estratégia para resolver este tipo de prolema é construir seu próprio repositório
do CPAN, que conterá apenas as versões dos módulos que você deseja. Dessa forma você pode utilizar 
o construtor do CPAN para instalar módulos a partir do seu próprio repositório sem ficar
exposto ao CPAN público.

Através dos anos eu construí vários repositórios personalizados do CPAN utilizando ferramentas como
[CPAN::Mini](https://metacpan.org/pod/CPAN::Mini) e [CPAN::Site](https://metacpan.org/module/CPAN::Site).
Mas eles sempre me pareceram desajeitados e nunca estive satisfeito com eles.
A alguns anos atrás, fui contratado por um cliente para construir outro repositório personalizado
do CPAN. Mas desta vez eu tive a oportunidade de começar a partir do zero. O resultado disso tudo
é o projeto Pinto.

[Pinto](https://metacpan.org/pod/Pinto) é uma ferramenta robusta
para criar e manipular repositórios CPAN personalizados.
Ele possui várias características poderosas que irão, de forma segura, lhe ajudar
a gerenciar todos os módulos Perl cuja sua aplicação seja dependente.
Este tutorial irá lhe ajudar a criar um repositório CPAN personalizado com o Pinto
e ao mesmo tempo, demonstrar algumas de suas características.

## Instalando o Pinto

O módulo Pinto está disponível pelo CPAN e pode ser instalado como qualquer
outro módulo utilizando o cpan ou o `cpanm`. Porém o projeto Pinto é
mais uma aplicação do que uma biblioteca. É uma ferramenta que você utiliza
para gerenciar o código de suas aplicações, isso sem se tornar parte de sua 
aplicação. Portanto eu recomendo instalar o Pinto como um projeto 
independente através desses dois comandos:

```
curl -L http://getpinto.stratopan.com | bash
source ~/opt/local/pinto/etc/bashrc
```

Isso irá instalar o Pinto em `~/opt/local/pinto` e adicionará
os diretórios necessários em seu `PATH` e `MANPATH`. Todo o conteúdo
é localizado, isso significa que ao instalar o Pinto não irá afetar o seu ambiente de
desenvolvimento, e da mesma forma, o seu ambiente de desenvolvimento também não irá
afetar o Pinto.

## Explorando o Projeto Pinto

Assim como quando explora uma ferramenta nova, a primeira coisa que você deverá saber
é como buscar ajuda:

```
pinto commands            # Apresenta uma lista de comandos disponíveis
pinto help <COMMAND>      # Apresenta um sumário de opções e argumentos para o <COMMAND>
pinto manual <COMMAND>    # Apresenta o manual completo para <COMMAND>
```

O projeto também é instalado com outra documentação, incluindo um tutorial e um
guia rápido para referências. Você pode acessar esses documentos através dos comandos:

```
man Pinto::Manual::Introduction  # Explica os conceitos básicos do projeto
man Pinto::Manual::Installing    # Sugestões para a instalação
man Pinto::Manual::Tutorial      # Um guia narrativo pelo projeto
man Pinto::Manual::QuickStart    # Um sumário de comandos comuns
```

## Criando o Repositório

O primeiro passo ao utilizar o projeto Pinto é criar um repositório
através do comando `init`:

```
pinto -r ~/repo init
```

O comando criará um novo repositório no diretório `~/repo`.
Se o diretório não existir, ele será criado para você. Se ele já existir
então deve estar vazio.

A opção -r (ou --root) especifica aonde o repositório está. Isso é necessário
para todo comando. Mas se você se cansar de digitar isso sempre, você poderá
configurar a variável de ambiente `PINTO_REPOSITORY_ROOT` para que 
referencie o seu repositório, dessa forma você pode omitir o -r.

## Inspecionando O Repositório

Agora que você já possui um repositório, vamos ver o que há por dentro.
Para ver o seu conteúdo, use o comando `list`:

```
pinto -r ~/repo list
```

A partir desse ponto, a listagem retornará vazia porque não há nada no repositório.
Mas você irá utilizar o comando `list` várias vezes durante o tutorial.

## Adicioando Módulos do CPAN

Suponha que você esteja trabalhando em uma aplicação My-App que contém
um módulo My::App, e que dependa do módulo URI. Você pode trazer o módulo 
URI para o seu repositório utilizando o comando `pull`:

```
pinto -r ~/repo pull URI
```

Você será questionado a escrever uma mensagem que descreva o motivo
de tal mudança em seu repositório. No topo da mensagem inclui uma mensagem simples
que você poderá editar. O rodapé da mensagem mostrará exatamente quais módulos
foram adicionados. 
Salve o arquivo e feche o editor de texto quando terminar.

Agora você deverá ter o módulo URI em seu repositório Pinto. Então vamos
ver o que realmente temos. Novamente use o comando `list` para
ver o conteúdo do repositório:

```
pinto -r ~/repo list
```

Dessa vez a listagem irá se parecer com isso:

```
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```

Você pode observar que o módulo URI foi adicionado ao repositório, assim como
os requisitos para o URI, e todos os requisitos dos requisitos, e assim
por diante.

## Adicionando Módulos Particulares

Agora suponha que você terminou o seu trabalho no módulo My-App e você está
pronto para liberar a primeira versão. Utilizando sua ferramenta preferida de
instalação (e.g. ExUtils::MakeMaker, Module::Builder, Module::Install, etc.)
você cria o pacote da sua distribuição como My-App-1.0.tar.gz. Agora você
pode colocar a distribuição no repositório Pinto com o comando `add`:

```
$> pinto -r ~/repo add path/to/My-App-1.0.tar.gz
```

Novamente será necessário descrever em uma mensagem as mudanças realizadas.
Agora, quando você lista o conteúdo do repositório, verá o módulo My::App
mostrando você como autor da distribuição.

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```


## Instalando Módulos

Agora que você já possui seus módulos dentro do repositório, o próximo passo
será construir e instalar os módulos em algum outro lugar. Por baixo dos panos
o repositório do Pinto é organizado da mesma forma que o repositório do CPAN, então
ele é totalmente compatível com o `cpanm` e qualquer outro instalador Perl.
Tudo o que você precisa fazer é apontar o instalador para o seu novo repositório:

```
cpanm --mirror file://$HOME/repo --mirror-only My::App
```

Isso irá construir e instalar o módulo My::App utilizando *somente* os módulos
em seu repositório Pinto. Isso significa que você terá exatamente as mesmas versões
dos módulos toda vez que realizar a instalação, mesmo que os módulos sejam removidos
ou atualizados no CPAN.

Com o cpanm, a opção --mirror-only é importante por que previne o cpanm de 
realizar buscas nos CPAN quando não encontra algum módulo em seu repositório.
Quando isso acontece, normalmente significa que algumas distribuições no
repositório não possuem todas as dependências devidamente descritas em seu
arquivo META. Para corrigir o problema, apenas utilize o comando `pull`
para buscar os módulos faltantes.

## Atualizando Módulos

Suponha que diversas semanas se passaram desde que você lançou a primeira
versão do My-App e agora o módulo URI está na versão 1.62, disponível pelo CPAN.
Ele agora possui algumas correções que você gostaria de poder ter. Novamente, podemos
trazer o novo módulo ao repositório utilizando o comando `pull`. Mas já que
o seu repositório já possui uma versão do módulo URI, você agora deve indicar que
quer uma versão <b>nova</b> especificando a versão mínima que você deseja:

```
pinto -r ~/repo pull URI~1.62
```

Se observar agora na listagem dos módulos irá ver que a nova versão do URI
já está presente:

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.62  GAAS/URI-1.62.tar.gz
rf  URI::Escape                    3.38  GAAS/URI-1.62.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.62.tar.gz
...
```

Se a nova versão do URI exigir uma nova versão de algum outro módulo adicional,
estes também serão atualizados. E quando instalar o My::App, você terá
a versão 1.62.

## Trabalhando Com Pilhas (Stacks)

Até o momento nós tratamos o repositório como uma fonte de recurso única.
Então quando atualizamos o módulo URI na última seção, afetamos todas as
pessoas e aplicações que possam estar utilizando do mesmo repositório. 
Mas esse tipo de impacto abrangente é indesejado. Você gostaria de realizar
mudanças de forma isolada e testá-las antes de forçar as outras pessoas a atualizar.
É justamente para isso que as pilhas servem.

Todo repositório do tipo CPAN possui um índice que mapeia a última versão
de cada módulo ao arquivo que a contém. Normalmente há apenas um índice por repositório.
Diferentemente, em um repositório Pinto pode haver diferentes índices. Cada índice
é chamado <b>stack</b> (ou pilha). Isso lhe permite criar diferentes <i>stacks</i> de dependências
dentro de um único repositório. Então você pode ter um <i>stack</i> "desenvolvimento" e um <i>stack</i>
"produção", ou um <i>stack</i> "perl-5.8" e outro "perl-5.16".
Toda vez que você atualiza ou adiciona um módulo, irá afetar apenas um único <i>stack</i>. 

Mas antes de seguir a diante, você precisa saber sobre o <i>stack</i> padrão.
Para a maioria das aplicações, o nome do <i>stack</i> é um parâmetro opcional.
Então se você não especificar um <i>stack</i>, então o comando é aplicado para
qualquer <i>stack</i> marcado como padrão.

Em qualquer repositório, não irá ocorrer mais de um <i>stack</i> padrão. Quando criamos
um repositório, um <i>stack</i> chamado "master" também é criado e então marcado como padrão.
Você pode alterar o <i>stack</i> padrão ou mudar o seu nome, mas eu não mexeria nisso.
Apenas lembre-se que "master" é o nome do <i>stack</i> criado com o novo repositório.

<h3>Criando Uma Pilha</h3>

Suponha que seu repositório contenha a versão 1.60 do módulo URI mas a versão
1.62 foi liberada no CPAN, como descrevemos antes. Você quer tentar atualizar
o seu repositório, mas dessa vez irá realizar isso em um <i>stack</i> separado.

Até o momento, tudo que você adicionou no repositório foi para o <i>stack</i> "master".
Então nós iremos agora criar um clone desse <i>stack</i> utilizando o comando `copy`:

```
pinto -r ~/repo copy master uri_upgrade
```

Esse comando criará um novo <i>stack</i> chamado "uri_upgrade". Se você quer ver o conteúdo
apenas utilize o comando `list` com a opção "--stack":

```
pinto -r ~/repo list --stack uri_upgrade
```

A listagem deverá ser idêntica ao "master":

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
...
```

<h3>Atualizando uma Pilha</h3>

Agora que você já possui um <i>stack</i> separado você pode tetar atualizar o módulo URI.
Assim como antes, você utilizará o comando `pull`. Mas desta vez, você dirá
que utilize o <i>stack</i> "uri_upgrade":

```
pinto -r ~/repo pull --stack uri_upgrade URI~1.62
```

Nós podemos comparar o "master" e o "uri_upgrade" utilizando o comando `diff`:

```
pinto -r ~/repo diff master uri_upgrade

+rf URI                                              1.62 GAAS/URI-1.62.tar.gz
+rf URI::Escape                                      3.31 GAAS/URI-1.62.tar.gz
+rf URI::Heuristic                                   4.20 GAAS/URI-1.62.tar.gz
...
-rf URI                                              1.60 GAAS/URI-1.60.tar.gz
-rf URI::Escape                                      3.31 GAAS/URI-1.60.tar.gz
-rf URI::Heuristic                                   4.20 GAAS/URI-1.60.tar.gz
```

A saída é similar ao comando diff(1). Registros começando por "+" foram adicionados
e aqueles que começam com "-" foram removidos. Você pode notar que os módulos da distribuição
URI-1.60 foram substituídos por módulos da distribuição URI-1.62.

<h3>Instalando a Partir da Pilha</h3>

Uma vez que tenha novos módulos na <i>stack</i> "uri_upgrade", você pode tentar
construir sua aplicação ao apontar o cpanm para aquele <i>stack</i>. Cada <i>stack</i>
é nada mais do que um subdiretório dentro do repositório, então tudo o que 
você precisa fazer é: 

```
cpanm --mirror file://$HOME/repo/stacks/uri_upgrade --mirror-only My::App
```

Se todos os testes passaram, então você agora pode atualizar o módulo URI
para a versão 1.62 na <i>stack</i> "master", utilizando o comando `pull`. Como
"master" é o <i>stack</i> padrão, você pode omitir o parâmetro "--stack": 

```
pinto -r ~/repo pull URI~1.62
```

## Trabalhando com Fixadores (Pins)

<i>stacks</i> são ótimas formas de você testar o efeito que ocorre com mudanças
nas dependências de suas aplicações. Mas e se os testes não passarem?
Se o problema reside dentro do My-App você pode rapidamente corrigi-lo,
e em seguida lançar a versão 2.0 do My-App, e então, prosseguir com a atualização
do URI no <i>stack</i> "master".

Mas e se a origem do <i>bug</i> está no URI então irá levar um bom tempo até
que o My-App seja corrigido, e você agora tem um problema.
Você não que que outra pessoa qualquer atualize o módulo URI ou que ele seja
atualizado inadvertidamente para satisfazer algum outro requisito que o My-App
possa ter. Até que você saiba que o problema fora corrigido, você precisará 
impedir que o módulo URI seja atualizado.
É para isso que os <i>pins</i> servem.

<h3>Fixando um Módulo</h3>

Quando você utiliza um <i>pin</i> (fixador) em um módulo, aquela versão do módulo é
obrigada a se manter no <i>stack</i>. Qualquer tentativa de atualizar o módulo 
(tanto diretamente quanto indiretamente) irá falhar. Para fixar um módulo,
utilize o comando `pin`:

```
pinto -r ~/repo pin URI
```

Se vocẽ observar a listagem do <i>stack</i> "master" novamente, irá observar 
algo como isso:

```
...
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf! URI                            1.60  GAAS/URI-1.60.tar.gz
rf! URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
...
```

O símbolo "!" próximo ao início do registro indica que o módulo está
fixado. Se alguém tentar atualizar o módulo URI ou adicionar uma distribuição
que exige uma versão mais nova do módulo URI, então você receberá um aviso, 
não sendo possível adicionar a nova distribuição. Note que todo módulo na
distribuição URI-1.60 está fixado, então é impossível atualizar parcialmente
a distribuição (essa situação pode acontecer quando um módulo entra em uma
distribuição diferente).

<h3>Desafixando um Módulo</h3>

Após um certo tempo, suponha que você resolveu o problema no módulo My-App
ou então uma nova versão do URI foi lançada, corrigindo o <i>bug</i>.
Nessa situação, você agora já pode desafixar o módulo URI da <i>stack</i>
através do comando `unpin`:

```
pinto -r ~/repo unpin URI
```

A partir de agora você está livre para atualizar o módulo URI para a 
última versão. Da mesma forma que acontece quando você fixa um módulo,
ao desafixá-lo, você libera também todos os módulos da distribuição.

## Utilizando Fixadores e Pilhas ao Mesmo Tempo

As pilhas e os fixadores (<i>pins</i> e <i>stacks</i>) são comumente utilizadas juntas para ajudar
a gerenciar mudanças em seu ciclo de desenvolvimento. Por exemplo você pode criar
uma <i>stack</i> chamada "prod" que contém suas dependências de confiança. Ao mesmo tempo
você pode ter também uma <i>stack</i> chamada "dev" que contém módulos experimentais para
seu próximo lançamento. Inicialmente, a <i>stack</i> "dev" é apenas uma cópia da "prod".

Ao longo do processo de desenvolvimento, você pode atualizar ou adicionar vários módulos
na pilha "dev". Se um módulo atualizado quebrar sua aplicação, então você pode colocar um <i>pin</i>
naquele módulo, dentro da <i>stack</i> "prod", sinalizando que aquele módulo não deve ser
atualizado.

<h3>Fixadores e Adendos (Patches)</h3>

Em certas situações você pode se deparar com uma nova versão de uma distribuição
no CPAN com um <i>bug</i> cujo autor é incapaz ou impossibilitado de corrigir.
Nesta situação, você pode decidir realizar um <i>patch</i> local para aquela
distribuição.

Então suponha que você realizou um <i>fork</i> do código do módulo URI e
criou uma versão local chamada URI-1.60_PATCHED.tar.gz. Você pode agora
adicioná-la ao seu repositório utilizando o comando `add`:

```
pinto -r ~/repo add path/to/URI-1.60_PATCHED.tar.gz
```

Nesta situação é aconselhável fixar o módulo, já que você não gostaria
de atualizar o módulo até que tenha certeza de que uma nova versão
do CPAN inclua o <i>patch</i> ou então o autor corrija o problema.

```
pinto -r ~/repo pin URI
```

Quando o autor do URI liberar a versão 1.62 você irá querer testá-la antes de
decidir se pode desafixar da sua versão local. Assim como antes, isso pode ser realizado
clonando o <i>stack</i> através do comando `clone`.
Desta vez vamos chamar o <i>stack</i> de "trial":

```
pinto -r ~/repo copy master trial
```

Mas antes de você poder atualizar o URI no <i>stack</i> "trial", você
deverá desafixá-lo:

```
pinto -r ~/repo unpin --stack trial URI
```

Agora você pode proceder com a atualização do URI na <i>stack</i>
e tentar construir a aplicação My::App, dessa forma:

```
pinto -r ~/repo pull --stack trial URI~1.62
cpanm --mirror file://$HOME/repo/stacks/trial --mirror-only My::App
```

Se tudo der certo, remova o <i>pin</i> do <i>stack</i> "master" e puxe
a nova versão do URI de volta.

```
pinto -r ~/repo unpin URI
pinto -r ~/repo pull URI~1.62
```

## Revisando o Histórico de Mudanças

Como você deve ter notado, cada comando que altera o estado de um <i>stack</i>
exige uma mensagem que o descreva. Você pode revisar essas mensagens
através do comando `log`:

```
pinto -r ~/repo log
```

Isso deve retornar algo do tipo:

```
revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pin GAAS/URI-1.59.tar.gz

     Pinning URI because it is not causes our foo.t script to fail

revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pull GAAS/URI-1.59.tar.gz

     URI is required for HTTP support in our application

...
```

O cabeçalho de cada mensagem mostra quem fez a mudança e quando ela aconteceu.
é possível ver também um identificador único, similar ao SHA-1 do Git. Você
pode usar esses identificadores para ver a diferença entre as revisões ou para
retornar o <i>stack</i> para um estado anterior (isso na verdade ainda não
está implementado).

## Conclusões

Neste tutorial, você viu os comandos básicos para criar um repositório Pinto
e como adicionar módulos a ele. Você viu também como utilizar os <i>stacks</i>
e os <i>pins</i> para gerenciar as sua dependências frente a alguns problemas
e obstáculos no desenvolvimento.

Cada comando possui várias opções que não foram discutidas neste tutorial,
e há ainda outros comandos que não foram mencionados aqui. Então eu o encorajo
a explorar o manual de cada comando e aprender mais.

