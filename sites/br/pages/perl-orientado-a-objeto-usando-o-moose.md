---
title: "Perl Orientado a Objeto usando o Moose"
timestamp: 2013-04-29T23:10:05
tags:
  - OOP
  - Moose
  - object oriented
  - class
  - object
  - instance
  - constructor
  - getter
  - setter
  - accessor
published: true
original: object-oriented-perl-using-moose
books:
  - advanced
author: szabgab
translator: aramisf
---


Nos próximos artigos nós vamos aprender como programar em Perl com Orientação a
Objetos.
Vamos começar com alguns exemplos simples e vamos extende-los passo a passo.
Começamos usando o Moose mas vamos também aprender como criar classes por
outros meios.


## Um construtor com o Moose

Comecemos por escrever um script simples que usa a `classe` Person.
Não fazemos nada especial ainda, apenas carregamos o módulo e chamamos o
`construtor` para criar uma `instância`.

```perl
use strict;
use warnings;
use v5.10;

use Person;
my $teacher = Person->new;
```

Salve isto em somedir/bin/app.pl

Isto não deve ser novo para você, pois estou certo de que você já usou outros
módulos de maneira similar. Nosso foco é em como a classe Person foi
implementada:

```perl
package Person;
use Moose;

1;
```

É isto.

Esse código é gravado em somedir/lib/Person.pm.

Tudo o que você precisa fazer para criar uma `classe` é criar um
`pacote` com o nome da classe, adicionar `use Moose;` a ele,
terminar o arquivo com um valor verdadeiro, e salvar em um arquivo com o mesmo
nome (sensível ao caso!) do pacote, e com a extensão .pm.

Carregar o Moose define automaticamente `use strict` e ` use
warnings`.
Isto é legal, mas cuidado para não se acostumar com essa conveniência e
esquecer de usá-los quando não estiver usando o Moose.

Carregar o Moose também adiciona automaticamente o construtor padrão chamado
`new`.

Uma observação, em Perl não é um requisito que o construtor seja chamado new,
mas na maioria dos casos é o que o autor acaba escolhendo.


## Atributos e acessores

Ter uma classe vazia não é muito divertido. Vamos avançar um pouco em nosso
uso:

```perl
use strict;
use warnings;
use v5.10;

use Person;
my $teacher = Person->new;

$teacher->name('Joe');
say $teacher->name;
```

Neste código, depois de criar o `objeto`, chamamos o `método`
"name" com uma string como parâmetro; isso define o `atributo` "name"
da classe como 'Joe'. Uma vez que este método define seu respectivo atributo, ele é
também chamado de `setter`.

Então chamamos o mesmo método novamente, desta vez sem parâmetro algum. Isto
vai buscar o valor previamente armazenado. Uma vez que obtém um valor, este
método também é chamado `getter`.

Em nosso caso o `getter` e o `setter` possuem o mesmo nome mas
isso também não é requisito.

Em geral `getters` e `setters` são chamados `acessores`.

O código que implementa a nova classe é este:

```perl
package Person;
use Moose;

has 'name' => (is => 'rw');

1;
```

A parte nova, `has 'name' => (is => 'rw');` diz que

"A classe Person `tem` um atributo chamado `'name'` que tem as
`permissões` de leitura(`r`) e escrita(`w`)"

Isso cria automaticamente um método chamado "name" que se torna ao mesmo tempo
um setter (para escrita) e um getter (para leitura).

## Execute o código

Com o intuito de executar este exemplo crie um diretório chamado "somedir",
com um subdiretório chamado "lib" dentro dele, e salve o arquivo Person.pm
dentro do subdiretório "lib". Crie também um subdiretório chamado "bin" e
salve lá o script chamado person.pl.

Você deve ter

```
somedir/lib/Person.pm
somedir/bin/person.pl
```

Abra um terminal (ou a janela do cmd no Windows), acesse o diretório "somedir"
e digite `perl -Ilib bin/person.pl`

(No MS Windows você pode precisar usar contra-barras: \ )

## Parâmetros do construtor

No próximo script nós passamos um par chave-valor para o construtor,
correspondentes ao nome do atributo e seu valor.

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $teacher = Person->new( name => 'Joe' );
say $teacher->name;
```

Isso também funciona com o mesmo módulo da mesma forma como tínhamos:

Usando o construtor dessa maneira para definir o valor inicial de um atributo
funciona sem fazer qualquer mudança no módulo Person.

O Moose aceita automaticamente todo `membro` (outro nome para os
atributos) a ser passado durante a construção.

