---
title: "GUI with Perl for desktop applications"
timestamp: 2019-04-27T10:30:01
tags:
  - Gtk2
  - Tk
  - Wx
  - wxWdigets
  - Prima
  - Win32::GUI
published: true
author: szabgab
archive: true
---


If you need to develop a desktop application Perl probably should not be your first choice, but if you already have a
Perl based application that has a CLI (Command Line Interface) and you'd like to add a GUI to it, it can be done.

It can even be done quite well.

As you know, with the help of a lot of bright people, I wrote one, an <a href="http://padre.perlide.org/">IDE in Perl
for Perl</a>. Unfortunately that project has not been maintained for quite some time, but you can still run it
or at least you can still see the screenshots.

Anyway, what are your choices if you'd like to add a GUI (Graphical User Interface) to your application?


## Modern Web

First of all before you start writing a GUI, are you sure that's what you need and not a
[modern web application written in Perl](/modern-web-with-perl)?


IF you are really sure you need and want a desktop application you can use:


## Wx - wxWidgets

[Wx](https://metacpan.org/pod/Wx) also knonw as wxPerl or the Perl binding to
[wxWidgets](https://www.wxwidgets.org/) is the most native-looking cross-platform toolkit.
It can be used on MS Windows, Linux, and Mac OSX.

In the Padre project we used this.


## Gtk2

[Gtk2](https://metacpan.org/pod/Gtk2) is really nice. I used it some time for the Padre
project before switching to wxWidgets. It felt easier to use than wxWidgets, but we felt the native
look on wxWdigets on MS Windows was important.

This is the Perl binding to the [Gnome Toolkit](https://www.gnome.org/).

## Tk

[Perl Tk](https://metacpan.org/release/Tk) is the binding of the Toolkit from
[Tcl/Tk](https://www.tcl.tk/).

## Tkx

[Tkx](https://metacpan.org/pod/Tkx) provides another Tk based interface.

It is the oldest and probably the least beautiful, but a very powerful and capable toolkit.

## Prima

I only had a very short encounter with [Prima](https://metacpan.org/release/Prima), but
I liked it. As far as I know it is a Perl-only framework. Unlike the others in the list that are all
binding to some C-library that can and are used from other Programming languages as well.

## Win32::GUI

There is also [Win32::GUI](https://metacpan.org/release/Win32-GUI). I don't remember ever using it.
Sounds like a Windows specific library that is probabably better if you know you only have to use it on MS Windows.


## What now?

While Perl might not be the best language for desktop applications, it is certainly a lot of fun creating GUIs
with Perl. Enjoy!


## Comments

Tkx (Yet another Tk interface) is another option.

thanks. added, though I see it has not seen a release for quite some time.


Agree that it hasn't been updated recently. Do not know if that is because it is a thin wrapper for Tcl - thus no updates needed, or a lack of interest. At one time, Tkx was as the option to use when the Tk package had not been updated for a while.


