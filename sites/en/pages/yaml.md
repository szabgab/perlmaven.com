---
title: "YAML in Perl"
timestamp: 2017-08-27T12:00:02
tags:
  - YAML
  - YAML::XS
  - YAML::Syck
  - YAML::Tiny
  - YAML::Any
published: true
author: szabgab
archive: true
show_related: false
---


[YAML: YAML Ain't Markup Language](http://yaml.org/) is a text format that provides hierarchical data structures similar to
[JSON](/json), but it is especially human readable.

{% include file="examples/sample.yml" %}

It can be used for [data serialization](/data-serialization-in-perl), though probbaly it is most often used for hierarchical configuration files.

YAML format allows the user to have key-value pair and list data structures.

Plenty of languages have YAML reader and write libraries.


In Perl the following libraries exist:

* [YAML](https://metacpan.org/pod/YAML)
* [YAML::XS](https://metacpan.org/pod/YAML::XS)
* [YAML::Syck](https://metacpan.org/pod/YAML::Syck)
* [YAML::Tiny](https://metacpan.org/pod/YAML::Tiny)
* [YAML::Any](https://metacpan.org/pod/YAML::Any)

## Other articles about YAML

* [YAML vs YAML::XS inconsistencies (YAML::Syck and YAML::Tiny too)](/yaml-vs-yaml-xs-inconsistencies)
* [Reead YAML file](/read-yaml-file) (load YAMl)
* [Write YAML file](/write-yaml-file) (save YAML)
* [Counter example using YAML file to store the data](/cli-counter-with-yaml-backend)

## YAML in other languages
* [YAML in other languages](https://code-maven.com/yaml)
