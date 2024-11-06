---
title: "Como hacer una aplicacion web dinamica usando PSGI"
timestamp: 2014-11-02T21:45:56
tags:
  - PSGI
  - Plack
  - plackup
published: true
original: how-to-build-a-dynamic-web-application-using-psgi
author: szabgab
translator: danimera
---


Ahora que hemos construido nuestra [ primera aplicación web utilizando PSGI](https://perlmaven.com/getting-started-with-psgi)
podemos ir un paso más allá y construir algo que pueda responder a una consulta.


Con el fin de crear una aplicación web que puede aceptar la entrada de los usuarios que necesitamos
para entender cómo [ Plack/PSGI](http://plackperl.org/) define que
parte de la interacción.

En el mundo CGI teníamos una mezcla de variables de entorno en acción.
En PSGI todo lo interesante pasarán a través de un único parámetro
a la subrutina anónima que implementa nuestra aplicación. Ese parámetro
es una referencia a un HASH. Vamos a ver lo que contiene:


```perl
#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);
$Data::Dumper::Sortkeys = 1;

my $app = sub {
  my $env = shift;
  return [
    '200',
    [ 'Content-Type' => 'text/plain' ],
    [ Dumper $env ],
  ];
};
```


Guardar en un archivo llamado `env.psgi` y ejecutarlo con `plackup env.psgi`.
Cuando se lanza, visite  http://localhost:5000/ con se navegador favorito.
Se verá algo como esto:

```
$VAR1 = {
    'HTTP_ACCEPT' => 'text/html,application/xhtml+xml,...',
    'HTTP_ACCEPT_CHARSET' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
    'HTTP_ACCEPT_ENCODING' => 'gzip, deflate',
    'HTTP_ACCEPT_LANGUAGE' => 'en-gb,en;q=0.5',
    'HTTP_CACHE_CONTROL' => 'max-age=0',
    'HTTP_CONNECTION' => 'keep-alive',
    'HTTP_COOKIE' => '__utma=1118.128.1348.1379.107.6; __utmz=111.1348.1.1....',
    'HTTP_HOST' => 'localhost:5000',
    'HTTP_USER_AGENT' => 'Mozilla/5.0 (Windows NT 6.1; rv:9.0.1) ...',
    'PATH_INFO' => '/',
    'QUERY_STRING' => '',
    'REMOTE_ADDR' => '127.0.0.1',
    'REQUEST_METHOD' => 'GET',
    'REQUEST_URI' => '/',
    'SCRIPT_NAME' => '',
    'SERVER_NAME' => 0,
    'SERVER_PORT' => 5000,
    'SERVER_PROTOCOL' => 'HTTP/1.1',
    'psgi.errors' => *::STDERR,
    'psgi.input' => \*{'HTTP::Server::PSGI::$input'},
    'psgi.multiprocess' => '',
    'psgi.multithread' => '',
    'psgi.nonblocking' => '',
    'psgi.run_once' => '',
    'psgi.streaming' => 1,
    'psgi.url_scheme' => 'http',
    'psgi.version' => [
                       1,
                       1
                      ],
    'psgix.input.buffered' => 1,
    'psgix.io' => bless( \*Symbol::GEN1, 'IO::Socket::INET' )
};
```

Vamos a ver lo que tenemos aquí.

En el script utilizamos la función `Dumper` del
módulo Data::Dumper estándar.
De forma predeterminada mostraría los datos sin ningún orden.
Ajuste al variable del `$Data::Dumper::Sortkeys`  a 1
cambia el comportamiento y las llaves de los hash son organizadas
Eso lo hace mucho más fácil de leer.

También establecemos el <b>Content-Type</b> a ser <b>text/plain</b>. 
HTML normalmente ignora espacios así que con esto le estamos diciendo al navegador 
interpretar nuestros datos como texto sin formato.
De esa forma se mostrará los datos literales.
Mantener los espacios y los saltos de línea.

Los datos se pueden dividirse en dos partes.
La primera parte - un conjunto de teclas Mayúsculas - son el conjunto de variables de entorno familiar.
La segunda parte es un conjunto de llaves específicas PSGI.
No entraré en alguno de estos, ests se describen en
[PSGI specification](http://plackperl.org/).

Vamos a cambiar nuestra petición a la siguiente:
## Solicitud GET con parámetros

Si usted está familiarizado con HTTP entonces deberías saber cómo aparece una petición GET
con algunos parámetros en estos datos crudos.

Vamos a cambiar nuestra petición a la siguiente:

`http://localhost:5000/page?name=value`

En los datos podemos ver los siguientes cambios:
 
```
  'PATH_INFO' => '/page',
  'QUERY_STRING' => 'name=value',
  'REQUEST_URI' => '/page?name=value',
```

## Servidor simple Eco

Con el fin de dar un pequeño paso más, vamos a construir un servidor simple eco.
Esta es una página con un campo de entrada única y un botón.
Cuando usted presiona el botón se recarga a sí mismo y mostrar el texto
que ha escrito en el campo.

Cuando se procesa la entrada  podríamos analizar el
QUERY_STRING o el REQUEST_URI
pero Plack nos brinda una mejor manera de hacer esto.
Plack proporciona un módulo llamado
[ Plack::Request](https://metacpan.org/pod/Plack::Request)
que proporciona un método llamado `param`
que devolverá el valor de un parámetro enviado por el usuario.

Con el fin de simplificar el código he creado una función llamada `get_html`
que devuelve un trozo de HTML estático. La forma que se mostrará.
El principal código comprueba si el usuario ha pasado ningún parámetro.
En caso afirmativo, el valor se une al código HTML que ya tenemos.
Esto es lo que tenemos en la variable `$html` que enviamos hacia el navegador.

```perl
#!/usr/bin/perl
use strict;
use warnings;

use Plack::Request;

my $app = sub {
    my $env = shift;
 
    my $html = get_html();

    my $request = Plack::Request->new($env);

    if ($request->param('field')) {
        $html .= 'You said: ' . $request->param('field');
    }

    return [
        '200',
        [ 'Content-Type' => 'text/html' ],
        [ $html ],
    ];
}; 

sub get_html {
    return q{
        <form>
  
        <input name="field">
        <input type="submit" value="Echo">
        </form>
        <hr>
    }
}
```

Obviamente para algo más grande moveríamos el HTML a un
archivo de plantilla y probablemente usaríamos
un framework Web de nivel superior como [dancer](https://perlmaven.com/dancer) o [ Mojolicious](https://perlmaven.com/mojolicious),
pero nos interesa ahora el mecanismo de bajo nivel.


## Una calculadora?

Si desea tomar este enfoque un poco más podrías tomar el script anterior y mejorarlo
para obtener dos números y sumarlos.

Un ejemplo más complejo permitiría al usuario que proporcione dos números y uno de los principales
operadores (+, -, *, /) y devuelve el resultado. 

## Qué más?

¿Qué más quieres saber sobre Plack y [ PSGI](https://perlmaven.com/psgi)?

