---
title: "Nome 'main::x' usado apenas uma vez: possível erro em ..."
timestamp: 2014-02-21T00:50:10
tags:
  - warnings
  - strict
  - possible typo
published: true
original: name-used-only-once-possible-typo
books:
  - beginner
author: szabgab
translator: aramisf
---


Se você ver este alerta em um script Perl você está com sérios problemas.


## Atribuição para uma variável

Atribuir algo para uma variável mas nunca usá-la, ou usar uma variável uma
única vez sem jamais atribuir-lhe valor algum, raramente é algo correto de se
fazer em um programa.

Talvez o único caso "legítimo" é você ter cometido um erro de digitação e
acabou ficando com uma variável que é utilizada somente uma vez.

Aqui está um exemplo de código onde nós <b>apenas atribuímos a uma variável</b>:

```perl
use warnings;

$x = 42;
```

Isto vai gerar um alerta como este:

```
Name "main::x" used only once: possible typo at ...
```

Aquele "main::" e a falta do $ podem estar lhe confundindo.

Aquele "main::" está lá porque, por padrão, toda variável no Perl está dentro
do escopo (ou em inglês: 'namespace') do "main". Existem também outras coisas
que poderiam ser chamadas de "main::x" e apenas uma delas possui um $ no
início. Se isso lhe parece um pouco confuso, não se preocupe.

É confuso, mas espero que você não tenha que lidar com isso por um longo
tempo.

## Buscar apenas o valor

Se acontecer de você <b>usar uma variável apenas uma vez</b>

```perl
use warnings;

print $x;
```

então você provavelmente vai ter dois alertas:

```
Name "main::x" used only once: possible typo at ...
Use of uninitialized value $x in print at ...
```

Um deles nós estamos discutindo agora, o outro é discutido em
[Uso de valor não inicializado](/uso-de-valor-nao-inicializado).


## Qual é o erro aí?

Você pode perguntar.

Só imagine alguém usando uma variável chamada `$l1`. Então, você vem e
tenta usar a mesma variável, mas você escreve `$ll`.
Dependendo da fonte que você usa, ambas podem ser muito parecidas.

Ou talvez havia uma variável chamada `$color` mas você é Britânico e
automaticamente escreve `colour` quando pensa nela.

Ou ainda havia uma variável chamada `$numero_de_errros` e você não
percebe o erro no nome original da variável e escreve
`$numero_de_erros`.

Você já pegou a idéia.

Se você tiver sorte, você comete esse erro apenas uma vez, mas caso contrário,
se você usar a variável incorreta duas vezes, então este alerta
provavelmente não aparecerá.
Afinal de contas, se você está usando a mesma variável duas vezes, você
provavelmente tem uma boa razão para isso.

Então como você pode evitar isso?

Procure evitar variáveis com letras ambíguas e seja bastante cauteloso ao
digitar os nomes de variáveis.

Se você quiser resolver isso de uma vez por todas, então <b>use strict</b>!

## use strict

Como você pode ver nos exemplos acima, eu não usei o strict. Se eu estivesse
usando-o, então ao invés de receber um alerta sobre um possível erro de
digitação, eu receberia um alerta de erro em tempo de compilação:
<a href="/simbolo-global-requer-nome-de-pacote-explicito">Símbolo global
requer nome de pacote explícito</a>.

Isso aconteceria mesmo se você usasse o nome incorreto de variável mais de uma vez.

Então, é claro que existem pessoas que imediatamente escreveriam "my" na
frente da variável incorreta, mas você não é uma dessas pessoas, é? Você
pensaria no problema e procuraria até encontrar o nome da verdadeira variável.

A forma mais comum de ver esse alerta é se você não estiver usando o
<b>strict</b>.

Então você está em sérios apuros.

## Outros casos usando o strict

Como os comentaristas GlitchMr e Anonymous apontaram, existem alguns outros
casos:

Este código, também gera o alerta

```perl
use strict;
use warnings;

$main::x = 23;
```

O alerta é: <b>Name "main::x" used only once: possible typo ...</b>

Aqui ao menos está claro de onde aquele 'main' é proveniente, ou no próximo
exemplo, de onde o Mister vem.
(dica: 'main' e 'Mister' são ambos nomes de pacotes. Se você estiver
interessado, você pode ver outra <a
href="/simbolo-global-requer-nome-de-pacote-explicito">mensagem de erro,
envolvendo nomes de pacotes perdidos</a>.)
No próximo exemplo, o nome do pacote é 'Mister'.

```perl
use strict;
use warnings;

$Mister::x = 23;
```

O alerta é <b>Name "Mister::x" used only once: possible typo ...</b>.

O exemplo a seguir também gera o aviso. Duas vezes:

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

Isso acontece porque `$a` e `b` são variáveis especiais usadas
na função <b>sort</b> do Perl, então você não precisa declara-las, mas você as
está usando apenas uma vez neste código.
(Na verdade não é claro para mim porque isto gera os alertas, enquanto o mesmo
código usando o <b>sort</b> não o faz, mas os <a
href="http://www.perlmonks.org/?node_id=1021888">Perl Monks</a> talvez saibam.
