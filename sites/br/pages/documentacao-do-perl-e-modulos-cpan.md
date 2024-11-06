---
title: "Documentação do núcleo da linguagem e de módulos do CPAN"
timestamp: 2013-03-27T23:22:14
tags:
  - perldoc
  - documentação
  - POD
  - CPAN
published: true
original: core-perl-documentation-cpan-module-documentation
books:
  - beginner
author: szabgab
translator: leprevost
---


O Perl vem com muita documentação, mas leva um certo tempo até você aprender a usá-la.
Nesta parte do [Tutorial Perl](/perl-tutorial) eu irei explicar como
você pode achar o seu caminho pela documentação.


## perldoc Na Web

A maneira mais conveniente de acessar a documentação do núcleo da
linguagem perl é visitando o site [perldoc](http://perldoc.perl.org/).

O site contém uma versão HTML da documentação do Perl, da linguagem em si,
e dos módulos que vêm com o próprio núcleo, conforme divulgado pelo Perl 5 Porters.

O site não possui a documentação dos módulos presentes no CPAN.
Entretanto há uma sobreposição, pois existem alguns módulos que estão disponíveis
no CPAN mas que também estão incluídos na distribuição padrão Perl.
(Estes são frequentemente referidos como <i>dual-lifed</i>.)

Você pode usar a caixa de pesquisa no canto superior direito. Você pode, por exemplo pesquisar
pela função `split` que terá em retorno a documentação da função.

Infelizmente, o site não retorna a documentação de operações como o <b>while</b>, nem com
`$_` ou `@_`. Para obter uma explicação melhor desses elementos, será
necessário percorrer à documentação.

Provavelmente a página mais importante é a[perlvar](http://perldoc.perl.org/perlvar.html),
onde você pode encontrar informações sobre as diferentes variáveis como `$_` e `@_`.

[perlsyn](http://perldoc.perl.org/perlsyn.html) explica a sintaxe do Perl
incluindo o [laço while](/laco-while).

## perldoc na linha de comando

A mesma documentação vem com o código fonte do Perl, mas nem
toda distribuição Linux a instala por padrão. Em alguns casos,
é possível encontrar um pacote separado. Por exemplo, no Debian e Ubuntu é o pacote <b>perl-doc</b>
pacote. Você precisa instalá-lo usando `sudo aptitude install perl-doc`
antes de usar `perldoc`.

Depois de ter instalado, você pode digitar `perldoc perl` na linha de comando
e você vai ter uma explicação e uma lista dos capítulos na documentação do Perl.
Você pode parar isso usando o `q` chave, e digite o nome de um dos capítulos.
Por exemplo: `perldoc perlsyn`.

Uma vez instalado, você pode digitar `perldoc perl` na linha de comandos e você verá algumas explicações e uma lista de capítulos da documentação do Perl.
Você pode sair da descrição pressionando a tecla `q`.

Isso funciona tanto no Linux quanto no Windows, apesar de que o <i>pager</i> no Windows é muito fraco,
então eu não posso recomendá-lo. No Linux é o tradicional <i>man</i>, então você deve deve estar familiarizado com ele.

## Documentação De Módulos Do CPAN

Cada módulo no CPAN vem acompanhado da documentação e de exemplos.
A quantidade e qualidade desta documentação varia muito entre os autores, e até mesmo um único autor pode ter módulos muito bem documentado e muito sub-documentados.

Depois de instalar um determinado módulo chamado Módulo::Name, você pode acessar a sua documentação digitando <b>perldoc Módulo::Nome</b>.

Porém, há uma maneira bem mais conveniente que nem sequer requer que o módulo esteja instalado.
Existem várias interfaces web para o CPAN. As principais são [Meta CPAN](http://metacpan.org/) e o [search CPAN](http://search.cpan.org/).

Ambos são baseados na mesma documentação, mas eles proporcionam uma pequena diferença na experiência de uso.

## Busca de palavras-chave no Perl Maven

Uma recente adição a este site é a busca de palavras-chave na barra de menu superior.
Gradativamente, você irá encontrar explicações para mais e mais características da linguagem Perl.
Em determinado ponto, parte da documentação do núcleo do perl e a documentação do módulos do CPAN de maior importância também serão inclusos.

Se você estiver sentindo falta de alguma coisa de lá, basta fazer um comentário abaixo,
utilizando as palavras-chave que você está procurando e você tem uma boa chance de
que o seu pedido seja realizado.

