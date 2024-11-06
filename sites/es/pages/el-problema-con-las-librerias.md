---
title: "El problema con las librerías estilo Perl 4"
timestamp: 2017-02-11T08:00:11
tags:
  - -w
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
original: the-problem-with-libraries
translator: nselem
---


Ahora que hemos aprendido a usar [librerías en Perl 4](/librerias-perl-4), estudiaremos los problemas que tienen.
A pesar de que siguen en uso, pertenecen a una época muy antigua, antes de que Perl 5 apareciera en 1995.

<slidecast file="advanced-perl/libraries-and-modules/the-problem-with-libraries" youtube="UZeEzD5459c" />

De la nada:
La librería (`library.pl`) que tenemos en [librerías en Perl 4](/librerias-perl-4) contiene 3 funciones y una variable global (`$base`). Si nosotros hacemos `import` de la librería tal como está hecho en `perl4_app.pl`
entonces tendremos todas las funciones y la variable disponibles en nuestro script.

El problema viene cuando usas más de una librería en un mismo script y algunas de las funciones están declaradas con el mismo nombre en ambas librerías. Por ejemplo tenemos una función matemática `add` en esta librería, supongamos que tenemos otra función `add` totalmente diferente relacionada con inventarios en otra librería. Si escribes un script que requiera ambas librerías, ambos importarán la función `add` y estas funciones se sobre escribirán una a la otra. Más específicamente, la segunda función cargada (usando require) sobre escribirá a la primera.Lo que significa pues que el orden de los requires importa, y probablemente enloquecerá a alguien que esté tratando de entender por qué el script actúa extraño.

Esta posible falla aumenta entre más librerías agreguemos a un script.

Y perl no manda siquier una advertencia, por supuesto, porque es el estilo de Perl 4 de programar sin el `use warnings`.

Aunque podemos activar las advertencias agregando `-w` a la línea sh-bang:

```
#!/usr/bin/perl -w
```

Aún más problemático es que ahora todas las funciones internas (`validate_parameters` en nuestro caso),
y todas las variables internas globales (`$base` en nuestro caso) estarán disponibles y serán globales también en nuestro script.

Así que para evitar que nuestro programa interfiera con los internos de la librería, necesitas conocer previamente la existencia de la variable `$base` y evitarla en tu código.

Es aun peor cuando la librería es actualizada. Especialmente si el escritor de la librería no se mantiene al tanto de los scripts que la usan porque puede escribir una nueva función o variable que interfiera con alguno de los scripts de los usuarios de su módulo.

## Conclusiones tempranas

Aunque las libreras de Perl fueron útiles, y son mucho mejores que el copiar-pegar,su tiempo ha terminado.
Así que vamos a aprender a convertirlas en algo más moderno.
## Prefijos siempre

Una de las soluciones al problema de interferencia es usar prefijos. Agregar un prefijo a toda función y a toda variable global de la librería, agregando una palabra única de la librería. Por ejemplo una librería con funciones relacionadas con matemáticas puede ser prefijada con `_math_` o `calc_` como en el ejemplo.

<b>calc_perfix_lib.pl</b>:

```perl
$calc_base = 10;

sub calc_add {
    calc_validate_parameters(@_);

    my $total = 0;
    $total += $_ for (@_);
    return $total;
}

sub calc_multiply {
}

sub calc_validate_parameters {
    die 'Not all of them are numbers'
        if  grep {/\D/} @_;
    return 1;
}

1;
```

Este método reduce el potencial de interferencia con los scripts utilizando este módulo, pero el incoveniente de esta solución es que ahora tendremos que usar prefijos por todos lados, incluyendo dentro de la librería. Esto requerirá más esfuerzo en el teclear letras y probablemente dejará el código menos leíble.

Adems, Perl 5 tiene una solución perfecta usando namespaces (usualmente también se les onoce como módulos).
Hablaremos de ellos en el siguiente episodio.
