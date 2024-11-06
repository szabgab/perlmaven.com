---
title: "Funções para Manipular Texto: length, lc, uc, index, substr"
timestamp: 2013-04-12T10:17:24
tags:
  - length
  - lc
  - uc
  - index
  - substr
  - scalar
  - texto
published: true
original: string-functions-length-lc-uc-index-substr
books:
  - beginner
author: szabgab
translator: leprevost
---


Nesta parte do [Tutorial Perl](/perl-tutorial) nós iremos aprender
sobre algumas das funções que o Perl possui para manipular textos.


## lc, uc, length

No Perl podemos encontrar uma série de funções tais como <b>lc</b> e <b>uc</b>
que retornam respectivamente versões em caixa baixa e caixa alta dos textos originais.
Há também <b>length</b> que retorna o número de caracteres de um dado texto.

Veja os exemplos abaixo:

```perl
use strict;
use warnings;
use 5.010;

my $str = "tEXtO";

say lc $str;      # texto
say uc $str;      # TEXTO
say length $str;  # 5
```


## index

Há também a função <b>index</b>. Esta função recebe dois textos e retorna a posição
do segundo texto dentro do primeiro.

```perl
use strict;
use warnings;
use 5.010;

my $str = "O gato preto pulou da árvore verde";

say index $str, 'gato';            # 2
say index $str, 'cachorro';        # -1
say index $str, "O";               # 0
say index $str, "o";               # 5
say index $str, "árvore";          # 22
```

A primeira chamada à função `index` retornou 2, porque o texto 'gato' inicia no segundo caractere.
A segunda chamada à função `index` retornou -1 indicando que não existe a palavra 'cachorro' no texto.

A terceira chamada demonstra que a função retorna 0 quando o segundo texto é prefixo do primeiro texto.

É importante ressaltar também que a caixa do texto faz diferença para a função.

`index()` procura também por textos e não apenas palavras, isso significa que até mesmo o texto 'e' pode ser procurado:

```perl
say index $str, "e";              # 9
```

A função `index` também pode possuir um terceiro parâmetro que indica a posição onde busca deve iniciar.
Como vimos no caso do texto 'e' que inicia no nono caractere do primeiro texto, nós podemos
tentar iniciar a busca a partir do vigésimo sétimo caractere para ver se há mais alguma ocorrência do 'e'.

```perl
say index $str, "e";               # 9
say index $str, "e ", 27;          # 28
```

Buscando por 'e' sem o espaço resultará em um valor diferente.

Finalmente há ainda uma outra função chamada <b>rindex</b>, conhecido como índice direito 
(right index), que irá começar a busca pelo lado direito do texto:

```perl
say rindex $str, "e";              # 34
say rindex $str, "e", 30;          # 28
```

## substr

Eu acho que a função mais interessante neste artigo é a `substr`.
Ela atua basicamente de forma oposta ao `index()`. Enquanto que o `index()`
irá lhe dizer <b>aonde está um determinado texto</b>, `substr` irá lhe retornar <b>uma parte do texto
em uma determinada posição</b>.
Normalmente a função `substr` recebe três parâmetros, o primeiro é o texto, o segundo é a
posição de início (também conhecida como <i>offset</i>) e o terceiro é o <b>tamanho</b> da parte ou
fragmento do texto que deseja recuperar.

```perl
use strict;
use warnings;
use 5.010;

my $str = "O gato preto subiu na árvore verde";

say substr $str, 7, 5;                      # preto
```

A substr() inicia pela posição 0, portanto o caractere no <i>offset</i> 7 é a letra p.

```perl
say substr $str, 2, -12;                    # gato preto subiu na
```

O terceiro parâmetro (o tamanho) pode também ser um valor negativo. Neste caso ele nos retorna
o número de caracteres a partir do lado direito do texto original que NÃO deverá ser incluído.
Ou seja, conte 2 a partir da esquerda, 11 a partir da direita e retorne o que há no meio.

```perl
say substr $str, 13;                        # subiu na árvore verde
```

Você pode também ignorar o terceiro parâmetro, que significa:
retorne todos os caracteres iniciando na quarta posição e seguindo até o final do texto.

```perl
say substr $str, -5;                        # verde
say substr $str, -5, 2;                     # ve
```

Nós podemos também utilizar um número negativo no <i>offset</i>, o que significa:
Contar cinco a partir da direita e iniciar a partir dessa posição. É o equivalente a ter
`length($str)-4` no <i>offset</i>. 

## Substituindo parte de um texto

O último exemplo é um pouco mais estiloso.
Até o momento, em todos os casos `substr` retornou uma parte do texto
e deixou o texto original intacto. Neste exemplo, o valor de retorno da função continuará 
sendo o mesmo, porém a função `substr` também irá alterar o conteúdo do texto original!

O valor de retorno da `substr` é sempre determinado pelos três primeiros parâmetros,
mas neste caso a função possuirá um quarto parâmetro. Esse novo elemento será um texto
que irá substituir a região selecionada do texto original.

```perl
my $z = substr $str, 13, 5, "pulou";
say $z;                                                     # subiu
say $str;                  # O gato preto pulou na árvore verde
```

Portanto `substr $str, 13, 5, "pulou na"` retorna a palavra <b>subiu</b>,
mas por causa do quarto parâmetro, o texto original foi alterado.

