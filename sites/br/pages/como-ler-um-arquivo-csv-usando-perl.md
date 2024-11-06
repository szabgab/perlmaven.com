---
title: "Como Ler um Arquivo CSV Usando Perl?"
timestamp: 2013-08-26T06:07:56
tags:
  - CSV
  - split
  - Text::CSV
  - Text::CSV_XS
published: true
original: how-to-read-a-csv-file-using-perl
books:
  - beginner
author: szabgab
translator: leprevost
---


Ler e processar arquivos de texto costuma ser uma atividade comum para quem trabalha com Perl. Por exemplo, 
encontramos com frequência [arquivos CSV](http://en.wikipedia.org/wiki/Comma-separated_values)
(onde CSV significa <i>Comma-separated values</i>, ou <i>valores separados por vírgula</i>),
onde temos que extrair informações. Aqui está um exemplo seguido de três soluções.

A boa, uma melhor e uma excelente.

A primeira é uma solução razoável para arquivos CSV simples, que não exigem nada além do próprio perl.

A segunda corrige alguns problemas causados por arquivos CSV um pouco mais complexos.
A terceira solução é provavelmente a melhor delas. Porém, o seu custo é está na dependência de um
módulo do CPAN.

Escolha aquela que se encaixa melhor nas seus necessidades.


Eu tenho um arquivo CSV que se parece com isso:

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,Hofeherke,100,Kiralyno
Boszorkany,Herceg,9,Meselo
```

Isto é um arquivo CSV. Em cada linha há campos separados por vírgulas.

É claro que o separador pode ser qualquer tipo de caractere contanto que seja o mesmo ao longo
do arquivo todo.
Os separadores mais comuns são a vírgula (CSV) e o caractere <i>tab</i> (TSV) mas as pessoas
as vezes utilizam o ponto e vírgula ( ; ) e o <i>pipe</i> também ( | ).

De qualquer forma, a tarefa é resumir o número na terceira coluna.

## O Algoritmo

O processo deve ser algo assim:

<ol>
<li>Ler o arquivo linha por linha.</li>
<li>Para cada linha extrair a terceira coluna.</li>
<li>Somar o valor ao valor de uma variável central acumuladora.</li>
</ol>

Nós já vimos anteriormente como ler um arquivo linha por linha, então
nós precisamos saber apenas como processar cada linha e como extrair a
terceira coluna.

Eu não posso utilizar o `substr()` de forma fácil porque a localização da 
terceira coluna muda continuamente.
O que neste caso é fixo, é o fato de estar entre a segunda e a terceira vírgula.

Eu poderia usar `index()` 3 vezes em cada linha para localizar a segunda e a terceira
vírgula, e então utilizar o `substr()` mas o Perl possui algo muito mais fácil para 
a tarefa.

## Usando o split

A função `split()` geralmente recebe dois parâmetros.
O primeiro é a faca e o segundo o que precisa ser cortado em pedaços.

A faca geralmente é uma expressão regular mas por enquanto vamos nos ater apenas
a textos simples.

se eu tenho um texto do tipo `$str = "Tudor:Vidor:10:Hapci"` eu posso chamar
`@fields = split(":"  ,   $str);`. O array `@fields` será preenchido
com 4 elementos: "Tudor", "Vidor", "10" and "Hapci". Se eu fizer `print $fields[2]`
irei ver o número 10 na tela, pois o índex do array inicia em zero.

No nosso caso o separador de campo é o caractere vírgula `,` e não o caractere de
dois pontos `:` então a nossa função para split ficará assim:
`@fields = split("," , $str);`
sem que seja necessário mexer nos parênteses.

Nós podemos escrever o nosso script da seguinte maneira:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $sum = 0;
open(my $data, '<', $file) or die "Could not open $file $!\n";

while (my $line = <$data>) {
  chomp $line;

  my @fields = split "," , $line;
  $sum += $fields[2];
}
print "$sum\n";
```


Se você salvar isso como csv.pl então poderá rodar o script passando o arquivo csv
de entrada pela linha de comando `perl csv.pl data.csv`.

## A vírgula no campo

Toda vez que receber um arquivo CSV você poderá utilizar esse script para somar os valores na terceira coluna.
Infelizmente em algum momento você poderá receber avisos enquanto roda o seu script.

`Argument " alma"" isn't numeric in addition (+) at csv.pl line 16, <$data> line 3.`

Você abre o seu arquivo CSV e de separa com o seguinte:

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,"Hofeherke, alma",100,Kiralyno
Boszorkany,Herceg,9,Meselo
```

Como você pode ver, o segundo campo na terceira linha possui uma vírgula no próprio valor, portanto a pessoa que
escreveu o arquivo colocou aspas ao redor: `"Hofeherke, alma"`. Isso é perfeitamente aceitável dentro dos "padrões"
dos arquivos CSV, mas o nosso script não consegue lidar corretamente com a situação. A função `split()`
não se importa com as aspas nem tampouco intende algo sobre CSV. Ela apenas corta quando se depara com o caractere separador.

Nós precisamos de uma solução mais robusta para ler o arquivo

## Text::CSV

Por sorte podemos utilizar o módulo encontrado no CPAN chamado [Text::CSV](https://metacpan.org/pod/Text::CSV)
que é um leitor e editor de CSV completo.

Esse módulo foi escrito utilizando princípios da programação orientada a objetos (POO).
Mesmo que você não saiba o que POO significa, você não precisa se preocupar. Nós não iremos aprender
sobre POO neste momento, nós iremos apenas utilizar o módulo. Nós vamos ver alguns comandos e expressões
novas, apenas para que as pessoas que estejam familiar ao conceito possam fazer a conexão.

Aqui está o código:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ',' });

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $sum = 0;
open(my $data, '<', $file) or die "Could not open '$file' $!\n";
while (my $line = <$data>) {
  chomp $line;

  if ($csv->parse($line)) {

      my @fields = $csv->fields();
      $sum += $fields[2];

  } else {
      warn "Line could not be parsed: $line\n";
  }
}
print "$sum\n";
```

`Text::CSV`  é uma extensão do Perl escrita por terceiros. Ela provê funcionalidades novas,
como por exemplo, a capacidade de ler, escrever e processar arquivos CSV.

Os programadores Perl chamas essas extensões de módulos, apesar de que as pessoas que vem de outras
linguagens podem estar mais familiarizados com a palavra biblioteca.

Neste ponto eu assumo que você já tenha esse módulo instalado em seu computador. Nós já vimos anteriormente
como fazer isso.

Primeiro precisamos carregar o módulo utilizando o comando `use Text::CSV;`. Nós não precisamos
dizer o que importar uma vez que este módulo não importa nada. Ele atua de uma forma orientada a objetos:
você precisa criar e instanciar algo para então usá-lo.

O próprio módulo TEXT::CSV é a classe e você pode criar uma instância, também chamada de objeto, ao chamar
o construtor. Em Perl não há regras definindo como chamar o construtor mas de qualquer jeito
a maioria das pessoas utiliza o nome "new". A forma como se chama o construtor de uma classe é através 
da flecha `->`.

Essa chamada cria um objeto indicando que o caractere separador é a vírgula ( , ).
Um objeto é apenas um valor escalar.

Na verdade a vírgula já é o caractere separador definido por padrão, mas mesmo assim é melhor tornar
o código mais visível.

`my $csv = Text::CSV->new({ sep_char => ',' });`

A maioria do outro código é o mesmo porém ao invés de duas linhas de split() e somar ao $sum,
agora nós temos mais linhas que precisam de melhor explicação.

O módulo Text::CSV não possui uma função split(). Para que seja possível dividir o texto você precisa
chamar a "função de parser" - ou no linguajar da orientação a objetos - o "método de parser".
Novamente nós utilizamos a flecha (->) par tal:

`$csv->parse($line)`

Essa invocação de método irá tentar parsear a linha atual, quebrando-a em pedaços. Não irá
retornar os pedaços, e sim retornará verdadeiro ou falso dependendo do seu sucesso ou falha 
no processamento da linha. Um caso comum onde ela pode falhar ocorre se há somente um único
caractere de aspas duplas: `Kuka,"Hofeherke, alma,100,Kiralyno`

Se falhar nós caímos na parte do `else`, imprimindo na tela um aviso e indo para a 
próxima linha.

Se de certo nós chamamos o método `fields`  que irá retornar os pedaços
do texto picotado. Então assim nós podemos capturar o terceiro elemento (índice 2)
que deve ser o número.

## Campos multi-linha

Pode haver ainda outros "problemas" com o arquivo CSV. Alguns campos por exemplo podem possuir caracteres de nova linha.

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,"Hofeherke,
alma",100,Kiralyno
Boszorkany,Herceg,9,Meselo
```

A forma como nós lidamos com o arquivo CSV não é suficiente para resolver esse problema mas o módulo
[Text::CSV](https://metacpan.org/pod/Text::CSV) fornece uma forma de resolver isso.

Este exemplo é baseado nos comentários de H.Merijn Brand, o mantenedor do módulo
[Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS):

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $csv = Text::CSV->new ({
  binary    => 1,
  auto_diag => 1,
  sep_char  => ','    # not really needed as this is the default
});

my $sum = 0;
open(my $data, '<:encoding(utf8)', $file) or die "Could not open '$file' $!\n";
while (my $fields = $csv->getline( $data )) {
  $sum += $fields->[2];
}
if (not $csv->eof) {
  $csv->error_diag();
}
close $data;
print "$sum\n";
```

Isso muda toda a estratégia de como lidar com o arquivo. Ao invés de ler manualmente linha por linha,
nós pedimos ao Text::CSV para ler, o que le e considera uma linha. Isso permite que o módulo lide
com campos possuindo caracteres de nova linha. Nós também utilizamos algumas <i>flags</i> no módulo
e quando abrimos o arquivo nos certificamos que pode lidar tranquilamente com caracteres UTF-8.

Em adição, neste exmplo o método `getline` retorna uma referência de um array
- algo que nós aina não aprendemos - então quando capturar o terceiro elemento (índice 2)
nós precisamos desreferenciar e usar a sintaxe da flecha para capturar o valor `$fields->[2]`.

Por fim, após terminarmos o laço nós precisamos avaliar se nós atingimos o final do arquivo (eof)?
a função getline() irá retornar falsa tanto quanto para o final do arquivo quanto para erros.
Então nós avaliamos se chegamos ao final do arquivo, caso contrário, então imprimimos a 
messagem de erro.

## Branca de Neve

Aliás, caso esteja se perguntado, os valores no arquivo CSV são os nomes dos
[7 anões](http://hu.wikipedia.org/wiki/H%C3%B3feh%C3%A9rke_%C3%A9s_a_h%C3%A9t_t%C3%B6rpe_%28film,_1937%29).
(em húngaro, é claro!).

