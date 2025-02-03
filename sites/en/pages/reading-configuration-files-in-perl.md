---
title: "Reading configuration INI files in Perl"
timestamp: 2019-01-20T21:30:01
tags:
  - Config::Tiny
published: true
author: szabgab
archive: true
---


The [INI file format](https://en.wikipedia.org/wiki/INI_file) is a simple file format that allows 2-level configuration options. It was extensively used in MS DOS and MS Windows, and it can be used in lots of places as it is very simple.

{% include file="examples/config.ini" %}

This format consists of section names (in square brackets) and in each section key-value pairs separated by and `=` sign and padded by spaces.


There are several articles showing how to read them using plain Perl for example [processing config file](/beginner-perl-maven-process-config-file)
and the exercise [parse INI file](/beginner-perl-maven-exercise-parse-ini-file)
however there are several modules on CPAN that would do the work for you in a more generic way.

We'll use [Config::Tiny](https://metacpan.org/pod/Config::Tiny)

{% include file="examples/read_config.pl" %}

The line that reads and parses the configuration file is `Config::Tiny->read`.

It returns a reference to a 2-dimensional hash. The main hash has the sections as keys and the values are the hashes representing each individual section.

We can then access the specific values using the `$config->{section}{key}` construct.

If we use Data::Dumper we can see the whole data structure:

```
$VAR1 = bless( {
                 'digital_ocean' => {
                                      'api' => 'seaworld'
                                    },
                 'openweathermap' => {
                                       'api' => 'asdahkaky131'
                                     },
                 'aws' => {
                            'api_code' => 'qkhdkadyday',
                            'api_key' => 'myaws7980'
                          }
               }, 'Config::Tiny' );
```

## Write config file

[Config::Tiny](https://metacpan.org/pod/Config::Tiny) can also write config files
and it can also handle key-value pairs without any section. Check the documentation for details.

