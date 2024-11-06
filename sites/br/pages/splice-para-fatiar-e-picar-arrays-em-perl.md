---
title: "Splice para fatiar e picar arrays em Perl"
timestamp: 2013-04-30T17:05:56
tags:
  - splice
  - array
published: true
original: splice-to-slice-and-dice-arrays-in-perl
books:
  - advanced
author: szabgab
translator: aramisf
---


Depois de aprender sobre <a href="https://perlmaven.com/manipulating-perl-arrays">pop, push, shift,
and unshift</a>, estudantes às vezes me perguntam como remover um elemento do
meio de um array.

Eu geralmente não tenho tempo para explicar isto. Existem outras coisas a
ensina-los, que parecem ser mais importantes que `splice()` no tempo
limitado que temos, mas geralmente eu ao menos aponto-lhes a direção correta.

Desta vez isto será muito mais fácil dado que você, o(a) leitor(a), pode decidir se
gostaria de investir seu tempo extra.


## Como remover um elemento do meio de um array em Perl?

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 2;
print "@dwarfs";    # Doc Grumpy Happy Dopey Bashful
```

Como você pode ver o 4o e 5o elementos do array foram removidos.
Isto ocorre porque o segundo parâmetro do <b>splice</b> é o offset do primeiro
elemento a ser removido, e o terceiro parâmetro é o número de elementos a ser
removido.

## Como inserir um elemento no meio de  um array em Perl?

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, 'SnowWhite';
print "@dwarfs";
# Doc Grumpy Happy SnowWhite Sleepy Sneezy Dopey Bashful
```

Nesse caso nós usamos `splice` para inserir um elemento.
Normalmente o segundo parâmetro (o offset) define onde inicia a remoção de
elementos, mas neste caso o terceiro parâmetro - o número de elementos - foi 0
então `splice` não removeu nenhum elemento. Em vez disso, o offset é
usado como a posição para inserir algo novo: o valor passado como 4o parâmetro
para `splice`.

Assim é como SnowWhite terminou entre os sete anões.

## Como inserir uma lista de valores em um array em Perl?

Inserir um elemento é na verdade apenas um caso especial de inserção de vários
elementos.

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, 'SnowWhite', 'Humbert';
print "@dwarfs";

# Doc Grumpy Happy SnowWhite Humbert Sleepy Sneezy Dopey Bashful
```

Neste caso depois do 3o parâmetro temos vários valores (2 neste caso).
Eles são todos inseridos no array.

## Como inserir um array no meio de outro array em Perl?

O mesmo aconteceria se passássemos um array como o 4o parâmetro:

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 3, 0, @others;
print "@dwarfs";
```


## Substituir parte de um array com alguns outros valores

Você pode também adicionar e remover elementos em um único comando:

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
splice @dwarfs, 2, 4, @others;
print "@dwarfs\n";

# Doc Grumpy SnowWhite Humbert Bashful
```

Neste caso nós removemos quatro dos anões e os substituimos por duas pessoas
de tamanho natural: SnowWhite e Humbert o Caçador.

## splice

Splice é a função definitiva para modificar arrays em Perl.
Você pode remover qualquer seção de um array e substitui-la por qualquer outra
lista de valores.
O número de elementos removidos pode ser diferente, e qualquer um deles pode
ser 0 também.

A sintaxe padrão da função tem os seguintes parâmetros, apesar de todas as
partes (bem, exceto pelo array propriamente dito) são opcionais:

```perl
splice ARRAY, OFFSET, LENGTH, LIST
```

OFFSET e LENGTH definem a seção no ARRAY que será removida.
Ambos são (números) inteiros. LIST é uma lista de valores que será inserida no lugar da
seção que foi removida. Se LIST não é fornecida, ou é vazia, então splice vai
apenas remover itens mas não vai inserir nenhum.

## Valores de Retorno

Dentro do <b>contexto LIST</b> splice retorna os elementos removidos do
array.

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, 3, 2, @others;
print "@who\n";

# Sleepy Sneezy
```

Dentro do <b>contexto SCALAR</b>, splice retorna o último elemento removido,
ou undef caso nenhum elemento tenha sido removido.

```perl
my @others = qw(SnowWhite Humbert);
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my $who = splice @dwarfs, 3, 2, @others;
print "$who\n";

# Sneezy
```

## Parâmetros Negativos

Ambos offset e length podem ser números negativos. Em cada caso, isso
significa "conte a partir do final do array".

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, 3, -1;
print "@who";

# Sleepy Sneezy Dopey
```

Isso significa, deixe 3 intactos e então remova (e retorne) todos os elementos
até 1 antes do fim.

```perl
my @dwarfs = qw(Doc Grumpy Happy Sleepy Sneezy Dopey Bashful);
my @who = splice @dwarfs, -3, 1;
print "@who";

# Sneezy
```

Isso significa: "Conte 3 a partir do final e remova (e retorne) 1 elemento
iniciando deste ponto.

## Conclusão

Espero que ao menos parte disto lhe ajude a entender melhor como
`splice` opera arrays em Perl.
