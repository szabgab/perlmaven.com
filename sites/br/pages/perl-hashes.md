---
title: "Hashes em Perl"
timestamp: 2013-05-31T01:35:06
tags:
  - hash
  - keys
  - value
  - associative
  - %
  - =>
  - fat arrow
  - fat comma
published: true
original: perl-hashes
books:
  - beginner
author: szabgab
translator: aramisf
---


Neste artigo do  [Perl Tutorial](/perl-tutorial) vamos aprender
sobre <b>hashes</b>, uma das mais poderosas partes do Perl.

Por vezes chamadas de arrays associativos, dicionários ou mapeamentos; as
hashes são uma das estruturas de dados disponíveis no Perl.


Uma hash é um grupo não ordenado de pares chave-valor. As chaves são strings
únicas. Os valores são valores escalares. Cada valor pode ser um número, uma
string, ou uma referência. Vamos aprender sobre referências mais tarde.

Hashes, como outras variáveis do Perl, são declaradas usando a palavra
reservada `my`. O nome da variável é precedido pelo sinal de
porcentagem (`%`).

É um pequeno truque mnemônico para lhe ajudar a lembrar da estrutura
chave-valor.

Alguns pensam que as hashes são como arrays (o nome antigo 'array associativo'
também indica isso, e em algumas outras linguagens, tais como PHP, não há
diferença entre arrays e hashes.), mas existem duas principais diferenças
entre arrays e hashes. Arrays são ordenados, e você pode acessar um elemento
de um array usando seu índice numérico. Hashes não são ordenadas e o acesso a
um valor se dá por uma string, que é a chave.

Cada chave de uma hash está associada a um único <b>valor</b> e as chaves são
todas únicas dentro de uma mesma hash. Isso significa que não são permitidas
chaves repetidas. (se você quer muito ter mais de um valor por chave, você
terá que esperar um pouco, até chegarmos às referências.)

Vejamos um pouco de código:

## Criando uma hash vazia

```perl
my %color_of;
```

## Inserir um par chave-valor em uma hash

Neste caso 'maca' é a chave e 'vermelha' é o valor associado.

```perl
$color_of{'maca'} = 'vermelha';
```

Você pode usar também uma variável ao invés da chave, e então você não precisa
colocar a variável entre aspas:

```perl
my $fruit = 'maca';
$color_of{$fruit} = 'vermelha';
```

Na verdade, se a chave for uma string simples, você pode deixar de colocar
aspas mesmo quando usar a string diretamente:

```perl
$color_of{maca} = 'vermelha';
```

Como você pode ver acima, ao acessar um par chave-valor específico, nós usamos
o sinal `$` (e não o sinal `%`) porque estamos acessando um
valor único que é um <b>escalar</b>. A chave é colocada entre chaves ({ }).

## Buscar um elemento de uma hash

Do mesmo modo como inserimos um elemento, também podemos obter o valor de um
elemento.

```perl
print $color_of{maca};
```

Se a chave não existir, a hash retornará um <a
href="/undef-e-definido-em-perl">undef</a>, e se `warnings` estiver
habilitado, como deveria estar, então nós receberemos um aviso sobre um <a
href="/uso-de-valor-nao-inicializado">valor não iniciado</a>.

```perl
print $color_of{laranja};
```

Vejamos mais alguns pares chave-valor para a hash:

```perl
$color_of{laranja} = "laranja";
$color_of{uva} = "lilas";
```

## Inicie a hash com valores

Nós poderíamos ter instanciado a variável com pares chave-valor passando
simultaneamente para a hash uma lista de pares chave-valor:

```perl
my %color_of = (
    "maca"  => "vermelha",
    "laranja" => "laranja",
    "uva"  => "lilas",
);
```

`=>` é chamado <b>flecha espessa</b> ou <b>vírgula espessa</b>, e é
usada para indicar pares de elementos. O primeiro nome, flecha espessa, fica
claro uma vez que olhamos a outra, flecha fina (->) usada no Perl. O nome
vírgula espessa vem do fato de que essas flechas são basicamente o mesmo que
as vírgulas. Então poderíamos ter escrito assim também:

```perl
my %color_of = (
    "maca",  "vermelha",
    "laranja", "laranja",
    "uva",  "lilas",
);
```

Na realidade, a flecha espessa lhe permite abandonar as aspas do lado
esquerdo, fazendo com que o código fique mais limpo e legível.

```perl
my %color_of = (
    maca  => "vermelha",
    laranja => "laranja",
    uva  => "lilas",
);
```

## Atribuição em um elemento de uma hash

Vejamos o que acontece quando atribuímos outro valor para uma chave existente:

```perl
$color_of{maca} = "green";
print $color_of{maca};     # green
```

A atribuição modificou o valor associado com a chave <b>maca</b>. Lembre-se,
chaves são únicas e cada chave tem um único valor.

## Iterando sobre hashes

Para acessar um valor em uma hash você precisa conhecer a chave.
Quando as chaves de uma hash não são valores pré-definidos você pode usar a
função `keys` para obter uma lista de chaves. Então você pode iterar
sobre estas chaves:

```perl
my @fruits = keys %color_of;
for my $fruit (@fruits) {
    print "The color of '$fruit' is $color_of{$fruit}\n";
}
```

Você nem precisa utilizar a variável temporária `@fruits`, você pode
iterar diretamente sobre os valores retornados pela função `keys`:

```perl
for my $fruit (keys %color_of) {
    print "The color of '$fruit' is $color_of{$fruit}\n";
}
```


## O tamanho de uma hash

Quando dizemos o tamanho de uma has, geralmente nos referimos ao número de
pares chave-valor. Você pode obter este valor colocando a função `keys`
no contexto escalar.

```perl
print scalar keys %hash;
```

## Obrigado

A primeira edição deste artigo foi escrita por <a
href="http://www.leprevost.com.br/">Felipe da Veiga Leprevost</a> que também
faz [traduções em Português](https://br.perlmaven.com/) dos artigos
Perl Maven.

