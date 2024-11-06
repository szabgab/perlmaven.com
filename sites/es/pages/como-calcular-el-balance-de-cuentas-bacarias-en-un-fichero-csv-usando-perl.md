---
title: "Como calcular el balance de cuentas bacarias en un fichero CSV usando Perl"
timestamp: 2014-11-06T07:01:56
tags:
  - CSV
  - split
published: true
original: how-to-calculate-balance-of-bank-accounts-in-csv-file-using-perl
author: szabgab
translator: danimera
---




Uno de los lectores de  [ ¿Como leer un fichero CSV en perl?](/como-leer-un-fichero-csv-en-perl) artículo me ha enviado un archivo CSV y una pregunta:
<b>Cómo calcular y Mostrar saldo total en cada cuenta usando hash en perl. Sin necesidad de utilizar  función parse?</b>

¿Vamos a ver cómo podemos manejar dicha solicitud?



```
TranID,Date,AcNo,Type,Amount,ChequeNo,DDNo,Bank,Branch
13520,01-01-2011,5131342,Dr,5000,,,,
13524,01-01-2011,5131342,Dr,1000,,416123,SB,Ashoknagar
13538,08-01-2011,5131342,Cr,1620,19101,,,
13548,17-01-2011,5131342,Cr,3500,19102,,,
13519,01-01-2011,5522341,Dr,2000,14514,,SBM,Hampankatte
13523,01-01-2011,5522341,Cr,500,19121,,,
13529,02-01-2011,5522341,Dr,5000,13211,,SB,Ashoknagar
13539,09-01-2011,5522341,Cr,500,19122,,,
13541,10-01-2011,5522341,Cr,2000,19123,,,
```


Al principio no estaba claro dónde se metió o si ha hecho algún progreso en absoluto.
Con el fin de ayudarlo tenia que tratar de entender  a donde él quería llegar y donde está atascado.

Le pedí el código que había escrito y tengo este script:

```perl
#!/usr/bin/perl

print "Content-type:text/html\n\n";

my $sum;
my $sum1;
my $sum2;

open(FILEHANDLE, "<banktran.csv") or die "Could not open 'banktran.csv' $!\n";

while (my $line = <FILEHANDLE>) {
  chomp $line;
  my @fields = split "," , $line;

  if ($fields[2] eq 5131342) {
    if ($fields[3] eq Dr) {
      $sum1 += $fields[4];
    } else {
      $sum2 += $fields[4];
    }
    $sum = $sum1-$sum2;
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}

close(FILEHANDLE);
```

Además de algunas cuestiones obvias de principiante que empecé a entender, probablemente quiere crear un informe
por separado para cada cuenta - la tercera columna - <b>AcNo</b> es probablemente el número de cuenta.

La cantidad es en la quinta columna bajo el título de <b>Amount</b>.

Como puedo ver la cuarta columna indica el tipo de la transacción.
Una pequeña búsqueda indica que Dr sería débito y Cr sería crédito, aunque en el código  parece ser lo contrario.

La primera oración en la pregunta parece indicar que ya entendió que necesita utilizar hashes,
en lugar de las variables escalares `$sum`, pero todavía no está claro a él cómo.

La segunda oración, <b>sin necesidad de utilizar la función parse?</b>
parece indicar que me que por alguna razón el lector no puede usar el módulo de Text::CSV que tiene el método parse.
Es una lástima, ya que es la herramienta adecuada en el caso general de análisis y lectura de archivos CSV,
pero en muchos entornos corporativos es difícil instalar un módulo de CPAN. Especialmente a alguien que es nuevo en Perl.

Suponiendo que la CSV file es simple - sin  separadores, sin saltos de línea embebidos - podemos manejarlo con una llamada a la función `split`.


¿El código que me envió es razonable para alguien que empieza a usar Perl,
vamos a ver cómo podemos mejorarlo y cómo podemos tratar de implementar lo que el necesitaba?


## Ejecutando el codigo

Antes de tratar de mejorar el codigo, vamos a ver si ejecuta, y que es lo que hace? El script es guardado
como <b>banktran.pl</b> y el fichero csv como <b>banktran.csv</b>

<b>perl bantran.pl</b>

```
Content-type:text/html

Total Balance of Account Number is Rs.5000
Total Balance of Account Number is Rs.6000
Total Balance of Account Number is Rs.4380
Total Balance of Account Number is Rs.880
```

Ahora que vemos que hace algo podemos hacer algunas mejoras:


## use strict and use warnings

En primer lugar, recomiendo muy fuertemente cada script en Perl  comenzar con las dos declaraciones de la red de seguridad.
Sé que puedo perder mucho tiempo buscando errores que estos dos pueden capturar, así que no quiero estar sin ellos.

```perl
use strict;
use warnings;
```

Viene justo después del sh-bang. Si agregamos esto al código anterior e intento ejecutarlo otra vez obtenemos lo siguiente:


```
Bareword "Dr" not allowed while "strict subs" in use at banktran.pl line 18.
 Execution of banktran.pl aborted due to compilation errors.
```

[ Bareword not allowed while "strict subs" in use (en)](https://perlmaven.com/barewords-in-perl)
es uno de los avisos comúnes que se describe en el [ tutorial de Perl Maven](/perl-tutorial).
Tenemos que poner las comillas sencillas `'` a la cadena <b>Dr</b>

Al ejecutar el script otra vez obtenemos lo siguiente:


```
Content-type:text/html

Use of uninitialized value $sum2 in subtraction (-) at banktran.pl line 23, <FILEHANDLE> line 2.
Total Balance of Account Number is Rs.5000
Use of uninitialized value $sum2 in subtraction (-) at banktran.pl line 23, <FILEHANDLE> line 3.
Total Balance of Account Number is Rs.6000
Total Balance of Account Number is Rs.4380
Total Balance of Account Number is Rs.880
```


La advertencia  [ Use of uninitialized value (en)](https://perlmaven.com/use-of-uninitialized-value)
es otra advertencia común en Perl. Significa que el `$sum2` era undef en línea 23.



```perl
$sum = $sum1-$sum2;
```

Probablemente deberíamos inicializar las variables a 0. No siempre es necesario, pero puede conducir
a un código limpio. El código resultante hasta ahora tiene este aspecto:


```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my $sum  = 0;
my $sum1 = 0;
my $sum2 = 0;

open(FILEHANDLE, "<banktran.csv") or die "Could not open 'banktran.csv' $!\n";

while (my $line = <FILEHANDLE>) {
  chomp $line;
  my @fields = split "," , $line;

  if ($fields[2] eq 5131342) {
    if ($fields[3] eq 'Dr') {
      $sum1 += $fields[4];
    } else {
      $sum2 += $fields[4];
    }
    $sum = $sum1-$sum2;
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}

close(FILEHANDLE);
```

## Usando el modo open "moderno"

Puse la palabra "moderno" entre comillas porque esto está disponible desde el año 2000 no es realmente
nuevo, pero aún así muchas personas aprenden primero el viejo estilo.

Hay un artículo porqué uno
[ no debe abrir los archivos de la antigua forma en Perl (en)](https://perlmaven.com/open-files-in-the-old-way),
No lo repetiré aquí, sólo lo arreglare el código:


```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my $sum  = 0;
my $sum1 = 0;
my $sum2 = 0;

my $filename = 'banktran.csv';
open(my $FILEHANDLE, '<', $filename) or die "Could not open '$filename' $!\n";

while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my @fields = split "," , $line;

  if ($fields[2] eq 5131342) {
    if ($fields[3] eq 'Dr') {
      $sum1 += $fields[4];
    } else {
      $sum2 += $fields[4];
    }
    $sum = $sum1-$sum2;
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}

close($FILEHANDLE);
```

Como puedes ver cambié `FILEHANDLE` para ser el léxico escalar `$FILEHANDLE`,
usando 3 parámetros en  la función `open` y también poner el nombre del archivo en una variable.

Este último paso es importante por dos razones:
<ol>
<li>Facilitará pasar el nombre del archivo como un parámetro, si es necesario`
<li>No caemos en la trampa de cambiar el nombre en la llamada `open()` y dejando el antiguo nombre en la
llamada `die()` y confundirse por el mensaje de error.</li>
</ol>


## Mejores nombres de variables

El hecho de que estamos utilizando una matriz llamada `@fields` e índices en ese arreglo
no esta claro que tipos de valores estan esos campos.

Rápidamente, ¿puedes recordar lo que está en $fields [2]? No puedo. Así que en lugar de utilizar la matriz de @fields
Podríamos utilizar variables con mejores  nombres y escribir:

## Better variable names

The fact that we are using and array called `@fields` and indexes in that array
makes it unclear what kind of values are in those field.

```perl
my ($id, $date, $account, $type, $amount, $cheque, $dd, $bank, $branch)
    = split "," , $line;
```

Esto volvió un poco más larga la línea de arriba, pero hará el resto del código más legible.
Esto también hace nos hace crear algunas variables innecesarias


[Advanced Perl developers (en)](https://perlmaven.com/advanced-perl-maven-e-book) podría hacerlo mejor mediante el uso de una rebanada de matriz:


```perl
my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];
```

El bucle tendrá este aspecto:

```perl
while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];

  if ($account eq 5131342) {
    if ($type eq 'Dr') {
      $sum1 += $amount;
    } else {
      $sum2 += $amount;
    }
    $sum = $sum1-$sum2;
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}
```

## Eliminar variables temporales

Como puedo ver las variables `$sum1` y `$sum2` se utilizan solamente para sostener
los valores que necesitan ser agregadas a la $suma o se deduce de aqui. Realmente no los necesitamos.
Podríamos añadir a `$suma` o deducir de él dentro de la condición:


```perl
  if ($account eq 5131342) {
    if ($type eq 'Dr') {
      $sum += $amount;
    } else {
      $sum -= $amount;
    }
```

Vamos a ver y probar el código completo de nuevo, antes de la operación.

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my $sum  = 0;

my $filename = 'banktran.csv';
open(my $FILEHANDLE, '<', $filename) or die "Could not open '$filename' $!\n";

while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];

  if ($account eq 5131342) {
    if ($type eq 'Dr') {
      $sum += $amount;
    } else {
      $sum -= $amount;
    }
    print "Total Balance of Account Number is Rs.$sum\n";
  }
}

close($FILEHANDLE);
```

## Mostrar el total de todas las cuentas

Ahora, sólo una cuenta específica (id = 5131342) se resume y se realiza en una variable escalar.
En lugar de esto, nos gustaría resumir todas las cuentas. La forma más sencilla es utilizar un hash.
Los identificadores de cuenta serán las llaves y la suma será el valor.

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my %sum;

my $filename = 'banktran.csv';
open(my $FILEHANDLE, '<', $filename) or die "Could not open '$filename' $!\n";

while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];

  if ($type eq 'Dr') {
    $sum{$account} += $amount;
  } else {
    $sum{$account} -= $amount;
  }
  print "Total Balance of Account Number $account is Rs.$sum{$account}\n";
}

close($FILEHANDLE);
```

En este código no necesitamos el `if ($account eq 5131342)` de la condición más.
Podemos acceder a la clave hash directamente, utilizando el número de `$account` como clave.



Después de ejecutar el script el resultado se ve así:

```
Content-type:text/html

Argument "Amount" isn't numeric in subtraction (-) at banktran.pl line 19, <$FILEHANDLE> line 1.
Total Balance of Account Number AcNo is Rs.0
Total Balance of Account Number 5131342 is Rs.5000
Total Balance of Account Number 5131342 is Rs.6000
Total Balance of Account Number 5131342 is Rs.4380
Total Balance of Account Number 5131342 is Rs.880
Total Balance of Account Number 5522341 is Rs.2000
Total Balance of Account Number 5522341 is Rs.1500
Total Balance of Account Number 5522341 is Rs.6500
Total Balance of Account Number 5522341 is Rs.6000
Total Balance of Account Number 5522341 is Rs.4000
```

La advertencia que obtenemos es debido a la primera línea en el archivo CSV. Antes no teníamos que
preocuparnos por lo que sólo nos ocupabamos de las filas donde el id de la cuenta coinsidiera con el número seleccionado,
pero ahora tenemos que pasar esa línea. Es fácil, solo leer la primera fila antes del bucle
`while` y sacarla.


```perl
<$FILEHANDLE>;
while (my $line = <$FILEHANDLE>) {
```

## Total sólo al final?

Esto podría ser la versión final, pero no está claro para mí si realmente necesitamos Mostrar el equilibrio después de cada fila,
o solamente en el final. Así que vamos a hacer otro cambio que mostrará los resultados solamente en el final.

Quitamos la llamada `print` del bucle `while` y añada otro bucle final, revisando todas las
cuentas y mostrar el estado de cuenta:


```perl
foreach my $account (sort keys %sum) {
  print "Total Balance of Account Number $account is Rs.$sum{$account}\n";
}
```

El código completo

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type:text/html\n\n";

my %sum;

my $filename = 'banktran.csv';
open(my $FILEHANDLE, '<', $filename) or die "Could not open '$filename' $!\n";

<$FILEHANDLE>;
while (my $line = <$FILEHANDLE>) {
  chomp $line;
  my ($account, $type, $amount) = (split "," , $line)[2, 3, 4];

  if ($type eq 'Dr') {
    $sum{$account} += $amount;
  } else {
    $sum{$account} -= $amount;
  }
}

close($FILEHANDLE);

foreach my $account (sort keys %sum) {
  print "Total Balance of Account Number $account is Rs.$sum{$account}\n";
}
```

Hay sólo una cosita que todavía me molesta. Por qué imprimimos Content-type
¿al principio del código? ¿Esto va a funcionar como un script CGI?

Si no, entonces podríamos eliminar esa línea.

Si esto es un script CGI entonces nosotros deberíamos probablemente imprimir HTML real. Por lo menos deberíamos
imprimir etiquetas pre alrededor del informe.



