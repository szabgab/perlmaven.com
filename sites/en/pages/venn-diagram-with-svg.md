---
title: "Venn diagram with SVG"
timestamp: 2015-04-18T12:30:01
tags:
  - SVG
  - Venn
published: true
author: szabgab
archive: true
---


Sample code to produce a Venn diagram of 3 circles using [SVG](/search/SVG).


<img src="/img/venn_diagram.svg" alt="Venn diagram" />

{% include file="examples/svg_venn_diagram.psgi" %}

We create 3 circles with the same radius `r => 50`, but with different center position (`cx, cy`).

It is also important to set the `fill-opacity` to something less than 1. Especially for the circles drawn
on top of the other circles. Otherwise we would not see the common areas as common.

## Clickable Venn diagram in SVG

In the next example we make the circles clickable and link each circle to a different URL:

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
<svg height="200" width="200" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title >I am a title</title>
    <a xlink:href="https://perlmaven.com/">
        <circle cx="100" cy="100" id="red_circle" r="50" style="fill-opacity: 0.5; fill: #FF0000" />
    </a>
    <a xlink:href="https://code-maven.com/">
        <circle cx="150" cy="100" id="blue_circle" r="50" style="fill: #0000FF; fill-opacity: 0.5" />
    </a>
    <a xlink:href="http://perl6maven.com/">
        <circle cx="125" cy="150" id="green_circle" r="50" style="fill: #00FF00; fill-opacity: 0.5" />
    </a>
    <!--
    Generated using the Perl SVG Module V2.59
    by Ronan Oger
    Info: http://www.roitsystems.com/
 -->
</svg>

The source code looks like this:

{% include file="examples/svg_venn_diagram_clickable.psgi" %}

Here, instead of creating the circles from the `$svg` object itself, first
we create Anchor objects from SVG and then from those Anchor object we create the circles.
Each Anchor object will handle a single URL and a single circle.

```perl
    my $red_tag = $svg->anchor(
        -href => 'https://perlmaven.com/'
    );
    my $red = $red_tag->circle(
       ...
```

There is also a big difference from the previous cases. Especially in the way the result is displayed on this page.
Earlier we used the results of the SVG in an `img` element like this:

```
<img src="/img/some.svg" />
```

The same could would not work properly with anchors and links.
For those to work we had  to embed the generated XML code in the HTML file. So if you now "view source" of this page,
you'll see that the Clickable Venn diagram is a piece of XML code.

There is another issue, which might be even more problematic. The entire green circle now leads to the same URL,
both where it is alone and also where it is overlapping other circles. This is probably not what we want.

I think we cannot solve this problem with regular circle elements. So we'll have to see what can we do with more
advanced SVG elements.

