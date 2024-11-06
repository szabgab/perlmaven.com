---
title: "Como adicionar imagenes a la documentacion de modulos Perl en CPAN "
timestamp: 2014-09-13T10:30:01
tags:
published: true
original: how-to-add-images-to-cpan
author: szabgab
translator: danimera
---

Tener mucha documentación clara de un módulo CPAN es impresionante, pero
ver un muro de texto mientras se lee  puede ser un poco aburrido.

Afortunadamente ambos [ MetaCPAN](http://metacpan.org/)
y [ search.cpan.org](http://search.cpan.org/).



Primero vinculos de algunos ejemplos:

## Incluyendo imagenes en MetaCPAN

* [Chart::Clicker](https://metacpan.org/pod/Chart::Clicker)
* [SVGN](https://metacpan.org/pod/SVG)
* [Acme::CPANAuthors::Nonhuman](https://metacpan.org/pod/Acme::CPANAuthors::Nonhuman)
* [MOSES::MOBY](https://metacpan.org/pod/MOSES::MOBY)
* [Wrangler](https://metacpan.org/pod/Wrangler)

## Incluyendo imagenes en search.cpan.org

* [Chart::Clicker](http://search.cpan.org/dist/Chart-Clicker/lib/Chart/Clicker.pm)
* [SVG](http://search.cpan.org/dist/SVG/lib/SVG.pm)

Como señaló el éter en el hipervínculo [ blogs.perl.org](http://blogs.perl.org/users/gabor_szabo/2013/08/adding-images-to-cpan.html)
post, [ grep.cpan.me](http://grep.cpan.me/?q=%3Dbegin+html) puede enumerar un montón de módulos que pueden tener algunos HTML incrustado
en su POD.

## Entonces, cómo se puede hacer?

Echemos un vistazo a:
[Codigo fuente de Char::Clicker](https://github.com/gphat/chart-clicker/blob/master/lib/Chart/Clicker.pm).

Tiene la siguiente sección:

```
=begin HTML

<p><img src="http://gphat.github.com/chart-clicker/static/images/examples/line.png"
width="500" height="250" alt="Line Chart" /></p>

=end HTML
```

Eso es todo lo que necesitamos para incluir en el POD del módulo.

Las imágenes sirven desde una [ página de Github](http://pages.github.com/).

[ Chart::Clicker](http://gphat.github.io/chart-clicker/) tiene su propio sitio
alojado en una página de Github. Es muy fácil de crear tal una página Github para su proyecto.
Sólo siga [ las instrucciones](https://help.github.com/articles/creating-project-pages-manually).
Allí puede incluir agregar las imágenes

En el [ código fuente de SVG](https://github.com/szabgab/SVG/blob/master/lib/SVG.pm) el
ejemplo es ligeramente diferente:

```
=for HTML <p><img src="https://szabgab.com/img/SVG/circle.png" alt="SVG example circle" /></p>
```

Aquí la imagen en realidad se obtiene de mi propio dominio personal.


