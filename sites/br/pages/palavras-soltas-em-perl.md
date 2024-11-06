---
title: "Palavra solta (bareword) em Perl"
timestamp: 2013-04-08T14:45:56
tags:
  - bareword
  - strict
published: true
original: barewords-in-perl
books:
  - beginner
author: szabgab
translator: fredlopes
---


`use strict` tem 3 partes. Uma delas, também chamada de `use strict "subs"`, desabilita o uso inapropriado de <b>palavras soltas (barewords)</b>.

O que isso significa?


Sem essa restrição, um código como o seguinte seria executado e imprimiria "oi".

```perl
my $x = oi;
print "$x\n";    # oi
```

Isso é estranho por si só, uma vez que estamos acostumados a colocar cadeias de caracteres entre aspas, mas a Perl, por padrão, permite que <b>palavras soltas</b> - palavras sem aspas - funcionem como cadeias de caracteres.

O código acima imprimiria "oi".

Bem, pelo menos até alguém adicionar uma subrotina chamada "oi" no começo de seu programa:

```perl
sub oi {
  return "zzz";
}

my $x = oi;
print "$x\n";    # zzz
```

Agora sim. Nessa versão, perl vê a subrotina oi(), chama-a e atribui seu valor de retorno a $x.

Agora, se alguém move a subrotina para o fim do arquivo, para depois da atribuição, perl acaba não vendo a subrotina no momento da atribuição, e então estamos de volta com "oi" em $x.

Não, você não quer entrar nessa bagunça por acidente, e provavelmente nunca vai querer. Com `use strict` em seu código, perl não permitirá aquela palavra solta <b>oi</b>, evitando esse tipo de confusão.

```perl
use strict;

my $x = oi;
print "$x\n";
```

Isso produz o seguinte erro:

```
Bareword "oi" not allowed while "strict subs" in use at script.pl line 3.
Execution of script.pl aborted due to compilation errors.
(Palavra solta "oi" não permitida enquanto "strict subs" está em uso em script.pl na linha 3.
Execução de script.pl abortada devido a erros de compilação.)
```

## Bons usos de palavras soltas

Há outros lugares onde palavras soltas podem ser usadas mesmo quando `use strict "subs"` está agindo.

Primeiro, os nomes das rotinas que criamos são, de fato, apenas palavras soltas. É bom ter isso.

E ainda, quando estamos fazendo referência a um elemento de um hash, podemos usar palavras soltas dentro das chaves, e palavras no lado esquerdo da seta gorda => também podem ser deixadas sem aspas:

```perl
use strict;
use warnings;

my %h = ( nome => 'Zé' );

print $h{nome}, "\n";
```

Em ambos os casos no código acima, "nome" é uma palavra solta, mas essas são permitidas mesmo quando use strict está habilitado.



