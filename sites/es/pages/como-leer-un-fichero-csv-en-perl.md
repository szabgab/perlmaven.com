---
title: "¿Como leer un fichero CSV en perl?"
timestamp: 2013-12-07T10:45:56
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
translator: davidegx
---


Leer y procesar ficheros de texto es una de las tareas típicas realizadas en Perl. Por ejemplo
puedes encontrar un [fichero CSV](http://es.wikipedia.org/wiki/CSV) (donde CSV quiere decir "Comma-separated values")
y necesitas extraer información del mismo. Veremos un ejemplo con tres soluciones.

Buena, mejor y mejor todavía.

La primera es una solución para ficheros CSV sencillos y no hace falta nada más que Perl.

La segunda solución elimina algunos problemas en ficheros CSV algo más complicados.
La tercera es probablemente la mejor, el precio de estas dos soluciones es que dependen
de módulos en CPAN.

Usa la que se adapte al problema que tengas entre manos.


Tenemos un fichero CSV como el siguiente:

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,Hofeherke,100,Kiralyno
Boszorkany,Herceg,9,Meselo
```

Esto es un fichero CSV. En cada fila hay campos separados por comas.

El separador puede ser cualquier carácter siempre y cuando sea el mismo en todo el fichero.
Los más comunes son la coma (CSV) y la tabulación (TSV), el punto y coma (;) y la barra vertical (|) también son usados frecuentemente.

En cualquier caso en este ejemplo la tarea a realizar es sumar el número de la tercera columna.

## El algoritmo

El proceso debería funcionar de la siguiente forma:

<ol>
<li>Leer el fichero línea por línea.</li>
<li>Para cada línea, extraer el valor de la 3ª columna.</li>
<li>Añadir el valor a una variable donde acumulamos la suma.</li>
</ol>

Ya hemos visto anteriormente como leer un fichero línea por línea
así que solo necesitamos saber como procesar cada fila para extraer
la tercera columna.

No puedo usar `substr()` de forma sencilla ya que la posición de la columna cambia.
Lo que es seguro es que esta entre la 2ª y 3ª coma.

Podría usar `index()` 3 veces en cada fila para localizar la 2ª y 3ª coma,
y después usar `substr()` pero hay una forma mucho más sencilla de hacerlo.

## Usando split

Normalmente la función `split()` recibe dos parámetros. El primero es una sierra y el segundo es la cadena
que necesitamos cortar en pedazos.

El primer parámetro en realidad es una expresión regular pero por ahora podemos usar una cadena normal.

Si tenemos una cadena como `$str = "Tudor:Vidor:10:Hapci"` podemos usar
`@fields = split(":"  ,   $str);`. El array `@fields` será rellenado
con 4 valores: "Tudor", "Vidor", "10" y "Hapci". Si ejecutamos `print $fields[2]`
veremos 10 en la pantalla (porque el índicde del array empieza por 0).

En nuestro caso el separador es la coma `,` no los dos puntos
`:` así que nuestra llamada será de la siguiente forma:
`@fields = split("," , $str);` aunque no escribiremos los paréntesis.


Podemos escribir nuestro script así:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $file = $ARGV[0] or die "Necesito un fichero CSV como parámetro\n";

my $sum = 0;
open(my $data, '<', $file) or die "No puedo abrir el fichero '$file' $!\n";

while (my $line = <$data>) {
  chomp $line;

  my @fields = split "," , $line;
  $sum += $fields[2];
}
print "$sum\n";
```

Si guardas este fichero como csv.pl podrás ejecutar `perl csv.pl data.csv`.

## Coma dentro de un campo

Cada vez que recibes un fichero CSV puedes ver que el script suma los valores de la tercera columna.
Por desgracia de repente recibes warnings cuando ejecutas el fichero.

`Argument " alma"" isn't numeric in addition (+) at csv.pl line 16, <$data> line 3.`

Abres el fichero CSV y ves esto:

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,"Hofeherke, alma",100,Kiralyno
Boszorkany,Herceg,9,Meselo
```

Como puedes ver el 2º campo de la 3ª fila tiene una coma en el valor y los autores del fichero
pusieron el campo entre comillas: `"Hofeherke, alma"`. Esto es bastante normal en el "estándar"
CSV, pero nuestro script no sabe como controlar correctamente la situación. `split()` no se
preocupa de las comillas, ni sabe nada acerca de CSV. Simplemente corta cuando encuentra el carácter
separador.

Necesitamos una forma más robusta de leer ficheros CSV.

## Text::CSV

Afortunadamente podemos encontrar el modulo [Text::CSV](https://metacpan.org/pod/Text::CSV) 
en CPAN que es capaz de leer y escribir ficheros CSV de forma correcta.

Este modulo esta escrito siguiendo los principios de Programación Orientada a Objetos (OOP).
No importa si no sabes lo que OOP es, no te preocupes. No necesitamos aprender OOP ahora mismo,
solo necesitamos usar el modulo. Veremos un poco más de sintaxis y unas pocas expresiones más.

Este es el código:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ',' });

my $file = $ARGV[0] or die "Necesito un fichero CSV como parámetro\n";

my $sum = 0;
open(my $data, '<', $file) or die "No puedo abrir el fichero '$file' $!\n";
while (my $line = <$data>) {
  chomp $line;

  if ($csv->parse($line)) {

      my @fields = $csv->fields();
      $sum += $fields[2];

  } else {
      warn "La linea no se ha podido procesar: $line\n";
  }
}
print "$sum\n";
```

`Text::CSV` es una extensión a Perl. Proporciona una serie de nuevas funcionalidades,
concretamente leer, analizar y escribir ficheros CSV.

Los programadores Perl llaman a estas extensiones módulos, aunque programadores en otros lenguajes
pueden estar más familiarizados con otros nombres como extensión o librería.

En este momento asumo que ya tienes el modulo instalado en tu ordenador. Veremos de forma separada
como instalarlo.

Primero necesitamos cargar el modulo usando `use Text::CSV;`. No necesitamos indicar que
queremos importar porque este modulo no exporta nada. Funciona de una forma orientada a objetos:
necesitas crear una instancia y usar esa instancia.

El propio modulo Text::CSV es una clase y necesitas crear una instancia, también conocida como objeto,
llamando al constructor. En Perl no hay ninguna regla estricta acerca de como nombrar a los constructores
pero la mayoría de la gente usa la palabra "new". La forma de llamar a un constructor es usando la flecha
`->`.

Esta llamada crea un objeto con el separador coma (,).
Un objeto es un valor escalar.

En realidad el carácter coma es el separador por defecto, pero queda más claro si lo indicamos de manera explicita.

`my $csv = Text::CSV->new({ sep_char => ',' });`

El resto del código es más o menos igual que antes, en lugar de tener 2 líneas para dividir
y sumar tenemos unas pocas más líneas que necesitan una pequeña explicación.

El modulo Text::CSV no tiene una función split. Para dividir el texto necesitas llamar a la "función parse"
- o, si queremos usar la terminología OOP - el "método parse". De nuevo usamos la flecha (->) para hacerlo.

`$csv->parse($line)`

Esta llamada tratará de analizar la línea actual y la dividirá en partes. No devuelve estas partes sino
que devuelve verdadero o falso dependiendo si ha podido analizar la línea correctamente o no.
Un caso de común que hará fallar a esta llamada es si hay unas comillas que no se han cerrado. Por ejemplo:
`Kuka,"Hofeherke, alma,100,Kiralyno`

Si falla la parte `else` mostrará un warning y continuará con la siguiente línea.

Si tiene éxito llamaremos al método `fields` que devolverá la partes
en las que cortamos la cadena anteriormente. Después podemos obtener el tercer elemento (2º índice) que
nos da el número requerido.

## Campos multilínea

Puede haber problemas adicionales con el fichero CSV. Por ejemplo si alguno de los campos tiene líneas embebidas.

```
Tudor,Vidor,10,Hapci
Szundi,Morgo,7,Szende
Kuka,"Hofeherke,
alma",100,Kiralyno
Boszorkany,Herceg,9,Meselo
```

La forma en la que procesamos el fichero CSV no puede resolver este problema pero el modulo [Text::CSV](https://metacpan.org/pod/Text::CSV)
proporciona una forma de resolver esto también.

Este ejemplo esta basado en un comentario de H.Merijn Brand, el mantenedor del modulo
[Text::CSV_XS](https://metacpan.org/pod/Text::CSV_XS):

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Text::CSV;

my $file = $ARGV[0] or die "Necesito un fichero CSV como parámetro\n";

my $csv = Text::CSV->new ({
  binary    => 1,
  auto_diag => 1,
  sep_char  => ','    # no se necesita realmente porque es el caracter por defecto
});

my $sum = 0;
open(my $data, '<:encoding(utf8)', $file) or die "No puedo abrir el fichero '$file' $!\n";
while (my $fields = $csv->getline( $data )) {
  $sum += $fields->[2];
}
if (not $csv->eof) {
  $csv->error_diag();
}
close $data;
print "$sum\n";
```

Esto cambia enteramente la forma en la que el fichero es procesado. En lugar de leer
de forma manual línea por línea, le pedimos al modulo Text::CSV leer lo que él considere
una línea. Esto le permitirá manejar campos con líneas embebidas. También usamos otro
par de parámetros en el modulo y cuando abrimos el fichero para asegurarnos de que los
caracteres UTF-8 son procesados adecuadamente.

Además, en este ejemplo el método `getline` devuelve una referencia a un array
- algo que todavía no hemos visto - por lo que para obtener el tercer elemento (2º índice)
necesitamos desreferenciarlo y usar la flecha para obtener el valor: `$fields->[2]`.

Por último,  después de terminar el bucle necesitamos comprobar si hemos llegado al final
del fichero (end-of-file o eof). getline devolverá falso tanto si hemos llegado al final
del fichero como si hemos encontrado un error. Así que comprobamos si se ha alcanzado
el final del fichero y si no es así mostramos un mensaje de error.

## Hofeherke

En caso de que te lo estuvieses preguntado, los valores en el fichero CSV
son los nombres de los [Los siete enanitos](http://hu.wikipedia.org/wiki/H%C3%B3feh%C3%A9rke_%C3%A9s_a_h%C3%A9t_t%C3%B6rpe_%28film,_1937%29).

En Húngaro.

