---
title: "Read YAML file"
timestamp: 2019-11-03T07:30:01
tags:
  - YAML
  - LoadFile
published: true
author: szabgab
archive: true
---


[YAML](/yaml) is a common file format to hold configuration information that is easily readable and writable
by humans.

But how do you read theem in you Perl script?


For example we have this YAML file:

{% include file="examples/data/data.yml" %}

{% include file="examples/read_yaml.pl" %}

The output of [Dumper](/beginner-perl-maven-dumping-hash) looks like this:

<pre>
$VAR1 = {
          'ids' => [
                     '12',
                     '23',
                     '78'
                   ],
          'name' => 'Foo Bar',
          'email' => 'foo@bar.com'
        };
</pre>

