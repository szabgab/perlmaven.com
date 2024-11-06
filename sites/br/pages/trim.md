---
title: "trim - removendo espaços em branco à esquerda e à direita com Perl"
timestamp: 2013-05-31T00:10:01
tags:
  - trim
  - ltrim
  - rtrim
published: true
original: trim
books:
  - beginner
author: szabgab
translator: aramisf
---


Em algumas outras linguagens existem funções chamadas <b>ltrim</b> e
<b>rtrim</b> para remover espaços e tabulações do início e do final de uma
string, respectivamente. Ás vezes elas tem a função chamada <b>trim</b> para
remover espaços em branco de ambos os lados de uma string.

Não existem tais funções em Perl (embora eu esteja convecido de que existem
diversos módulo do CPAN que implementam essas funções) pois uma simples
substituição por expressão regular pode resolver isso.

Na verdade é tão simples que isto é um dos grandes assuntos da <a
href="https://en.wikipedia.org/wiki/Parkinson%27s_law_of_triviality">Lei da
Trivialidade de Parkinson</a> (em inglês. O conceito consiste basicamente em 
superestimar ou aumentar demasiadamente a complexidade de tarefas simples).



## trim à esquerda

<b>ltrim</b>  ou <b>lstrip</b> remove espaços em branco do lado esquerdo de uma string:

```perl
$str =~ s/^\s+//;
```

Do início da stringo `^` pegue 1 ou mais espaços em branco
(`\s+`), e troque-os por uma string vazia.

## trim à direita

<b>rtrim</b> ou <b>rstrip</b> remove espacos em branco da direita de uma string:

```perl
$str =~ s/\s+$//;
```

Pegue 1 ou mais espaços (`\s+`) até o final da string (`$`), e
troque-os por uma string vazia.

## trim em ambos os lados

<b>trim</b> remove o espaço em branco de ambos os lados de uma string:

```perl
$str =~ s/^\s+|\s+$//g
```

As duas expressões regulares acima foram unidas com uma marca de alternação
`|` em nós adicionamos um `/g` ao final para efetuar a
substituição <b>globalmente</b> (repetidas vezes).

## Escondendo em funções

Se você não quer ver estes contructos no seu código, você pode adicionar a ele essas
funções:

```perl
sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
```

e usá-las assim:

```perl
my $z = " abc ";
printf "<%s>\n", trim($z);   # <abc>
printf "<%s>\n", ltrim($z);  # <abc >
printf "<%s>\n", rtrim($z);  # < abc>
```


## String::Util

Se você realmente não quer copiar aquilo, você pode sempre instalar um módulo.

Por exemplo <a
href="https://metacpan.org/pod/String::Util">String::Util</a> provê uma
função chamada `trim` que você pode usar dessa forma:

```perl
use String::Util qw(trim);

my $z = " abc ";
printf "<%s>\n", trim( $z );              # <abc>
printf "<%s>\n", trim( $z, right => 0 );  # <abc >
printf "<%s>\n", trim( $z, left  => 0 );   # < abc>
```

Por padrão ela apara ambos os lados e você tem que desligar a aparagem. Penso
eu que ter o seu próprio `ltrim` e `rtrim` será mais claro.

## Text::Trim

Outro módulo, um que provê todas as 3 funções é o <a
href="https://metacpan.org/pod/Text::Trim">Text::Trim</a>, mas ele leva o
estilo Perl de escrever um passo adiante, e talvez para lugares ligeiramente
perigosos.

Se você chama-lo e usar o valor de retorno em uma instrução print ou atribuir
tal valor a uma variável, ele vai retornar uma versão aparada da string e vai
manter o original intacto.

```perl
use Text::Trim qw(trim);

my $z = " abc ";
printf "<%s>\n", trim($z);  # <abc>
printf "<%s>\n", $z;       # < abc >
```

Por outro lado, se você chama-lo em um contexto VAZIO, ou seja, quando você
não utiliza o valor de retorno, a função trim muda seu parâmetro, de um jeito
parecido com o comportamento do [chomp](/perldoc/chomp).

```perl
use Text::Trim qw(trim);

my $z = " abc ";
trim $z;
printf "<%s>\n", $z;       # <abc>
```

