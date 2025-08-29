---
title: ".env - the dot env application configuration file"
timestamp: 2021-04-09T16:30:01
tags:
  - Dotenv
  - ".env"
  - "%ENV"
  - "$ENV"
published: true
author: szabgab
archive: true
show_related: true
---


There are a number of frameworks and applications that check if there is a **.env** file in the root directory
of the project and if there is one, then load it to enhance the content of the Environment variables.

Perl gives access to the environment variables via the **%ENV** hash.


As examples [Docker](https://docs.docker.com/compose/env-file/) and [Laravel](https://laravel.com/docs/8.x/configuration) both make use of the file.
Even [IBM has it in AIX](https://www.ibm.com/docs/en/aix/7.2?topic=files-env-file).

Apparently Philippe Bruhat (BooK) already crated a module called [Dotenv](https://metacpan.org/pod/Dotenv) that handles this.

Here is a script that uses it and then prints out the content of th whole **%ENV** hash and then two specific values.

{% include file="examples/env/app.pl" %}

Here is the config file that consists of plain **key=value** pairs.

{% include file="examples/env/.env" %}

I use variable names starting with an X so thei will be printed last when I print the %ENV in ABC order. Otherwise there is nothing special about them.

Running
```
perl app.pl
```

will print out:

```
...
X_ANSWER                   42
X_TEXT                     left side = right side
_                          /usr/bin/perl
-------------------------
42
left side = right side
```


Rmember thatDoteenv will not overwrite existing keys, so if you already have an environment variable in your, well, environment,
then Dotenv will keeep that value. This means you can also change the value ad-hoc when running the application:

```
X_ANSWER=23 perl app.pl
```

```
...
X_ANSWER                   23
X_TEXT                     left side = right side
_                          /usr/bin/perl
-------------------------
23
left side = right side
```


