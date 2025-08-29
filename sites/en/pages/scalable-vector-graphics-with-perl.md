---
title: "SVG - Scalable Vector Graphics with Perl"
timestamp: 2015-02-13T10:30:01
tags:
  - SVG
published: true
author: szabgab
---


Scalable Vector Graphics (aka SVG) allows you to create images that can scale up and
down without loss of quality.


## What is Scalable Vector Graphics?

When seeing an image, we basically see lots of colored pixels.
The original picture can be stored either as those pixels, that's called a raster image,
or in can be saved as a series of commands to draw the picture.

[Scalable Vector Graphics (SVG)](http://en.wikipedia.org/wiki/Scalable_Vector_Graphics)
is basically an XML file containing instructions to draw an image.

Your browser can process that XML file and render it as a picture.
(Well, assuming you have a modern web browser.)

There is a pure-perl module called [SVG](https://metacpan.org/pod/SVG) created by Ronan Oger,
that allows you to create that XML file by calling Perl methods.

Let's see a few simple examples.

## Draw circle

{% include file="examples/svg_draw_circle.pl" %}

First we create the background of the image with a size of 40 x 40 pixels.
We only need this so we can add elements to it in a size relative to this size.
By default the background is white.

```perl
my $svg = SVG->new(
    width  => 40,
    height => 40,
);
```

Then we add a circle, with a center at 20x20 and a radius of 18 pixels.
By default the circle will be black.

Finally we call the `xmlify` method that returns the XML file.

If we run this script we'll see a small XML on our screen:

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN"
     "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
<svg height="40" width="40" xmlns="http://www.w3.org/2000/svg" 
     xmlns:svg="http://www.w3.org/2000/svg"
     xmlns:xlink="http://www.w3.org/1999/xlink">
<circle cx="20" cy="20" r="18" />
<!-- 
    Generated using the Perl SVG Module V2.50
    by Ronan Oger
    Info: http://www.roitsystems.com/
-->
</svg>
```

We can save this by redirecting the output of the script to a file called

```
  perl svg_draw_circle.pl > black_circle.svg
```

Then we can open that file using our browser or by embedding in an html file using
the img tag:

```
<img src="/img/black_circle.svg" alt="black circle"/>
```

and make sure that your web server returns the file with Content-type: **image/svg+xml**.
The result look like this:

<img src="/img/black_circle.svg" alt="black circle"/>

## Adding some style to the circle

```perl
# add a circle with style
#  fill is the color used to fill the circle
#  stroke is the color of the line used to draw the circle
#     these both can be either a name of a color or an RGB triplet
#  stroke-width is a non-negative integer, the width of the drawing line
#  stroke-opacity and fill-opacity are floating point numbers between 0 and 1.
#     1 means the line is totally opaque
#     0 means the line is totally transparent
$svg->circle(
    cx => 20,
    cy => 20,
    r  => 15,
    style => {
        'fill'           => 'rgb(255, 0, 0)',
        'stroke'         => 'blue',
        'stroke-width'   =>  5,
        'stroke-opacity' =>  1,
        'fill-opacity'   =>  1,
    },
);
```

Add the following entry to the HTML

```
<img src="/img/red_blue_circle.svg" alt="red and blue circle"/>
```

It will look like this:

<img src="/img/red_blue_circle.svg" alt="red and blue circle"/>

## Enlarge the image

While that SVG file has a default size of 20x20 we can tell the browser to display
the same image at a larger size by setting the width and the height

```
<img src="/img/red_blue_circle.svg" width="200" height="200" 
     alt="big red and blue circle"/>
```

<img src="/img/red_blue_circle.svg" width="200" height="200" alt="big red and blue circle"/>

This would work with raster images as well, but then the quality of the image would suffer. With Vector images,
we can enlarge the image as much as we want, it will be the same quality.

## Opacity

Finally, I've changed the 'fill-opacity' of the circle from 1 to 0.5. This made the red lighter:

<img src="/img/transparent_red_blue_circle.svg" width="200" height="200" alt="big red and blue circle"/>

## Circle, Triangle and Square

{% include file="examples/svg_draw_circle_triangle_square.pl" %}

The resulting image looks like this:

<img src="/img/circle_triangle_square.svg" width="200", height="200" alt="Circle, Triangle and Square" />

Set the 'fill-opacity' of the circle and that of the polygon to 0.5.

<img src="/img/transparent_circle_triangle_square.svg" width="200", height="200" alt="Transparent Circle, Triangle and Square" />

## JavaScript

If you are interested, I've also written an article showing [how to create SVG images using JavaScript](https://code-maven.com/svg-with-javascript)


## For the Norwegian readers out there

Let me point you to the Bachelor's thesis of Robin Smidsrød on the [state of SVG support](http://files.smidsrod.no/BAC309IN/) in browsers (as of 2010).

Chapter 4 gives a good overview of the SVG primitives available.

He also created a charting library (for Java) as part of that thesis, which can be found [here](https://github.com/robinsmidsrod/SVGChartLibrary).

He hasn't found a library that does the same thing in Perl yet, and I think the the API is interesting, in how it allows an arbitrary amount of axes for quite complicated charts.

An app that uses the library, [SVGChartApp](https://github.com/petterthunaes/SVGChartApp) (made by another student he worked with), takes CSV input files and generates charts in SVG.

