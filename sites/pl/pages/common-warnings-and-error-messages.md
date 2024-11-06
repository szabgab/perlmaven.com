---
title: "Typowe komunikaty ostrzeżeń i błędów w Perlu"
timestamp: 2015-11-16T09:02:01
tags:
published: true
books:
  - beginner
author: szabgab
translator: rozie
original: common-warnings-and-error-messages
---


O ile komunikaty ostrzeżeń i błędów zgłaszane przez Perla są całkiem dokładne, nie zawsze są
one bardzo przyjazne dla początkujących. W tych artykułach znajdziesz kilka najbardziej powszechnych
ostrzeżeń i błędów, które napotkasz, wytłumaczonych, mam nadzieję, w sposób bardziej przyjazny początkującym.

Niektóre z artykułów nawet zawierają wskazówki jak naprawić dany błąd.


* [Global symbol requires explicit package name](/global-symbol-requires-explicit-package-name)
         wytłumaczone także w [Deklaracja zmiennych w Perlu](/variable-declaration-in-perl)
* [Use of uninitialized value](/use-of-uninitialized-value)
* [Bareword not allowed while "strict subs" in use](/barewords-in-perl)
* [Name "main::x" used only once: possible typo at ...](/name-used-only-once-possible-typo)
* [Unknown warnings category](/unknown-warnings-category)
* Can't use string ("Foo") as a HASH ref while "strict refs" in use at ...
       opisane w [Symbolic references in Perl](/symbolic-reference-in-perl)
* [Can't locate ... in @INC](/cant-locate-in-inc)
* [Scalar found where operator expected](/scalar-found-where-operator-expected)
* ["my" variable masks earlier declaration in same scope](/my-variable-masks-earlier-declaration-in-same-scope)
* [Can't call method ... on unblessed reference](/cant-call-method-on-unblessed-reference)
* [Argument ... isn't numeric in numeric ...](/argument-isnt-numeric-in-numeric)
* [Can't locate object method "..." via package "1" (perhaps you forgot to load "1"?)](/cant-locate-object-method-via-package-1)
* [Odd number of elements in hash assignment](/creating-hash-from-an-array)
* [Possible attempt to separate words with commas](/qw-quote-word)
* [Undefined subroutine ... called](/pro/autoload)


[perldiag](https://metacpan.org/pod/perldiag) także posiada dłuższe tłumaczenia dla każdego z tych
błędów i ostrzeżeń, które możesz przejrzeć, albo możesz dotrzeć do szczegółowego tłumaczenia 
[używając diagnostics lub splain](/use-diagnostics-or-splain).
