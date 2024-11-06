---
title: "Tipos de atributos em classes Perl usando o Moose"
timestamp: 2013-04-30T18:13:10
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
  - attribute
published: true
original: attribute-types-in-perl-classes-when-using-moose
books:
  - advanced
author: szabgab
translator: aramisf
---


Em um script Perl simples nós não costumamos nos preocupar muito com os tipos
dos valores, mas ao passo que a aplicação cresce, um tipo do sistema pode
melhorar a corretude da aplicação.

O Moose permite que você defina um tipo para cada atributo e então força esses
tipos através dos <i>setters</i>.


Depois da primeira <a href="https://perlmaven.com/object-oriented-perl-using-moose">introdução ao
Perl Orientado a Objetos com o Moose</a>, você provavelmente deve estar
familiarizado com o sistema de verificação de tipo do Moose.

## Defina o tipo para ser Int

Este é nosso primeiro script amostral:

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $student = Person->new( name => 'Joe' );
$student->year(1988);
say $student->year;
$student->year('23 years ago');
```

Depois de carregar o módulo Person (a classe), nós criamos o objeto $student
atráves da chamada do construtor de classe "new".
Então nós chamamos o acessador "year" e definimos o valor para 1998. Depois de
imprimir o valor nós tentamos defini-lo como "23 years ago".

No módulo você pode ver dois atributos. O atributo "year" tem uma entrada
`isa` com um valor `Int`. Por causa disso, o <i>setter</i>
criado pelo Moose vai restringir para inteiros os valores que ele aceita.

```perl
package Person;
use Moose;

has 'name' => (is => 'rw');
has 'year' => (isa => 'Int', is => 'rw');

1;
```

Salve o módulo em "somedir/lib/Person.pm" e salve o script em
"somedir/bin/app.pl" então de dentro do diretório somedir rode o script com
"perl -Ilib bin/app.pl"

Depois de imprimir o valor 1988, nós recebemos o seguinte erro:

```
Attribute (year) does not pass the type constraint because:
   Validation failed for 'Int' with value "23 years ago"
       at accessor Person::year (defined at lib/Person.pm line 5) line 4
   Person::year('Person=HASH(0x19a4120)', '23 years ago')
       called at script/person.pl line 13
```

Esta mensagem de erro mostra que o Moose não aceitou a string "23 anos atrás"
como um Integer.

## Outra classe como restrição de tipo

Apesar dos
<a href="https://metacpan.org/pod/Moose::Util::TypeConstraints#Default-Type-Constraints">tipos
de restrição padrão</a>, o Moose também permite que você use o nome de
qualquer classe existente como restrição de tipo.

Por exemplo você pode declarar que o atributo "birthday" deve ser um objeto do
tipo DateTime.

```perl
package Person;
use Moose;

has 'name'     => (is => 'rw');
has 'birthday' => (isa => 'DateTime', is => 'rw');

1;
```

Tente o script exemplo:

```perl
use strict;
use warnings;
use v5.10;

use Person;
use DateTime;

my $student = Person->new( name => 'Joe' );
$student->birthday( DateTime->new( year => 1988, month => 4, day => 17) );
say $student->birthday;
$student->birthday(1988);
```

Você pode ver, a primeira chamada ao <i>setter</i> "birthday" recebe um objeto
DateTime criado localmente. Esta chamada funciona bem. A segunda chamada
recebe o número 1988 e gera uma exceção similar à anterior:

```
Attribute (birthday) does not pass the type constraint because:
    Validation failed for 'DateTime' with value 1988
       at accessor Person::birthday (defined at lib/Person.pm line 5) line 4
    Person::birthday('Person=HASH(0x2143928)', 1988)
       called at script/person.pl line 14
```

