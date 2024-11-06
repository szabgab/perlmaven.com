---
title: "Perl tutorial"
timestamp: 2012-07-06T00:02:05
description: "Tutorial Perl disponível gratutamente para aqueles que precisam mantér código escrito em Perl, para aqueles que apenas escrevem pequenos scripts e para desenvolvedores de novas aplicações."
types:
  - training
  - treinamento
  - course
  - curso
  - beginner
  - iniciante
  - tutorial
published: true
original: perl-tutorial
author: szabgab
translator: leprevost
archive: false
---

O tutorial Perl Maven irá lhe ensinar o básico sobre a programação em Perl.
Você será capaz de escrever scripts simples, analisar arquivos de logs e escrever arquivos do tipo CSV.
Só para mencionar algumas atividades.

Você irá aprender como utilizar o CPAN e vários outros módulos específicos.

Será uma excelente base para você se apoiar.

A versão on-line gratuita do tutorial está em desenvolvimento constante. Muitas das partes já estão prontas, e
em adição, muitas estão sendo liberadas semanalmente. Se você têm interesse em ser avisado quando novos capítulos
do tutorial são lançados, por favor inscreva-se na [mailing list](/register).

Há ainda o [e-book](https://perlmaven.com/beginner-perl-maven-e-book) correspondente ao material do tutorial,
disponível para compra (somente en inglês), em adição ao tutorial. O livro ainda inclui <i>slides</i> sobre o
material apresentado tópicos exclusivos e exercícios.

Você pode acompanhar também as vídeo aulas (também em inglês)
[video-course](https://perlmaven.com/beginner-perl-maven-video-course) que incluem mais de 20 aulas, somando num total de
mais de 5 horas de vídeo. O pacote inclui também o código fonte dos exemplos e exercícios.

## Tutorial Perl Maven on-line e Gratuito para Iniciantes

Neste tutorial você irá aprender como utilizar a linguagem de programação Perl 5

Você irá aprender tanto características gerais quanto extensões e bibliotecas, ou como os programadores
Perl chamam, <b>módulos</b>. Nós iremos ver sobre os módulos básicos incluídos no núcleo da linguagem
e módulos desenvolvidos por terceiros, disponíveis pelo <b>CPAN</b>

Quando possível irei tentar ensinar os assuntos numa forma orientada à tarefas.
Irei elaborar tarefas e então iremos aprender as ferramentas necessárias para resolver os problemas.
Quando possível irei também direcionar você a alguns exercícios para que possa praticar o que aprendeu.

<p>
<b>Introdução</b>
<ol>
<li>[Instalando o Perl, imprimindo “Olá Mundo", Segurança (use strict, use warnings)](/instalando-o-perl)</li>
<li>[Editores, IDEs e ambientes de desenvolvimento para Perl](/editores-perl)</li>
<li>[Perl na linha de comandos](/perl-na-linha-de-comandos)</li>
<li>[Documentação do núcleo da linguagem e de módulos do CPAN](/documentacao-do-perl-e-modulos-cpan)</li>
<li>[Documentação em Perl com POD - Plain Old Documentation](/documentacao-em-perl-com-pod)</li>
<li>[Depurando scripts em Perl](/depurando-scripts-em-perl)</li>
</ol>

<b>Escalares</b>
<ol>
<li>Menssagens de Erro e Avisos Comuns<br />
* [Símbolo global requer nome de pacote explícito](/simbolo-global-requer-nome-de-pacote-explicito)
* [Uso de valor não inicializado](/uso-de-valor-nao-inicializado)
* [Palavra solta (bareword) em Perl](/palavras-soltas-em-perl)
* <a href="/nome-usado-apenas-uma-vez">Nome "main::x" usado apenas uma vez: possível erro em ...<a>
* [Categoria de alertas desconhecida](/categorias-desconhecidas-de-alertas)
* Scalar found where operator expected
* "my" variable masks earlier declaration in same scope
</li>
<li>[Conversão Automática entre texto e número em Perl](/conversao-automatica-entre-valores)</li>
<li>[Declarações condicionais: if](/if)</li>
<li>[Valores Booleanos em Perl](/valores-booleanos-em-perl)</li>
<li>[Operadores numéricos](/operadores-numericos)</li>
<li>[Operadores textuais](/operadores-textuais)</li>
<li>[undef, valor inicial e a função defined em Perl](/undef-e-definido-em-perl)</li>
<li>[Strings em Perl: entre aspas, interpoladas e 'escapadas'](/aspas-interpolacao-e-strings-escapadas)</li>
<li>Here documents</li>
<li>[Variáveis escalares](/variaveis-escalares)</li>
<li>[Comparando escalares em Perl](/comparando-escalares-em-perl)</li>
<li>[Funções para manipular texto: length, lc, uc, index, substr](/funcoes-para-manipular-texto-lc-uc-index-substr)</li>
<li>[O jogo de adivinhar números (rand, int)](/jogo-de-adivinhar-numeros)</li>
<li>[ O laço while](/laco-while)</li>
<li>[Escopo de variáveis em Perl](/escopo-das-variaveis-em-perl)</li>
</ol>

<b>Arquivos</b>
<ol>
<li>die, warn and exit</li>
<li>[Escrevendo em arquivos com Perl](/escrevendo-em-arquivos-com-perl)</li>
<li>[Acrescentando texto em arquivos (appending)](/acrescentando-em-arquivos)</li>
<li>[warn: alertando quando algo dá errado](/warn)</li>
<li>[Abrindo e Lendo Arquivos de Texto](/abrindo-e-lendo-arquivos)</li>
<li>[Não abra arquivos na forma antiga](/nao-abra-arquivos-na-forma-antiga)</li>
<li>[die](/die)</li>
<li>Modo binário, lidando com Unicode</li>
<li>Lendo de um arquivo binário, read, eof</li>
<li>tell, seek</li>
<li>truncate</li>
</ol>

<b>Listas e Arrays</b>
<ol>
<li>Laço foreach do Perl</li>
<li>[O laço for em Perl](/laco-for)</li>
<li>Listas em Perl</li>
<li>Usando Módulos</li>
<li>[Arrays em Perl](/arrays-em-perl)</li>
<li>Process command line parameters @ARGV, Getopt::Long</li>
<li>[Como ler e processar um arquivo CSV? (split, Text::CSV_XS)](/como-ler-um-arquivo-csv-usando-perl)</li>
<li>[join](/funcao-join)</li>
<li>[O ano de 19100 (time, localtime, gmtime) e introdução ao contexto](/o-ano-19100)</li>
<li>Sensibilidade do contexto em Perl</li>
<li>Ordenando arrays em Perl</li>
<li>Valores únicos em um array em Perl</li>
<li><a href="/manipulando-arrays-em-perl">Manipulando arrays em Perl: shift, unshift, push, pop</li>
<li>Pilha e fila</li>
<li>reverse</li>
<li>O operador ternário</li>
<li>Controles de laço: next and last</li>
<li>min, max, sum usando List::Util</li>
</ol>

<b>Subrotinas</b>
<ol>
<li>Subrotinas e Funções em Perl</li>
<li>Passagem e verificação de parâmetros para subrotinas</li>
<li>Número variável de parâmetros</li>
<li>Retornando uma lista</li>
<li>Subrotinas recursivas</li>
</ol>

<b>Hashes, arrays</b>
<ol>
<li>[Hashes em Perl (dicionário, array associativo, tabela de consulta)](/perl-hashes)</li>
<li>exists, delete elementos de uma hash</li>
</ol>

<b>Expressões Regulares</b>
<ol>
<li>Expressões Regulares em Perl (Regex)</li>
<li>Regex: classes de caracteres</li>
<li>Regex: quantificadores</li>
<li>Regex: Casamento guloso e não-guloso</li>
<li>Regex: Agrupamentos e capturas</li>
<li>Regex: Âncoras</li>
<li>Opções de Regex e modificadores</li>
<li>Substituições (busca e substituição)</li>
<li>[trim - removendo espaços em branco à esquerda e à direita com Perl](/trim)</li>
</ol>

<b>Funcionalidades afins no Perl e no Shell</b>
<ol>
<li>Perl -X operadores</li>
<li>Pipelines em Perl</li>
<li>Executando programas externos</li>
<li>Comandos Unix: rm, mv, chmod, chown, cd, mkdir, rmdir, ln, ls, cp</li>
<li><a href="/como-remover-copiar-ou-renomear-um-arquivo-usando-perl">Como
remover, copiar ou renomear um arquivo com Perl</a></li>
<li>Comandos Windows/DOS: del, ren, dir</li>
<li>Englobamento de Arquivos(Metacaracteres)</li>
<li>Manipuladores de directórios</li>
<li>Percorrendo a árvore de diretórios (find)</li>
</ol>

<b>CPAN</b>
<ol>
<li>[Baixe e instale o Perl (Strawberry Perl ou compilação manual)](/baixe-e-instale-o-perl)</li>
<li>Download e instalação do Perl usando Perlbrew</li>
<li>Localizando e validando módulos CPAN</li>
<li>Baixando e instalando módulos Perl do CPAN</li>
<li>[Como alterar a @INC para encontrar módulos Perl em locais não padrão?](/como-alterar-a-inc-para-encontrar-modulos-perl-em-locais-nao-padrao)</li>
<li>Como alterar a @INC para um diretório relativo</li>
<li>local::lib</li>
</ol>

<b>Alguns exemplos para usar Perl</b>
<ol>
<li>[Como substituir uma string em um arquivo usando Perl? (slurp)](/como-substituir-uma-string-em-um-arquivo-usando-perl)</li>
<li>Lendo arquivos Excel usando Perl</li>
<li>Criando arquivos Excel usando Perl</li>
<li>Enviando e-mail usando Perl</li>
<li>CGI scripts com Perl</li>
<li>Aplicações Web com Perl: PSGI</li>
<li>Analisando arquivos XML</li>
<li>Lendo e escrevendo arquivos JSON</li>
<li>Acesso a bases de dados usando Perl (DBI, DBD::SQLite, MySQL, PostgreSQL, ODBC)</li>
<li>Accessando LDAP usando Perl</li>
</ol>

<b>Outros</b>
<ol>
<li>[Splice para fatiar e picar arrays em Perl](/splice-para-fatiar-e-picar-arrays-em-perl)</li>
<li>[Como criar um módulo Perl para reutilização de código](/como-criar-um-modulo-perl-para-reutilizacao-de-codigo)</li>
<li>[Perl Orientado a Objeto usando o Moose](/perl-orientado-a-objeto-usando-o-moose)</li>
<li>[Tipos de atributos em classes Perl ao usar o Moose](/tipos-de-atributos-em-classes-perl-ao-usar-o-moose)</li>
</ol>


<hr />

Apenas um lembrete, estão disponíveis para [compra](/products) os [e-books](https://perlmaven.com/beginner-perl-maven-e-book) e
[as vídeo aulas](https://perlmaven.com/beginner-perl-maven-video-course).
