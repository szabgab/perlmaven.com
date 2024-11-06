---
title: "Escopo das Variáveis em Perl"
timestamp: 2013-11-28T23:14:25
tags:
  - my
  - scope
published: true
original: scope-of-variables-in-perl
books:
  - beginner
author: szabgab
translator: leprevost
---


Existem dois principais tipos de variáveis em Perl. A primeira delas é a variável global do pacote, declarada tanto com o já obsoleto
`use vars` ou com o comando `our`.

O outro tipo é a variável léxica declarada com `my`.

Vamos ver o que acontece quando você declara uma variável utilizando `my`? Em quais partes do código essa variável será visível?
Em outras palavras, qual é o <b>escopo</b> da variável?


## Escopo da Variável: Blocos de código

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $email = 'foo@bar.com';
    print "$email\n";     # foo@bar.com
}
# print $email;
# $email does not exists
# Global symbol "$email" requires explicit package name at ...
```

No interior do bloco anônimo (formado pelo par de chaves `{}`), primeiro nós vemos a declaração de uma nova variável
chamada `$email`. Esta variável existe a partir da linha de sua declaração até o final do bloco. Então isso significa
que a linha logo após o fechamento do bloco `}` precisa ser comentada. Se você remover o `#` da linha contendo
`# print $email;` e tentar rodar o script, você terá o seguinte erro:
[Global symbol "$email" requires explicit package name at ...](/simbolo-global-requer-nome-de-pacote-explicito).

Em outras palavras, o <b>escopo de toda variável declarada com o comando my é o bloco em que se encontra cercado por chaves.</b>

## Escopo da Variável: Visível em qualquer lugar

A variável `$name` é declarada no início do código, isso significa que ela será visível até o final do arquivo,
em qualquer lugar. Até mesmo dentro dos blocos, mesmo havendo declarações de funções.
Se nós alterarmos o valor da variável no interior do bloco, isso irá alterar o valor da variável no resto do código.
Mesmo quando você sai do bloco.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $lname = "Bar";
print "$lname\n";        # Bar

{
    print "$lname\n";    # Bar
    $lname = "Other";
    print "$lname\n";    # Other
}
print "$lname\n";        # Other
```


## Variáveis escondidas por outras declarações

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname = "Foo";
print "$fname\n";        # Foo

{
    print "$fname\n";    # Foo

    my $fname  = "Other";
    print "$fname\n";    # Other
}
print "$fname\n";        # Foo
```

Neste caso a variável `$fname` é declarada no início do código. Como foi dito anteriormente, ela será visível até o final
do arquivo, em qualquer parte do código, <b>exceto em lugares em que a varável fique oculta por conta de uma declaração de uma
nova variável com o mesmo nome</b>.

Dentro do bloco nós utilizamos `my` para delcarar uma nova variável com o mesmo nome. Isso irá efetivamente esconder a variável
`$fname` declarada fora do bloco, até o momento da saída do mesmo. Ao chegar ao final do bloco (no sinal de fechamento `}`,
a variável `$fname` declarada dentro do bloco será destruída e a original `$fname` será acessível novamente.
Esta característica é especialmente importante pois faz com que seja fácil criar variáveis dentro de pequenos escopos sem que haja necessidade
de pensar nas implicações de se usar variáveis com o mesmo nome de outras declaradas por fora.

## Mesmo nome em múltiplos blocos

Você pode usar livremente o mesmo nome das variáveis em múltiplos blocos. Estas variáveis não possuirão conexão alguma entre elas. 

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $name  = "Foo";
    print "$name\n";    # Foo
}
{
    my $name  = "Other";
    print "$name\n";    # Other
}
```

## Declarações dentro de arquivos pacotes

Este é um exemplo um pouco mais avançado, mas é importante mencioná-lo aqui:

O Perl nos permite alterar entre <b>name-spaces</b> usando o comando `package` dentro de um arquivo.
A declaração de um pacote <b>NÃO</b> provê um novo escopo. Se você declarar uma variável no 
<b>pacote main</b>, que acaba sendo apenas o corpo do seu script, a variável `$fname`
será visível até mesmo em outros <b>name-spaces</b>, no mesmo arquivo.

Se você declarar uma variável chamada <h>$lname` no 'Outro' name-space, a mesma será visível 
quando depois, você alterar para o name-space `main`. Se a declaração do 'Outro' pacote estiver 
em uma arquivo diferente, então as variáveis estarão separadas em diferentes escopos, criados pelos arquivos.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname  = "Foo";
print "$fname\n";    # Foo

package Other;
use strict;
use warnings;

print "$fname\n";    # Foo
my $lname = 'Bar';
print "$lname\n";    # Bar


package main;

print "$fname\n";    # Foo
print "$lname\n";    # Bar
```
