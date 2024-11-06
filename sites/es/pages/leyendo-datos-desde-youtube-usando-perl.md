---
title: "Leyendo datos desde YouTube usando Perl"
timestamp: 2014-07-09T20:45:56
tags:
  - YouTube
  - WebService::GData
  - WebService::GData::YouTube
  - Email::Send::SMTP::Gmail
  - email
types:
  - screencast
published: true
original: fetching-data-from-youtube-using-perl
author: szabgab
translator: lenieto3
---


Como estoy tratando de seguir como van [mis screencasts](http://www.youtube.com/gabor529) en YouTube mantengo visitando el sitio web para ver el número de suscriptores y el número de visitas de los videos. Se está volviendo un poco aburrido, así que pensé que debía automatizarlo.


<iframe width="640" height="390" src="http://www.youtube.com/embed/a03jf68iz-M" 
frameborder="0" allowfullscreen></iframe>

YouTube ofrece una [API](http://code.google.com/apis/youtube/overview.html) para muchas cosas. Yo quería adquirir las estadísticas de [mi cuenta](http://www.youtube.com/gabor529).

Empecé instalando el paquete [Padre en Strawberry Perl para Windows](http://padre.perlide.org/) pero igual funcionará en cualquier otra distribución de Perl, y en cualquier otro sistema operativo.

Luego fuí a [Meta CPAN](http://www.metacpan.org/) para buscar algo relacionado con <b>YouTube</b> y me decidí por [WebService::GData](http://metacpan.org/pod/WebService::GData). Fuí a la consola CPAN en el submenú Strawberry -> Tools y escribí

```
cpan> install WebService::GData
```

Después de una breve lectura de la documentación, y algo de copiar-pegar logré este script:

```perl
#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

use WebService::GData::YouTube;
my $yt = WebService::GData::YouTube->new();

my $p = $yt->get_user_profile('gabor529');
say $p->about_me;
my $s = $p->statistics;
say $s->view_count;
say $s->subscriber_count;
#say $s->video_watch_count;
say $s->total_upload_views;
```

Esto traerá mi perfil de usuario - incluso sin iniciar sesión en YouTube - e imprimirá las estadísticas. Tenía 105 suscriptores, cuando preparé el screencast en junio de 2001. Hay 551 en julio de 2014.

Luego quise enviar el dato de los resultados via Gmail. Otra búsqueda corta en Meta CPAN por <b>Gmail</b> y encontré [Email::Send::SMTP::Gmail](http://metacpan.org/pod/Email::Send::SMTP::Gmail). Algo más de copiar-pegar y acá está el script que me enviará un e-mail a mí mismo usando mi cuenta de gmail. Me imagino que podría utilizar el mismo código para enviarlo a cualquier otro también.

```perl
use Email::Send::SMTP::Gmail;

my $mail=Email::Send::SMTP::Gmail->new( -smtp=>'gmail.com',
                                        -login=>'gabor529@gmail.com',
                                        -pass=>'google and me');

my $text = '';
$text .= "contador de visitas " . $s->view_count . "\n";
$text .= "suscriptores " . $s->subscriber_count . "\n";
$text .= "total de visitas"   . $s->total_upload_views . "\n";

$mail->send(-to=>'gabor529@gmail.com',
          -subject=>'youtube update',
          -verbose=>'1',
          -body=> $text,
#         -attachments=>'full_path_to_file'
);

$mail->bye;
```

Eso fue todo. ¡Me tomó casi 15 minutos escribir esto! (y 3 horas más prepara el screencast).

ps. Ese realmente no es mi correo electrónico. Sólo los estaba usando para este demo.
