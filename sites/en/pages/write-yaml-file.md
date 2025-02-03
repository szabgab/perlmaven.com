---
title: "Write YAML file"
timestamp: 2019-10-16T15:30:01
tags:
  - YAML
  - DumpFile
published: true
author: szabgab
archive: true
---


[YAML](/yaml) is primarily used as a configuration file that people write and the program reads, but it can
be used for [data serialization](/data-serialization-in-perl) as well. In addition, especially when writing
tests, there are other cases as well when we would like to save a data structure as a YAML file.


{% include file="examples/save_yaml.pl" %}

The result will look like this:

{% include file="examples/data/data.yml" %}

