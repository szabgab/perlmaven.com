---
title: "Visualize Perl class hierarchies as a graph using GraphViz2::Parse::ISA"
timestamp: 2020-10-14T07:30:01
tags:
  - GraphViz2::Parse::ISA
  - GraphViz2
published: true
author: szabgab
archive: true
show_related: true
---


[GraphViz2::Parse::ISA](https://metacpan.org/pod/GraphViz2::Parse::ISA) can visualize N Perl class hierarchies as a graph.

I used the code from the synopsys on the files that come with the distribution:


Installed the module:

```
cpanm GraphViz2::Parse::ISA
```

Then also downloaded the source separately and unzipped it.

```
wget https://cpan.metacpan.org/authors/id/E/ET/ETJ/GraphViz2-Parse-ISA-2.52.tar.gz
tar xzf GraphViz2-Parse-ISA-2.52.tar.gz
cd GraphViz2-Parse-ISA-2.52
```

Then created a file which was a copy of the code from the [synopsis in the documentation of GraphViz2::Parse::ISA](https://metacpan.org/pod/GraphViz2::Parse::ISA).

It did not work out of the box, but after I made some small changes (commented out 2 lines and added one on line 28) it generated a file called **parse.code.svg** based on the files in the **t/lib** directory of the zip file.

{% include file="examples/graphviz2_parse_isa_example.pl" %}

<img src="/img/graphviz2_parse_isa_example.svg" alt="" />


More examples on the [Graphviz Perl web site](https://graphviz-perl.github.io/)

