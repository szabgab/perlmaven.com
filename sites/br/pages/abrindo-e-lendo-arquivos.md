---
title: "Abrindo e Lendo Arquivos de Texto"
timestamp: 2013-04-25T10:40:56
tags:
  - open
  - <$fh>
  - read
  - <
  - encoding
  - UTF-8
  - die
  - open or die
published: true
original: open-and-read-from-files
books:
  - beginner
author: szabgab
translator: leprevost
---


Nesta parte do [tutorial Perl](/perl-tutorial) nós iremos ver <b>como ler arquivos de texto em Perl</b>.

Por enquanto iremos focar apenas nos arquivos de texto.

Existem duas formas tradicionais de abrir um arquivo dependendo da forma como você quer
lifar com o tratamento de erros.

## Exceções

Caso 1: Lance uma exceção caso não consiga abrir o arquivo:

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Não foi possível abrir o arquivo '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
```

## Alerta ou nenhum aviso

Caso 2: Receber apenas um aviso caso o arquivo não possa ser aberto, mas mantenha o código executando:

```perl
use strict;
use warnings;

my $filename = 'data.txt';
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Não foi possível abrir o arquivo '$filename' $!";
}
```

## Explicações

Vamos ver as explicações dos casos:

Primeiramente, utilizando um editor de textos, crie um arquivo chamado 'data.txt' e adicione algumas linhas a ele:

```
Primeira linha
Segunda linha
Terceira linha
```

Abrir um arquivo para leitura é muito parecido com o que fizemos quando 
[vimos como abrir um arquivo para escrita](/escrevendo-em-arquivos-com-perl),
porém ao invés de utilizar o sinal "maior do que" (`>`), nós iremos utilizar o
o sinal "menor do que" (`<`).

Desta vez também estamos definindo a codificação para UTF-9. Masn na maioria dos casos,
você irá apenas encontrar o sinal "menor do que".

```perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Não foi possível abrir o arquivo '$filename' $!";

my $row = <$fh>;
print "$row\n";
print "pronto\n";
```

Após ter o <i>filehandle</i> nós podemos então ler a partir dele, utilizando o mesmo
operador de leitura de linhas, o <i>readline</i>,  
[para leitura do teclado (STDIN)](/instalando-o-perl).
Assim conseguiremos ler a primeira linha do arquivo.
Em seguida nós imprimimos o conteúdo da variável `$row` e depois "pronto" apenas
para que fique evidente que chegamos até o final do nosso exemplo.

Se você executar o script acima verá o seguinte ser impresso:

```
Primeira linha

pronto
```
Por que existe uma linha vazia antes do "pronto", você pode se perguntar.

Isso ocorre porque o operador <i>readline</i> lê a linha inteira, incluíndo o caractere
especial de nova linha. Quando nós utilizamos a função `print`, acabamos incluíndo 
um segundo caractere de nova linha.

Da mesma forma que ocorre quando lemos algo a partir do STDIN, nós normalmente não precisamos
o caractere final indicando uma nova linha, então podemos usar a função `chomp()` para removê-lo.

## Lendo mais de uma linha

Agora que já sabemos como ler uma linha, podemos segui a diante e colocar o <i>readline</i>
dentro de um laço `while`.

```perl
use strict;
use warnings;

my $filename = $0;
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Não foi possível abrir o arquivo '$filename' $!";

while (my $row = <$fh>) {
  chomp $row;
  print "$row\n";
}
print "pronto\n";
```

Toda vez que atingimos a condicional do laço  `while`, primeiro será executado 
`my $row = <$fh>`, a parte que irá ler a próxima linha do arquivo.
Se existir alguma coisa nessa linha, a condicional será avaliada como VERDADEIRA.
Até mesmo linhas vazias possuem caracteres especiais de nova linha, isso significa que 
ao ler essas linhas a variável `$row` irá conter o `\n` que irá ser avaliado
como VERDADEIRO em contexto booleano.

Após ler a última, na próxima iteração do laço o operador <i>readline</i> (`<$fh>`) irá
retornar undef que então é avaliado como FALSO. Sendo assim o laço while termina.

<h3>Casos extremos</h3>

Em determinados casos, existe a possibilidade do arquivo possuir um 0 em sua última linha.
O código acima, iria neste caso, avaliar a última linha como FALSO e o laço não seria mais executado.
Felizmente, o Perl acaba trapaceando nessa situação. Neste caso específico (ler uma linha de um arquivo
dentro de um laço while), o perl atua como se você tivesse escrito `while (defined my $row = <$fh>) {` 
fazendo com que até mesmo essas linhas sejam executadas corretamente.

## Abrindo o arquivo sem matar o script

A forma descrita acima de abrir arquivos é utilizada em scripts Perl onde você 
deve obrigatoriamente ter um arquivo para ser lido.
Por exemplo quando o objetivo do código é parsear aquele arquivo.

Mas e se for um arquivo de configuração opcional? Se você conseguir ler o arquivo então
você altera seu conteúdo, caso não consiga utilizará os valores padrões.

Neste caso a segunda solução apresentada acima pode ser a melhor forma de escrever o seu código.

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
} else {
  warn "Não foi possível abrir o arquivo '$filename' $!";
}
```

Neste caso avaliamos o valor de retorno da função `open`.
Se for VERDADEIRO, nós lemos o seu conteúdo.

Se falhar nós apenas recebemos um aviso utilizando a função `warn`
mas sem lançar uma exceção, nós não precisamos nem mesmo incluir
a parte do `else`:

```perl
if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    print "$row\n";
  }
}
```
