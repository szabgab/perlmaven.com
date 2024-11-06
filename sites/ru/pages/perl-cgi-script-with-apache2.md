---
title: "Perl/CGI script with Apache2"
timestamp: 2014-04-07T11:01:01
tags:
  - CGI
  - Apache2
published: true
original: perl-cgi-script-with-apache2
books:
  - beginner
author: szabgab
translator: name2rnd
---


Хотя лучше использовать [PSGI](https://perlmaven.com/perl-cgi-mod-perl-psgi) сервер, чем CGI, все же очень полезно знать, как же писать cgi-скрипты. Особенно, если вам нужно поддерживать какой-нибудь из них.

Эта статья поможет настроить веб-сервер Apache для запуска с CGI-скриптов.


## Начнем с запуска Linux и установки Apache2

Мы сконфигурируем [Digital Ocean droplet](https://perlmaven.com/digitalocean), используя Ubuntu 13.10 64bit.

После создания Droplet, ssh и установки всех обновлений перезапустим машину.
(droplet, который я использую, имеет IP 107.170.93.222 )

```
ssh root@107.170.93.222
# aptitude update
# aptitude safe-upgrade
```

Установим Apache2 версии MPM preforking.

```
ssh root@107.170.93.222
# aptitude install apache2-mpm-prefork
```

Можете проверить, запустился ли Apache, командой `ps axuw`: 

```
# ps axuw | grep apache
```

Вывод на моей машине выглядит вот так:

```
root      1961  0.0  0.5  71284  2608 ?        Ss   14:16   0:00 /usr/sbin/apache2 -k start
www-data  1964  0.0  0.4 360448  2220 ?        Sl   14:16   0:00 /usr/sbin/apache2 -k start
www-data  1965  0.0  0.4 360448  2220 ?        Sl   14:16   0:00 /usr/sbin/apache2 -k start
root      2091  0.0  0.1   9452   908 pts/0    S+   14:16   0:00 grep --color=auto apache
```

Теперь вы можете смотреть свои локальные веб-сайты, просто указывая в браузере IP рабочей машины. В моем случае это так: http://107.170.93.222/
Запомните, некоторые браузеры не будут запрашивать страницу, если вы не напишете http:// перед IP адресом.

Если все работает нормально, вы увидите в браузере что-то в этом роде:

<img src="https://perlmaven.com/img/apache2_default_page_on_ubuntu_1310.png" alt="Apache2 default page on Ubuntu 13.10">

Это содержимое файла /var/www/index.html на сервере.

Вы можете его отредактировать и перезагрузить страницу в браузере.

## Создание первого CGI-скрипта на Perl

Создадим директорию /var/cgi-bin

(Заметьте, мы специально не создаем ее внутри директории /var/www. 
Таким образом, даже если сервер сконфигурирован неверно, 
то браузер не будет отображать исходный код скриптов. Это отличная идея.)

```
mkdir /var/cgi-bin
```

Создадим файл с названием `/var/cgi-bin/echo.pl` и следующим содержимым:

```perl
#!/usr/bin/perl
use strict;
use warnings;

print qq(Content-type: text/plain\n\n);

print "hi\n";
```

Сделаем файл исполнимым:

```
chomd +x /var/cgi-bin/echo.pl
```

и запустим в командной строке:

```
# /var/cgi-bin/echo.pl
```

Должно получиться:

```
Content-type: text/plain

hi
```

Это ваш первый CGI-скрипт на Perl.

Теперь нам нужно правильно сконфигурировать Apache.

## Конфигурируем Apache для запуска CGI-файлов

Откроем файл конфигурации Apache `/etc/apache2/sites-enabled/000-default.conf`

Там есть такой блок (с кучей комментариев):

```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Добавьте следующие строки после строки DocumentRoot:

```
        ScriptAlias /cgi-bin/ /var/cgi-bin/
        <Directory "/var/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Require all granted
        </Directory>
```

Получится вот так:

```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www

        ScriptAlias /cgi-bin/ /var/cgi-bin/
        <Directory "/var/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Require all granted
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

По-умолчанию Apache не включает CGI модуль. 
Это можно определить, потому что в директории mods-enabled нет ни одного CGI-файла, которые есть в директории mods-available.

```
# ls -l /etc/apache2/mods-enabled/ | grep cgi
# ls -l /etc/apache2/mods-available/ | grep cgi
-rw-r--r-- 1 root root   115 Jul 20  2013 cgid.conf
-rw-r--r-- 1 root root    60 Jul 20  2013 cgid.load
-rw-r--r-- 1 root root    58 Jul 20  2013 cgi.load
-rw-r--r-- 1 root root    89 Jul 20  2013 proxy_fcgi.load
-rw-r--r-- 1 root root    89 Jul 20  2013 proxy_scgi.load
```

Создадим символную ссылку из директории mods-enabled в mods-available для двух cgid.* файлов. 
И затем проверим снова, что ссылки нормально создались, запустив `ls -l`.

```
# ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/
# ln -s /etc/apache2/mods-available/cgid.conf /etc/apache2/mods-enabled/

# ls -l /etc/apache2/mods-enabled/ | grep cgi
lrwxrwxrwx 1 root root 37 Mar 19 14:39 cgid.conf -> /etc/apache2/mods-available/cgid.conf
lrwxrwxrwx 1 root root 37 Mar 19 14:39 cgid.load -> /etc/apache2/mods-available/cgid.load
```

Теперь мы может перезагрузить Apache командой:

```
# service apache2 reload
```

Команда reload говорит Apache перечитать свои файлы конфигурации.

Теперь можно написать в браузере http://107.170.93.222/cgi-bin/echo.pl
(конечно, заменив IP адрес на ваш) и вы увидете слово "hi".

Мои поздравления, ваш первый CGI-скрипт работает!

## Поиск и устранение проблем

Если при заходе по адресу http://107.170.93.222/cgi-bin/echo.pl вы видите содержимое файла, 
а не слово "hi", тогда проверьте, что ваша директория cgi-bin не находится внутри /var/www, 
и так же возможно, что вы забыли создать символьные ссылки на файлы cgid.*.
Переместите директорию cgi-bin вне /var/www, обновите конфигурационные файлы, 
установите символьные ссылки, перезагрузите сервер.

<h3>Ошибка 500 Internal Server Error</h3>

Если вы получили сообщение `500 Internal Server Error`, посмотрите лог сервера `/var/log/apache2/error.log`

```
[Wed Mar 19 15:19:15.740781 2014] [cgid:error] [pid 3493:tid 139896478103424] (8)Exec format error: AH01241: exec of '/var/cgi-bin/echo.pl' failed
[Wed Mar 19 15:19:15.741057 2014] [cgid:error] [pid 3413:tid 139896186423040] [client 192.120.120.120:62309] End of script output before headers: echo.pl
```

Это может произойти, если скрипт не начинается с sh-bang, 
либо не указывает на корректное размещение установленного Perl.
Первая строка должна быть такая:

```
#!/usr/bin/perl
```

```
[Wed Mar 19 15:24:33.504988 2014] [cgid:error] [pid 3781:tid 139896478103424] (2)No such file or directory: AH01241: exec of '/var/cgi-bin/echo.pl' failed
[Wed Mar 19 15:24:33.505429 2014] [cgid:error] [pid 3412:tid 139896261957376] [client 192.120.120.120:58087] End of script output before headers: echo.pl
```

Это может означать, что файл в формате DOS. Такое может случиться, если вы закачали файл по ftp с компьютера под управлением Windows в бинарном режиме.
(Вообще не стоит использовать ftp.)
Эту проблему можно решить запустив: 

```
dos2unix /var/cgi-bin/echo.pl
```

```
[Wed Mar 19 15:40:31.179155 2014] [cgid:error] [pid 4796:tid 140208841959296] (13)Permission denied: AH01241: exec of '/var/cgi-bin/echo.pl' failed
[Wed Mar 19 15:40:31.179515 2014] [cgid:error] [pid 4702:tid 140208670504704] [client 192.120.120.120:60337] End of script output before headers: echo.pl
```

Верхняя строка из error.log указывает, что у файла не установлен исполнимый бит. Чтобы исправить, сделайте так:

```
chmod +x /var/cgi-bin/echo.pl
```

```
Wed Mar 19 16:02:20.239624 2014] [cgid:error] [pid 4703:tid 140208594970368] [client 192.120.120.120:62841] malformed header from script 'echo.pl': Bad header: hi
```

Такое сообщение можно получить, если вы что-то выводите до вывода заголовка Content-type.
Например так:

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "hi\n";
print qq(Content-type: text/plain\n\n);
```

```
[Wed Mar 19 16:08:00.342999 2014] [cgid:error] [pid 4703:tid 140208536221440] [client 192.120.120.120:59319] End of script output before headers: echo.pl
```

Это сообщение может означать, что скрипт завершил работу (умер) до того, как напечатал `Content-type`
Error.log, вероятно, содержит исключение в строках выше.

Также вы можете включить буферизацию STDOUT, установив `$|` в значение [Истина](https://perlmaven.com/boolean-values-in-perl).

```
$|  = 1;
```

Я не уверен, но думаю, что <b>Premature end of script headers</b> это то же самое, что и <b>End of script output before headers</b>.

<h3>Ошибка 503 Service Unavailable</h3>

После создания символьной ссылки на файлы cgid.* и перезапуска Apache, я получил ошибку 
<b>503 Service Unavailable</b> в браузере и следующую запись в error.log:

```
[Wed Mar 19 15:30:22.515457 2014] [cgid:error] [pid 3927:tid 140206699169536] (22)Invalid argument: [client 192.120.120.120:58349] AH01257: unable to connect to cgi daemon after multiple tries: /var/cgi-bin/echo.pl
```

Не уверен точно, почему это произошло, но после перезагрузки Apache, все стало работать нормально:

```
# service apache2 restart
```

В большинстве случаев команды reload достаточно, но, возможно, не при включении/отключении модуля.

<h3>Ошибка 404 Not Found</h3>

Если вы получили <b>404 Not Found</b> в браузере и

```
[Wed Mar 19 15:35:13.487333 2014] [cgid:error] [pid 4194:tid 139911599433472] [client 192.120.120.120:58339] AH01264: script not found or unable to stat: /usr/lib/cgi-bin/echo.pl
```

в логе ошибок, тогда возможно директива `ScriptAlias` отсутствует, либо указывает не на тут директорию.

<h3>Ошибка 403 Forbidden</h3>

Если вы получили <b>403 Forbidden</b>, возможно директива `Directory` сконфигурирована неверно, либо указывает не на ту директорию.

## Резюме

Вот и все. Надеюсь, у вас теперь есть первый работающий CGI-скрипт на Perl.

Конечно, использование PSGI это более [современно](https://perlmaven.com/modern-web-with-perl) и более гибко, чем CGI.
Возможно, вам стоит посмотреть [Perl Dancer](https://perlmaven.com/dancer) 
или [Mojolicious](https://perlmaven.com/mojolicious) фреймворки, чтобы получить больше опыта.
