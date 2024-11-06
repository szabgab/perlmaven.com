---
title: "Name 'main::x' used only once: possible typo at ..."
timestamp: 2014-09-15T18:27:00
tags:
  - warnings
  - strict
  - possible typo
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: leprevost
---


Se você algum dia se deparar com este aviso saiba que está com problemas.


## Atribuição à variáveis

Atribuir a uma variável e nunca utilizá-la, ou então utilizar uma variável sem ter atribuído a ela algum valor, são atitudes raramente corretas em qualquer linguagem de programação.

Provavelmente o único caso “legítimo” ocorre quando você comete algum erro de digitação, e é assim que você acaba com uma variável que é utilizada apenas uma vez.

Aqui está um exemplo de código onde nós <b>apenas atribuímos algo a uma variável</b> 

```perl
use warnings;

$x = 42;
```

Isso irá gerar com que um aviso como este:

```
Name "main::x" used only once: possible typo at ...
```

A parte que se refere ao “main::” e a ausência de $ podem ser um pouco confusas a você.
A parte “main::” é citada porque ela é utilizada por padrão, toda variável no Perl faz parte do namespace “main”. Há diversas coisas que podem ser chamadas “main::x”, mas apenas uma delas possui o símbolo $ no início. Se isto sua um pouco confuso não se preocupe, é confuso sim, mas provavelmente você não irá precisar lidar com isto por muito tempo.


## Apenas recuperando valores

Se por acaso você acabar utilizando uma variável <b> apenas uma vez</b>

```perl
use warnings;

print $x;
```

então você verá dois avisos:

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

Um deles é discutido neste artigo, o outro é discutido no tutorial 
[Uso de valor não inicializado](/uso-de-valor-nao-inicializado).

## Qual é o erro?

Você pode se perguntar.

Apenas imagine alguém utilizando a variável chamada `$l1`. Então depois, você resolve utilizar a mesma variável, mas você escreve `$ll`. Dependendo da sua fonte, elas podem se parecer muito similares.

Ou talvez exista uma variável chamada `$color` mas você é Britânico então automaticamente você digita `$colour`  no lugar.

Ou então você tem uma variável chamada `$number_of_misstakes` e você não perceba o erro de digitação no nome da variável que escreveu e em seguida escreve `$number_of_mistakes`.

Você pegou a ideia.

Se você tiver sorte, cometeu este erro apenas uma vez, mas se não tiver, e acabou utilizando a variável errada mais de uma vez, então este aviso não irá aparecer. Afinal de contas, se você está utilizando a mesma variável mais de uma vez, deve haver um bom motivo.

Então, como você pode evitar isso?

Primeiro, tente evitar variáveis com letras ambíguas e seja bastante cuidadoso quando digitar o nome.

Se quiser evitar isso de verdade, basta utilizar o pragma <b>use strict</b>!

## use strict

Como pode observar nos exemplos acima, eu não utilizei o <i>strict</i>. Se eu estivesse utilizando, não teria recebido o erro sobre o possível erro de digitação. Nesse caso eu teria recebido um erro em tempo de compilação:

[Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name).

Isso aconteceria mesmo se você tivesse utilizado a variável errada mais de uma vez.

Então obviamente, algumas pessoas iriam correr e adicionar o “my” na frente da variável incorreta, mas você não é uma dessas pessoas, certo? Você pensaria com cuidado no problema e procuraria a variável com o nome correto.

A forma mais comum de ver este aviso é através do uso do <i>strict</i>.


## Outros exemplos quando se usa strict

Como os usuários GlitchMr e Anonymous comentaram, há ainda outros casos a serem levados em conta:

Este exemplo ainda gera o mesmo aviso

```perl
use strict;
use warnings;

$main::x = 23;
```

O aviso é: <b>Name "main::x" used only once: possible typo ...</b>

Aqui pelo menos ainda é claro aonde o “main” está, ou então no próximo exemplo, de onde o “Mister” vem. (dica: o ‘main’ e o ‘Mister’ são nomes de pacotes. Se estiver interessado você pode ver outros exemplos de  [ mensagens de erro envolvendo pacotes](/global-symbol-requires-explicit-package-name).)

Neste próximo exemplo, o nome do pacote é ‘Mister’:

```perl
use strict;
use warnings;

$Mister::x = 23;
```

O aviso é <b>Name "Mister::x" used only once: possible typo ...</b>.

O próximo exemplo também gera o mesmo aviso, duas vezes:

```perl
use strict;
use warnings;

use List::Util qw/reduce/;
print reduce { $a * $b } 1..6;
```

```
Name "main::a" used only once: possible typo at ...
Name "main::b" used only once: possible typo at ...
```

Isso acontece porque `$a` e `$b` são
variáveis especiais utilizadas pela função antiva `sort` para que não seja necessário declará-las.
(Na verdade ainda não está claro para mim por que esse exemplo gera os aviso enquanto que o mesmo código utilizando  <b>sort</b> não, mas os [Perl Monks](http://www.perlmonks.org/?node_id=1021888) devem saber.


