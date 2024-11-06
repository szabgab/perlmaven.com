---
title: "Las 19 herramientas fundamentales para manipular el sistema de archivos en Perl 5"
timestamp: 2013-07-03T22:45:56
tags:
  - cwd
  - tempdir
  - catfile
  - catdir
  - dirname
  - FindBin
  - $Bin
  - File::Spec
  - File::Basename
  - File::Temp
  - Cwd
published: true
original: the-most-important-file-system-tools
author: szabgab
translator: enrique
---



Cuando escribo scripts Perl para manipular el sistema de archivos suelo tener que cargar muchos módulos.
Gran parte de las funciones que necesito están dispersas en distintos módulos. Algunas son funciones integradas de perl, otras se encuentran en módulos estándar incluidos en perl, y otras deben instalarse desde CPAN.

Voy a describir las 19 herramientas que más uso.


## Ruta actual

A menudo tengo que determinar en qué directorio me encuentro. El módulo <b>Cwd</b> incluye una función con el mismo nombre, pero escrito en minúsculas (<b>cwd</b>), que devuelve el <b>directorio de trabajo actual</b>.

<img src="/img/Hdd_icon.svg" style="float: right" />

```perl
use strict;
use warnings;

use Cwd qw(cwd);

print cwd, "\n";
```


## Directorio temporal

Muchas veces tengo que crear unos cuantos archivos temporales y quiero asegurarme de que se eliminen automáticamente cuando finalice el script. La manera más sencilla de hacer esto es crear un directorio temporal mediante la función <b>tempdir</b> de <b>File::Temp</b>, con la opción CLEANUP activada.


```perl
use strict;
use warnings;
use autodie;

use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

print "$dir\n";

open my $fh, '>', "$dir/un_archivo.txt";
print $fh "texto";
close $fh;
```


## Ruta independiente del sistema operativo

Aunque el código anterior funciona tanto en Linux como en Windows, en Windows se suelen usar barras diagonales inversas para separar las partes de una ruta. Además, en VMS no funcionará.
Creo. Para evitar problemas, podemos usar la función <b>catfile</b> de <b>File::Spec::Functions</b>:

```perl
use strict;
use warnings;

use File::Spec::Functions qw(catfile);

use File::Temp qw(tempdir);

my $dir = tempdir( CLEANUP => 1 );

print "$dir\n";
print catfile($dir, 'un_archivo.txt'), "\n";
```

Prueba este código. Verás el directorio temporal creado y el nombre del archivo anexado a continuación.

## Cambiar de directorio

A veces es más fácil cambiar primero el directorio de trabajo a un directorio temporal y trabajar en dicho directorio. Puede ocurrir a menudo al escribir pruebas, pero también en otros casos. Para esto, podemos usar la función predefinida <b>chdir</b>.


```perl
use strict;
use warnings;
use autodie;

use File::Temp qw(tempdir);
use Cwd;

my $dir = tempdir( CLEANUP => 1 );
print cwd, "\n";
chdir $dir;
print cwd, "\n";

open my $fh, '>', 'temp.txt';
print $fh, 'texto';
close $fh;
```

Esto podría funcionar, pero cuando File::Temp intenta eliminar el directorio, seguiremos "dentro", ya que lo hemos convertido en el directorio de trabajo.

Aparecerá un mensaje de error similar al siguiente:

```
cannot remove path when cwd is /tmp/P3DZP_rmqg for /tmp/P3DZP_rmqg:
```

Para evitar que esto ocurra, suelo guardar la ruta devuelta por <b>cwd</b> antes de cambiar de directorio, y al final vuelvo a llamar a <b>chdir</b>:


```perl
my $original = cwd;

...

chdir $original;
```

Sin embargo, esto presenta un pequeño problema. ¿Qué ocurre si tengo que llamar a <b>exit()</b> en la mitad del script o si algo desencadena una excepción que finaliza el script antes de que llegue a <b>chdir $original</b>?

Perl nos permite solucionarlo encapsulando la última función chdir en un bloque <b>END</b>.
Esto garantizará la ejecución del código independientemente de cuándo y cómo se salga del script.

```perl
my $original = cwd;

...

END {
    chdir $original;
}
```


## Ruta relativa

Al desarrollar un proyecto con varios archivos (p. ej., uno o más scripts, algunos módulos, puede que algunas plantillas, etc.), si no deseo "instalarlos", la mejor estructura de directorios es asegurarse de que todo está en un lugar fijo <b>con respecto</b> a los scripts.

Por esta razón, generalmente tengo un directorio de proyecto que contiene un subdirectorio para scripts, otro para módulos (lib), otro para plantillas, etc.:

```
proyecto/
     scripts/
     lib/
     plantillas/
```

¿Cómo puedo asegurarme de que los scripts encuentren las plantillas? Para esto hay varias soluciones:


```perl
use strict;
use warnings;
use autodie;

use FindBin qw($Bin);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir);

print $Bin, "\n";                                # /home/Lanza-Cohetes/scripts
print dirname($Bin), "\n";                       # /home/Lanza-Cohetes
print catdir(dirname($Bin), 'templates'), "\n";  # /home/Lanza-Cohetes/templates
```

La variable <b>$bin</b> exportada por el módulo <b>FindBin</b> contendrá la ruta de acceso al directorio del script actual. En este caso, la ruta al directorio proyecto/scripts/.

La función <b>dirname</b> de <b>File::Basename</b> consume una ruta y devuelve esa ruta sin la parte final.

La última línea contiene la función <b>catdir</b> de <b>File::Spec::Functions</b>, que es básicamente análoga a la función <b>catfile</b> que vimos antes.

En lugar de imprimir en pantalla usamos el valor devuelto por <b>catdir</b> para especificar las plantillas.

## Cargar módulos desde una ruta relativa

Para buscar y cargar los módulos que se encuentran en el directorio lib/ del proyecto hacemos prácticamente lo mismo. Combinamos el código anterior con el pragma <b>lib</b>. Eso cambiará el contenido de la variable <b>@INC</b>, agregando la ruta relativa al principio del array.

```perl
use strict;
use warnings;
use autodie;

use FindBin qw($Bin);
use File::Basename qw(dirname);
use File::Spec::Functions qw(catdir);

use lib catdir(dirname($Bin), 'lib');

use Lanza::Cohetes;
```

Aquí se supone que tienes un archivo lib/Lanza/Cohetes.pm


## ¿Dónde están las demás herramientas?

Podría explayarme más, pero creo que ya es suficiente como primera parte de esta serie.
Si no quieres perderte los demás artículos, [suscríbete a este boletín](/register). Es gratis.



[Origen de imagen](http://commons.wikimedia.org/wiki/File:Hdd_icon.svg)

