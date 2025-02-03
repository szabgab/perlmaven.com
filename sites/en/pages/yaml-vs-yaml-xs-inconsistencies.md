---
title: "YAML vs YAML::XS inconsistencies (YAML::Syck and YAML::Tiny too)"
timestamp: 2015-10-19T11:30:01
tags:
  - YAML
  - YAML::XS
  - YAML::Syck
  - YAML::Tiny
published: true
author: szabgab
archive: true
---


[YAML](/yaml) is a great format for configuration files and for data serialization. There are several Perl modules
implementing the function that convert a YAML string into a Perl data structure (deserialize) and that can convert a Perl
data structure into a YAML string (serialize).


[YAML::Tiny](https://metacpan.org/pod/YAML::Tiny) clearly states that it only implements a subset of features,
but as far as I understand YAML and YAML::XS are supposed to be drop-in replacements of each other.
[YAML::Any](https://metacpan.org/pod/YAML::Any) is a wrapper
around several YAML processors, though at one point YAML itself will be promoted to do that job.


Yet, when I tried to [switch from  YAML to YAML::XS](/profiling-and-speed-improvement) I've encountered two cases of incompatibility.
Probably in both cases the YAML file wasn't according to the specs, but in both cases YAML was forgiving and parsed
the files as I expected them and in both cases YAML::XS threw exception. I've created minimal examples for both cases
and I have tried to parse them with the following:

* [YAML version 1.15](https://metacpan.org/pod/YAML)
* [YAML::XS version 0.59](https://metacpan.org/pod/YAML::XS)
* [YAML::Tiny version 1.69](https://metacpan.org/pod/YAML::Tiny)
* [YAML::Syck version 1.29](https://metacpan.org/pod/YAML::Syck)

## Space required after :

The YAML file:

{% include file="examples/files/space_required.yml" %}

`perl yaml.pl files/space_required.yml`  parsed and created

```
$VAR1 = {
          'x' => {
                 'a' => 'a',
                 'b' => 'b'
               }
        };
```

`perl yaml_xs.pl files/space_required.yml`

```
YAML::XS::Load Error: The problem:

    could not find expected ':'

was found at document: 1, line: 4, column: 1
while scanning a simple key at line: 3, column: 3
```

`perl yaml_tiny.pl files/space_required.yml` threw exception:

```
YAML::Tiny failed to classify line '  'b':'b'' at yaml_tiny.pl line 11.
```

`perl yaml_syck.pl files/space_required.yml` threw exception:

```
Syck parser (line 4, column -1): syntax error 
```

The solution here is to put a space after the `:` in the line of 'b' as in the following:

{% include file="examples/files/space_required_solved.yml" %}

I am not sure if this is something that needs to be fixed in the YAML module, or just documented,
but I've opened a [ticket](https://github.com/ingydotnet/yaml-pm/issues/152).

## Value with : needs to be quoted

The YAML file:

{% include file="examples/files/quote_colon.yml" %}

`perl yaml.pl files/quote_colon.yml` properly parses the YAML file and generates this data structure:

```
$VAR1 = {
          'a' => [
                 {
                   'b' => 'c:'
                 }
               ]
        };
```

`perl yaml_xs.pl files/quote_colon.yml` throws exception:

```
YAML::XS::Load Error: The problem:

    mapping values are not allowed in this context

was found at document: 1, line: 2, column: 9
```

`perl yaml_tiny.pl files/quote_colon.yml` throws exception:

```
YAML::Tiny found illegal characters in plain scalar: 'c:' at yaml_tiny.pl line 11.
```

`perl yaml_syck.pl files/quote_colon.yml` throws exception:

```
Syck parser (line 2, column 9): syntax error
```

The solution here is to put the value with the `:` in it between single-quote marks:

{% include file="examples/files/quote_colon_solved.yml" %}

Here too I've opened a [ticket](https://github.com/ingydotnet/yaml-pm/issues/153) for consideration.

## The scripts I used

{% include file="examples/yaml.pl" %}

{% include file="examples/yaml_xs.pl" %}

{% include file="examples/yaml_tiny.pl" %}

{% include file="examples/yaml_syck.pl" %}


