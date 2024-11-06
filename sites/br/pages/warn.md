---
title: "Alertando quando algo dá errado"
timestamp: 2014-09-22T09:38:00
tags:
  - warn
  - STDERR
published: true
original: warn
books:
  - beginner
author: szabgab
translator: leprevost
---


Quando algo de errado acontece em seu script/programa, é de costume alertar o usuário sobre o problema. Em scripts executados pela linha de comando isso normalmente ocorre imprimindo na tela mensagens de aviso no [ canal de erro (Standard Error channel)](https://perlmaven.com/stdout-stderr-and-redirection).


Como foi explicado no artigo sobre [ saída padrão e erros](https://perlmaven.com/stdout-stderr-and-redirection),
no Perl você pode fazer isso imprimindo diretamente em `STDERR`

```perl
print STDERR "Slight problem here...\n";
```

Entretanto, há uma forma melhor e mais padronizada de se fazer isso, basta chamar a função `warn`:

```perl
warn "Slight problem here.\n";
```

Esse forma é menor, mais expressiva e possui o mesmo efeito do primeiro exemplo acima.

Em ambos os casos acima, após imprimir a mensagem de aviso, o script continuará sendo executado!

Porém, ainda há mais. Se você excluir o caractere final de nova linha (o `\n` no final):

```perl
warn "Slight problem here.";
```

então a saída irá incluir o nome do arquivo e o número da linha onde a função `warn` foi chamada:

```
Slight problem here. at programming.pl line 5.
```

Isso pode ser bastante útil quando você possui um script que executa vários outros scripts ou quando você possui uma aplicação maior com diferentes módulos. Dessa forma, será muito mais fácil para você, ou para o usuário do programa de rastrear a origem do problema.

## Capturando avisos

Ainda há mais.

Perl possui um manipulador especial para avisos.
Isso significa que você, ou outra pessoa, pode adicionar código ao programa que [ captura todos os avisos ](https://perlmaven.com/how-to-capture-and-save-warnings-in-perl). Isso é algo um pouco mais avançado, mas se você estiver interessado, vá em frente e veja esse tutorial.

## aviso

Um pequeno aviso. Você pode encontrar casos onde um aviso que é chamado após a declaração `print` apareça antes do conteúdo a ser impresso.

O código abaixo:

```perl
print "before";
warn "Slight problem here.\n";
print STDERR "More problems.\n";
print "after";
```

gera este resultado:

```
Slight problem here.
More problems.
beforeafter
```

Onde a palavra “before” aparece após ambos os avisos.

Neste caso, leia sobre [buffering](https://perlmaven.com/stdout-stderr-and-redirection#buffering).

