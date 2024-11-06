---
title: "Pinto: CPAN personalizado fácil de usar"
timestamp: 2013-05-03T16:30:10
tags:
  - cpan
  - pinto
published: true
original: pinto-tutorial
author: thalhammer
translator: enrique
---


<i>
Artículo de invitado escrito por [Jeffrey Ryan Thalhammer](http://twitter.com/thaljef), creador de
Pinto y Perl::Critic. Jeff gestiona una pequeña empresa de consultoría en San Francisco y es un miembro activo
de la comunidad Perl desde hace muchos años. Está realizando una campaña de
[recaudación de fondos](https://www.crowdtilt.com/campaigns/specify-module-version-ranges-in-pint)
hasta el 7 de mayo para financiar el desarrollo de una característica que permitirá <b>especificar intervalos
de versiones de módulos en Pinto</b>.
</i>


This article was originally published on [Pragmatic Perl](http://pragmaticperl.com/)

Una de las mayores ventajas que ofrece Perl es la enorme cantidad de módulos open source que están disponibles
en CPAN. Sin embargo, la administración de estos módulos puede resultar complicada. Cada semana se publican
cientos de versiones nuevas y no es fácil saber si los cambios realizados en una nueva versión de un módulo
pueden generar errores que afecten a nuestras aplicaciones.


Una estrategia posible para solucionar este problema es crear un repositorio personalizado de CPAN que contenga
únicamente las versiones de los módulos que necesitas. Puedes usar la cadena de herramientas de CPAN para generar
la aplicación a partir de los módulos del repositorio personalizado sin exponerla al trasiego del repositorio
público de CPAN.

A lo largo de los años he creado varios repositorios personalizados de CPAN con herramientas como
[CPAN::Mini](https://metacpan.org/pod/CPAN::Mini) y
[CPAN::Site](https://metacpan.org/pod/CPAN::Site). Pero esta solución es un poco engorrosa y nunca
me ha parecido realmente satisfactoria. Hace un par de años un cliente me contrató para desarrollar otro repositorio
personalizado de CPAN. Esta vez, sin embargo, pude partir de cero. Pinto es el resultado de ese trabajo.

[Pinto](https://metacpan.org/pod/Pinto) es una herramienta sólida que permite crear y administrar un
repositorio personalizado de CPAN. Ofrece varias características muy eficaces que ayudan a administrar de forma
efectiva todos los módulos de Perl de los que depende una aplicación. Con este tutorial aprenderás a utilizar Pinto
para crear un repositorio personalizado de CPAN y de paso verás cómo funcionan algunas de estas características.

## Instalar Pinto

Pinto está disponible en CPAN y se puede instalar como cualquier otro módulo mediante las utilidades cpan y
`cpanm`. Pero Pinto se parece más a una aplicación que a una biblioteca. Es una herramienta que se puede
usar para administrar el código de la aplicación, pero que en realidad no forma parte de la aplicación. Por eso
recomiendo instalar Pinto como una aplicación autónoma con estos dos comandos:
```
curl -L http://getpinto.stratopan.com | bash
source ~/opt/local/pinto/etc/bashrc
```

Esto instalará Pinto en `~/opt/local/pinto` y agregará los directorios necesarios a las variables de entorno
`PATH` y `MANPATH`. Todo está autocontenido, por lo que la instalación de Pinto no cambiará nada en
el entorno de desarrollo, ni los cambios realizados en el entorno de desarrollo afectarán a Pinto.

## Explorar Pinto

Como en cualquier herramienta nueva, lo primero que hay que aprender es cómo obtener ayuda:

```
pinto commands            # Muestra una lista de comandos disponibles
pinto help <COMANDO>      # Muestra un resumen de opciones y argumentos <COMANDO>
pinto manual <COMANDO>    # Muestra el manual completo de <COMANDO>
```

Pinto incluye además otros documentos, como un tutorial y una guía de referencia rápida. Para tener acceso a estos
documentos se pueden usar los comandos siguientes:

```
man Pinto::Manual::Introduction  # Explica los conceptos básicos de Pinto
man Pinto::Manual::Installing    # Sugerencias para instalar Pinto
man Pinto::Manual::Tutorial      # Guía descriptiva de Pinto
man Pinto::Manual::QuickStart    # Muestra un resumen de comandos comunes
```

## Crear un repositorio

El primer paso para usar Pinto es crear un repositorio con el comando `init`:

```
pinto -r ~/repo init
```

Esto creará un repositorio nuevo en el directorio `~/repo`. Si ese directorio no existe,
se creará automáticamente. Si ya existe, debe estar vacío. La marca -r (o --root) permite especificar
dónde se encuentra el repositorio. Se debe usar en cada comando de pinto. Para evitar escribirla en
cada comando, puedes hacer que la variable de entorno `PINTO_REPOSITORY_ROOT` apunte al
repositorio; así podrás omitir la marca -r.


## Inspeccionar el repositorio

Ahora que tienes un repositorio, veamos qué contiene. Para ver el contenido de un repositorio, usa
el comando "list":

```
pinto -r ~/repo list
```

De momento la lista está vacía, ya que aún no has agregado nada al repositorio. Pero usarás a menudo
el comando "list" en este tutorial.

## Agregar módulos de CPAN

Supón que quieres trabajar en un aplicación llamada Mi-Apl que contiene un módulo denominado Mi::Apl
y que este módulo depende del módulo URI. Puedes agregar el módulo URI al repositorio con el comando
`pull`:

```
pinto -r ~/repo pull URI
```

Te pedirá que escribas un mensaje de registro que describa la razón de este cambio. Al principio de
la plantilla de mensaje se incluye un mensaje sencillo generado automáticamente que puedes modificar.
Al final de la plantilla de mensaje se indican los módulos que se han agregado. Una vez modificado el
mensaje, guarda el archivo y cierra el editor.

El módulo URI debería estar ya en el repositorio de Pinto. Compruébalo. Vuelve a usar el comando
`list` para ver el contenido del repositorio:

```
pinto -r ~/repo list
```

Esta vez, la lista será similar a la siguiente:

```
rf  URI                             1.60 GAAS/URI-1.60.tar.gz
rf  URI::Escape                     3.31 GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                  4.20 GAAS/URI-1.60.tar.gz
...
```

Puedes ver que se ha agregado el módulo URI al repositorio, así como todos los requisitos previos de
URI y los requisitos previos de estos, y así sucesivamente.

## Agregar módulos privados

Ahora supón que has acabado de trabajar en Mi-Apl y deseas publicar la primera versión. Puedes utilizar
tu herramienta de compilación preferida (p. ej., ExtUtils::MakeMaker, Module::Build, Module::Install, etc.)
para empaquetar la versión: Mi-Apl-1.0.tar.gz. Ahora agrega la distribución al repositorio de Pinto con el
comando `add`:

```
$&gt; pinto -r ~/repo add ruta/de/Mi-Apl-1.0.tar.gz
```

Te ofrece la oportunidad de escribir un mensaje que describa el cambio. Si ahora muestras el contenido del
repositorio, verás que incluye el módulo Mi::Apl y aparecerás como autor de la distribución:

```
rl  Mi::Apl                         1.0 JEFF/Mi-Apl-1.0.tar.gz
rf  URI                             1.60 GAAS/URI-1.60.tar.gz
rf  URI::Escape                     3.31 GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                  4.20 GAAS/URI-1.60.tar.gz
...
```


## Instalar módulos

Ahora que tus módulos están en el repositorio de Pinto, el siguiente paso es compilarlos e instalarlos en
algún lugar. Internamente, la organización de un repositorio de Pinto es idéntica a la de un repositorio
de CPAN, por lo que es totalmente compatible con cpanm y cualquier otro instalador de módulos Perl.
Solo tienes que hacer que el instalador apunte al repositorio de Pinto:

```
cpanm --mirror file://$HOME/repo --mirror-only Mi::Apl
```

Este comando generará e instalará Mi::Apl utilizando *únicamente* los módulos del repositorio de Pinto.
Así se utilizarán siempre las mismas versiones de estos módulos, aunque se quite o se actualice el módulo
del repositorio de CPAN público.

Con cpanm, la opción --mirror-only es importante, ya que evita que cpanm use el repositorio público de
CPAN cuando no encuentre un módulo en tu repositorio. Cuando esto ocurre, suele significar que no se
han declarado correctamente las dependencias en el archivo META de alguna distribución del repositorio.
Para solucionar este problema, usa el comando `pull` para recuperar los módulos que faltan.


## Actualizar módulos

Supón que han pasado varias semanas desde que publicaste la primera versión de Mi-Apl y ahora está
disponible la versión 1.62 del módulo URI en CPAN. En esta versión se han solucionado algunos errores
críticos, por lo que sería conveniente utilizar la nueva versión. Puedes usar el comando `pull`
para agregar la nueva versión al repositorio. Pero como el repositorio ya contiene una versión de URI,
tienes que indicar que deseas utilizar una versión <b>más reciente</b> especificando la versión mínima:

```
pinto -r ~/repo pull URI~1.62
```

Ahora en la lista aparecerá la versión más reciente de URI (y posiblemente la más reciente de otros
módulos también):

```
rl  Mi::Apl                         1.0 JEFF/Mi-Apl-1.0.tar.gz
rf  URI                             1.62 GAAS/URI-1.62.tar.gz
rf  URI::Escape                     3.38 GAAS/URI-1.62.tar.gz
rf  URI::Heuristic                  4.20 GAAS/URI-1.62.tar.gz
...
```

Si la nueva versión de URI requiere dependencias actualizadas o adicionales, también se agregarán al
repositorio. Al instalar Mi::Apl se usa la versión 1.62 de URI.

## Trabajar con pilas

Hasta ahora hemos tratado el repositorio como un recurso singular. La actualización de URI de la sección
anterior afectó a todos los usuarios y todas las aplicaciones que usan el repositorio. Pero no suele ser
deseable un impacto tan amplio. Es preferible realizar cambios en un entorno aislado y probarlos antes
de forzar a los usuarios a actualizar. Para esto se diseñaron las pilas.

Todos los repositorios estilo CPAN tienen un índice que establece una correspondencia entre la versión
más reciente de cada módulo y el archivo de almacenamiento que lo contiene. Generalmente hay un solo
índice por repositorio. Pero en un repositorio de Pinto puede haber varios índices. Cada uno de estos
índices es una <b>"pila"</b>. Esto permite crear distintas pilas de dependencias en un solo repositorio.
Así, puedes tener una pila de "desarrollo" y una pila de "producción", o una pila de "perl-5.8" y otra
de "perl-5.16". La adición o actualización de un módulo sólo afectará a una pila.

Pero antes de continuar, debes saber qué es la pila predeterminada. Para la mayoría de las operaciones,
el nombre de la pila es un parámetro opcional. Así, si no se especifica una pila explícitamente, el comando
se aplicará a la pila que esté marcada como predeterminada.

En un repositorio no puede haber más de una pila predeterminada. Al crear este repositorio se creó una pila
denominada "master" que se marcó como predeterminada. Puedes cambiar la pila predeterminada o cambiar el
nombre de la pila, pero no vamos a entrar en ese tema. Solo debes recordar que "master" es el nombre de
la pila que se creó al inicializar el repositorio.

<h3>Crear una pila</h3>

Supón que el repositorio contiene la versión 1.60 de URI y se acaba de publicar la versión 1.62 en CPAN.
La actualización parece interesante y quieres aplicarla, pero esta vez vas a hacerlo en una pila distinta.

Hasta ahora, siempre has agregado todo a la pila "master". Ahora vas a crear un clon de esa pila con el
comando `copy`:

```
pinto -r ~/repo copy master actualizar_uri
```

Esto crea una nueva pila llamada "actualizar_uri". Para ver el contenido de esa pila puedes usar el comando
`list` con la opción "--stack":

```
pinto -r ~/repo list --stack actualizar_uri
```

La lista debería ser idéntica a la de la pila "master":

```
rl  Mi::Apl                        1.0 JEFF/Mi-Apl-1.0.tar.gz
rf  URI                            1.60 GAAS/URI-1.60.tar.gz
...
```

<h3>Actualizar una pila</h3>

Ahora que tienes otra pila, prueba a actualizar URI. Como antes, debes usar el comando `pull`.
Pero esta vez, hay que decir a Pinto que use los módulos de la pila "actualizar_uri":

```
pinto -r ~/repo pull --stack actualizar_uri URI~1.62
```

Puedes usar el comando "diff" para comparar las pilas "master" y "actualizar_uri":

```
pinto -r ~/repo diff master actualizar_uri

+rf URI                                             1.62 GAAS/URI-1.62.tar.gz
+rf URI::Escape                                     3.31 GAAS/URI-1.62.tar.gz
+rf URI::Heuristic                                  4.20 GAAS/URI-1.62.tar.gz
...
-rf URI                                             1.60 GAAS/URI-1.60.tar.gz
-rf URI::Escape                                     3.31 GAAS/URI-1.60.tar.gz
-rf URI::Heuristic                                  4.20 GAAS/URI-1.60.tar.gz
```

La salida es similar a la del comando diff(1). Los registros que empiezan por "+" indican una adición
y los que empiezan por "-" indican una eliminación. Puedes comprobar que se han reemplazado los módulos
de la distribución URI-1.60 por los de la distribución URI-1.62.

<h3>Instalar desde una pila</h3>

Ahora que ya tienes los módulos nuevos en la pila "actualizar_uri", puedes hacer que cpanm apunte a la
pila e intentar generar la aplicación. Cada pila no es más que un subdirectorio dentro del repositorio,
por lo que todo lo que tienes que hacer es agregarlo a la dirección URL:

```
cpanm --mirror file://$HOME/repo/stacks/actualizar_uri --mirror-only Mi::Apl
```

Si se superan todas las pruebas, puedes actualizar URI a la versión 1.62 tranquilamente en la pila "master"
mediante el comando `pull`. Como "master" es la pila predeterminada, puedes omitir el parámetro "--stack":

```
pinto -r ~/repo pull URI~1.62
```

## Trabajar con anclas

Las pilas son una buena manera de probar el efecto de los cambios en las dependencias de una aplicación.
¿Y si no se superan las pruebas? Si el problema está en Mi-Apl y se puede corregir rápidamente, sólo tienes
que modificar el código, publicar la versión 2.0 de Mi-Apl y después actualizar URI en la pila "master".

Pero si el problema es un error del módulo URI o si corregir Mi-Apl requiere tiempo, entonces necesitas una
alternativa. Hay que evitar que alguien actualice URI o que se actualice inadvertidamente para satisfacer
otros requisitos previos de Mi-Apl. Hasta que se haya corregido el problema, hay que evitar que se actualice
URI. Para esto sirven las anclas.

<h3>Anclar un módulo</h3>

Cuando se ancla un módulo, se mantiene obligatoriamente esa versión del módulo en una pila. Cualquier intento
de actualizarlo (ya sea directamente o estableciendo otro requisito previo) generará un error. Para anclar un
módulo, usa el comando `pin`:

```
pinto -r ~/repo pin URI
```

Ahora, al mostrar la lista de la pila "master" verás algo similar a esto:

```
...
rl  Mi::Apl                         1.0 JEFF/Mi-Apl-1.0.tar.gz
rf! URI                             1.60 GAAS/URI-1.60.tar.gz
rf! URI::Escape                     3.31 GAAS/URI-1.60.tar.gz
...
```

El signo "!" al principio de un registro indica que se ha anclado el módulo. Si alguien intenta actualizar URI
o agregar una distribución que requiere una versión más reciente de URI, Pinto emitirá una advertencia y rechazará
las nuevas distribuciones. Hay que tener en cuenta que se ha anclado cada módulo de la distribución URI-1.60, por
lo que es imposible realizar una actualización parcial de una distribución (esto puede suceder cuando se mueve un
módulo a otra distribución).

<h3>Desanclar un módulo</h3>

Supón que, al cabo de un tiempo, corriges el problema en Mi-Apl o se publica una nueva versión de URI con el
problema corregido. En este caso, puedes desanclar URI de la pila mediante el comando `unpin`:

```
pinto -r ~/repo unpin URI
```

Ahora ya puedes actualizar URI a la versión más reciente. De forma análoga a lo que ocurre cuando anclamos un
módulo, al desanclarlo también se desanclan los demás módulos de la distribución.

## Uso combinado de pilas y anclas

Las anclas y las pilas se pueden usar conjuntamente como ayuda para administrar los cambios durante el ciclo
de desarrollo. Por ejemplo, podrías crear una pilla llamada "prod" que contenga todas las dependencias que
sabemos que funcionan. Paralelamente, podrías crear una pila llamada "dev" con dependencias experimentales
para la siguiente versión. Inicialmente, la pila "dev" sólo es una copia de la pila "prod".

A medida que avanza el desarrollo, puedes actualizar o agregar varios módulos a la pila "dev". Si un módulo
actualizado genera un error en la aplicación, lo anclas en la pila "prod" para indicar que no se debe actualizar.

<h3>Anclas y parches</h3>

A veces puede ocurrir que encuentras un error en una nueva versión de una distribución de CPAN y el autor de la
misma no puede o no quiere corregirlo (al menos hasta que publique la siguiente versión). En esta situación,
puedes optar por crear un parche local de la distribución de CPAN.

Supón que has realizado un I&lt;fork&gt; del código de URI para crear una versión local de la distribución llamada
URI-1.60_PATCHED.tar.gz. Puedes agregarla al repositorio mediante el comando `add`:

```
pinto -r ~/repo add ruta/de/URI-1.60_PATCHED.tar.gz
```

En esta situación también es recomendable anclar el módulo, ya que hay que evitar actualizar hasta estar seguros de
que la nueva versión de CPAN incluye el parche o el autor ha corregido el error por su cuenta.

```
pinto -r ~/repo pin URI
```

Cuando el autor de URI publique la versión 1.62, debes probarla para decidir si puedes desanclarla de la versión
local a la que aplicaste el parche. Igual que antes, esto se puede hacer clonando la pila con el comando `copy`.
Asigna el nombre "prueba" a esta pila:

```
pinto -r ~/repo copy master prueba
```

Pero antes de actualizar URI en la pila "prueba", tienes que desanclarlo en esta pila:

```
pinto -r ~/repo unpin --stack prueba URI
```

Ahora puedes actualizar URI en la pila e intentar generar Mi::Apl con este comando:

```
pinto -r ~/repo pull --stack prueba URI~1.62 cpanm --mirror file://$HOME/repo/stacks/prueba --mirror-only Mi::Apl
```

Si todo va bien, podrás quitar el ancla de la pila "master" y volver a agregar a esta pila la versión más reciente
de URI.

```
pinto -r ~/repo unpin URI 
pinto -r ~/repo pull URI~1.62
```

## Revisar cambios anteriores

Como habrás visto, cada comando que modifica la pila requiere escribir un mensaje de registro para describir el cambio.
Para revisar estos mensajes, puedes usar el comando `log`:

```
pinto -r ~/repo log
```

Esto mostrará algo similar a:

```
revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

    Pin GAAS/URI-1.59.tar.gz
    
    URI anclado porque crea un error en el script foo.t
    
revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

    Pull GAAS/URI-1.59.tar.gz
    
    URI es necesario para usar HTTP en nuestra aplicación
    
...
```

El encabezado de cada mensaje indica quién realizó el cambio y cuándo se realizó. También tiene un identificador único,
similar a los resúmenes criptográficos SHA-1 de Git. Puedes usar estos identificadores para ver las diferencias entre
distintas revisiones o para restablecer la pila en una revisión anterior [Nota: esta característica aún no se ha
implementado].

## Conclusión

En este tutorial has visto los comandos básicos para crear un repositorio de Pinto y agregar módulos al repositorio.
También has aprendido a usar pilas y anclas para administrar las dependencias ante algunos obstáculos comunes del ciclo
de desarrollo. Cada comando usado en este tutorial ofrece otras opciones que no hemos descrito, y hay otros comandos
que no hemos mencionado en el tutorial, por lo que te recomendamos que explores las páginas de manual para continuar
con tu aprendizaje.

