---
title: "Como funciona el world wide web ?"
timestamp: 2014-08-29T18:00:01
tags:
  - URL
  - Ajax
  - JSON
  - XML
published: true
original: how-does-the-world-wide-web-work
author: szabgab
translator: danimera
---


Un breve resumen de "la web" o "Internet" como algunas personas lo llaman.

Para el técnicamente más orientado: "Internet" es la red interconectada de dispositivos (ordenadores, teléfonos móviles, tabletas, routers, módems, etc.),
mientras que "la Web" es el subconjunto de "Internet" que es generalmente accesible a través de los protocolos `http` o `https` y se ve generalmente en un "browser".



En su ordenador, teléfono móvil o tablet tiene una aplicación de software llamada  "navegador web".
(Los navegadores principales son [Mozilla Firefox](http://www.mozilla.org/en-US/firefox/new/),
[Google Chrome](https://www.google.com/intl/en/chrome/browser/),
[Apple Safari](https://www.apple.com/safari/),
[Opera](http://www.opera.com/), and
[Microsoft Internet Explorer](http://windows.microsoft.com/en-us/internet-explorer/download-ie)).

Escribe una dirección web (también llamada una "[ URL](https://en.wikipedia.org/wiki/Url)") en la barra de direcciones: algo como www.google.com o perlmaven.com/perl-tutorial,
o incluso sólo una [ dirección IP](https://en.wikipedia.org/wiki/Ip_address) como 127.0.0.1. Si no se suministra el `Protocolo`, el navegador lo añadirá y automáticamente cambia la dirección a http://www.google.com o https://perlmaven.com/perl-tutorial.
Luego hace un trabajo de fondo traduciendo la dirección con el número IP del servidor, que no vamos a discutir aquí,
y envía una solicitud para traer la página adecuada desde el equipo correcto en algún lugar, posiblemente en el otro lado del mundo.


El computador del otro lado, ejecuta un programa de software llamado  servidor web. (Los principales servidores de código abierto son [ Apache](http://httpd.apache.org/) y [ nginx](http://nginx.org/),
y de propietario [ Microsoft IIS](http://www.iis.net/))

Estos servidores web pueden configurarse para asignar a cada solicitud un archivo específico en el sistema de archivos para ser mostrado como él-es.
Esto crearía un sitio web estático. Un sitio que no puede tomar ninguna entrada de usted, el usuario.

Por otro lado, el servidor web puede configurarse para ejecutar un programa cuando el usuario solicita una página.
El programa puede ser escrito en muchos lenguajes de programación diferentes y hay un número de diferentes formas de llamarlos.



## Las 3 formas principales  de mostrar una página dinámica

<b>CGI</b>: una de las formas más básicas y probablemente la más vieja, se llama `CGI`. Al recibir una solicitud desde el navegador,
el servidor web establece  ciertas variables de entorno y ejecutar el programa requerido. Ese programa procesará
la solicitud e imprimirá los resultados a la salida estándar. El servidor web captura esta salida y envía a su
navegador que intentará mostrarla para ti. Estos programas generalmente están escritos en Perl o en algún otro lenguaje dinámico
que el público en general se refiere como "lenguaje de scripting". Por lo tanto, estos programas se llaman generalmente <b>los scripts CGI</b>.
La ventaja de los scripts CGI es que pueden ser escritos en cualquier lenguaje. Una vez configurado el servidor web puede incluso
sustituir los scripts por otros escritos en otros lenguajes. Es muy sencillo escribir scripts CGI. La desventaja es
que, para cada solicitud, el servidor web tendrá que engendrar un nuevo proceso, que puede ser mucho tiempo. Para sitios web simples
que sólo tienen unas pocas 10s de solicitudes por hora esto no suele ser un problema, pero cuando el sitio está ocupado esto puede tener un mal impacto
en el tiempo de respuesta.


<b>Embedded intérprete</b>: otra forma es incrustar el intérprete del  "lenguaje" deseado dentro del servidor web. PHP funciona de esta manera
y [ mod_perl](https://perl.apache.org/) proporciona esta funcionalidad para Perl cuando se usa el Apache webserver.
Esto es mucho más rápido que el CGI - por ejemplo mod_perl pueden ser 200 veces más rápido que el CGI/Perl, pero esto relaciona la implementacion del lenguaje y el servidor web. Esto hace un poco más rígido el desarrollo y despliegue.



<b>Servidor de aplicaciones</b>: la tercera vía es utilizando un "application server". En este caso hay un servidor adicional, a menudo llamado un "application server"
corriendo junto con el servidor web. Cada vez que el servidor web recibe una petición para una página dinámica, la da al
servidor de aplicaciones. El servidor de aplicaciones es lenguaje específico y cuenta con todas las aplicaciones cargado en la memoria y compilado una vez.
Las aplicaciones escritas en Java generalmente utilizan un servidor de aplicaciones.


[ FastCGI](http://www.fastcgi.com/) es básicamente un servidor de aplicaciones independiente del lenguaje con un nombre un poco desafortunado.

Starman y otros servidores  [ basados en  PSGI](http://plackperl.org/) pueden funcionar como servidores web independiente
(el sitio de Perl Maven solía correr en Starman como un servidor web), o como servidores de aplicaciones. Generalmente se trata de un servidor Apache o Nginx frente a tales servidores basados en PSGI. (El sitio de Perl Maven actualmente corre sobre Nginx en frente de  Starman).
En todos estos casos la aplicación escrita en Perl está incrustada en el servidor PSGI-based proporcionando rapidez y flexibilidad.
Otros lenguajes, como Python y Ruby tienen sus propios respectivos "servidores de aplicaciones".

## ¿Qué lo pagarán desde el servidor web

Cuando accedes a una dirección URL que generalmente vuelve es un archivo con texto mediante HTML (Hyper Text Markup Language) que
describe qué parte es el título, qué son lista de elementos etc.. Además, una página HTML se refiere generalmente a un número de
archivos adicionales (por ejemplo: imágenes). Después de que el navegador reciba el archivo HTML se analiza y solicitará
los archivos adicionales desde el servidor web. Al mismo tiempo intenta procesar el archivo y mostrarlo en el navegador.
A veces usted verá que ciertas imágenes aparecen en la página a la vez mientras que otros aparecen más tarde. Eso es porque
la obtención de las imágenes y el procesamiento del archivo HTML se realizan en paralelo. Algunas de las imágenes
llegarán antes de que el render de la pagina este listo, algunos llegarán solamente más adelante. Sin embargo, otros  quizá nunca llegan, en cuyo caso el
navegador puede mostrar una imagen de una "imagen rota".

Además de las imágenes, una página HTML generalmente también se refiere a archivos externos de CSS y JavaScript.
CSS ([ Cascading Style Sheets](http://en.wikipedia.org/wiki/Cascading_Style_Sheets)) proporciona el "look" de la
página. (por ejemplo, colores, tamaños, ubicación relativa de los objetos etc..) mientras [ JavaScript](http://en.wikipedia.org/wiki/Javascript)
puede proporcionar interactividad adicional dentro del navegador.

Así es como funciona la mayoría de los sitios web. Cada vez que hacemos clic en un vínculo o un botón, lo que genera una petición enviada al servidor web,
que devuelve una página nueva, un nuevo archivo HTML que se renderiza otra vez por el navegador.

## Ajax

La manera más moderna que podemos ver en un montón de aplicaciones web es que se carga solo una página HTML y por cada clic la
Página cambia de alguna manera. En el fondo, la página se comunica al servidor. Esta envía y recibe datos. Uno de las más conocidas
web-based aplicaciones como esta es Gmail.

La tecnología que emplea para comunicarse con el servidor en el fondo se llama Ajax.
Significa [ Asynchronous JavaScript and XML](http://en.wikipedia.org/wiki/Ajax_(programming)),
Aunque en las aplicaciones más modernas se transfieren los datos usando JSON en lugar de XML.

Las aplicaciones basadas en Ajax son básicamente [ cliente-servidor](http://en.wikipedia.org/wiki/Client_server)
aplicaciones y como tal, tiene dos importantes piezas móviles.
El código que se ejecuta en el navegador que se conoce como "el lado del cliente" está escrito en JavaScript.
El código que se ejecuta en el servidor que se conoce como el "lado del servidor" puede ser escrito en cualquier lenguaje. Incluyendo Perl.
La parte del lado del servidor es muy similar en los dos tipos de sitios, la diferencia es que en el primer caso se
Devuelve una página HTML, mientras que en el segundo caso devuelve los datos serializados. Generalmente como XML o JSON.

## Sitios mixtos

Hay muchos sitios web que son una mezcla de los dos métodos. Por ejemplo, un blog de software probablemente
mostrará los artículos como páginas HTML independientes con sus URLs individuales,
Pero tendrá una interfaz administrativa basado en Ajax donde el propietario puede editar y publicar artículos.


