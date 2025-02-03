---
title: "Draw hexagons, octagons and other regular polygons using SVG"
timestamp: 2015-02-01T07:30:01
tags:
  - files
published: false
books:
  - beginner
author: szabgab
archive: true
---


A [regular polygon](http://en.wikipedia.org/wiki/Regular_polygon) has N nodes,
and N edges of the same length and it has all kinds of other things you can read in that Wikipedia
article. We are going to create a function that can draw such a polygon using the
[Perl SVG](https://metacpan.org/pod/SVG) module.


Let's see the results:

<h3>[Hexagon](http://en.wikipedia.org/wiki/Hexagon)</h3>

<img src="/img/hexagon.svg" alt="Hexagon SVG" />

<h3>[Octagon](http://en.wikipedia.org/wiki/Octagon)</h3>

<img src="/img/octagon.svg" alt="Octagon SVG" />

<h3>[Dodecagon](http://en.wikipedia.org/wiki/Dodecagon)</h3>

<img src="/img/dodecagon.svg" alt="Dodecagon SVG" />

## The Code

{% include file="examples/svg_regular_polygon.pl" %}

Between every two nodes of the N-sided regular polygon we have the exact same
angle. Specifically `360/N` in degrees or `2 * PI / N` in radian.

We need to calculate these points and then draw a `polygon` with them.

The `sin` and `cos` functions that come with perl accept radian
values and the <a href="">Math::Trig</a>  module provides that via 



#pi2 * 30 / 360;
        # apparently pi2 is the double of pi, the same as 2*pi)


