---
title: "POD - modules processing Plain Old Documentation format"
timestamp: 2015-09-23T08:30:01
tags:
  - POD
published: true
author: szabgab
archive: true
---


POD is the format the documentation of Perl and every Perl modules is written.

There are many tools parsing them, extracting information and converting them to other formats.


## Recommended

[Pod::Simple](https://metacpan.org/pod/Pod::Simple), framework for parsing Pod.

[Test::Pod](https://metacpan.org/pod/Test::Pod) check for POD errors in files.

[Pod::Weaver](https://metacpan.org/pod/Pod::Weaver) weave together a Pod document from an outline.

[Pod::Perldoc](https://metacpan.org/pod/Pod::Perldoc) Look up Perl documentation in Pod format. (This is what the `perldoc` command uses.)

[Pod::Html](https://metacpan.org/pod/Pod::Html) convert pod files to HTML (part of Perl core. provides the `pod2html` command).

## Other

(not categorized yet)

[Pod::Readme](https://metacpan.org/pod/Pod::Readme)

[Pod::Tree](https://metacpan.org/pod/Pod::Tree) can create a syntax tree from POD file. Looks interesting though it had not seen
a new release since 2010.

[Pod::S5](https://metacpan.org/pod/Pod::S5) Generate S5 slideshow from POD source.

[Pod::Perldoc::ToToc](https://metacpan.org/pod/Pod::Perldoc::ToToc) Translate Pod to a Table of Contents.

[Pod::POM](https://metacpan.org/pod/Pod::POM), POD Object Model needs a new maintainer.

[Pod::Man](https://metacpan.org/pod/Pod::Man) Convert POD data to formatted *roff input. 

[Pod::XML](https://metacpan.org/pod/Pod::XML) Module to convert POD to XML. No version since 2007.

[Pod::Hlp](https://metacpan.org/pod/Pod::Hlp) convert POD data to formatted VMS HLP Help module text. No new release since 2001.
[Pod::Pdf](https://metacpan.org/pod/Pod::Pdf) A POD to PDF translator. No version since 2000. There are probably better solutions.


[Pod::Tests](https://metacpan.org/pod/Pod::Tests) Extracts embedded tests and code examples from POD.


[Pod::SAX](https://metacpan.org/pod/Pod::SAX) a SAX parser for Pod.

[Tk::Pod](https://metacpan.org/pod/Tk::Pod) Pod browser toplevel widget for Perl/Tk.

[Pod::Loom](https://metacpan.org/pod/Pod::Loom) Weave pseudo-POD into real POD.

[Pod::Parser](https://metacpan.org/pod/Pod::Parser) base class for creating POD filters and translators.
This module is considered legacy; modern Perl releases (5.18 and higher) are going to remove Pod-Parser from core and use Pod-Simple for all things POD.
[Pod::Find](https://metacpan.org/pod/Pod::Find)  find POD documents in directory trees (part of Pod::Parser).

[Pod::Spell](https://metacpan.org/pod/Pod::Spell) a formatter for spellchecking Pod

[Pod::CYOA](https://metacpan.org/pod/Pod::CYOA) Pod-based Choose Your Own Adventure website generator

[Pod::PXML](https://metacpan.org/release/Pod-PXML) Convert between POD and XML. (no release since 2004)

[Pod::Help](https://metacpan.org/pod/Pod::Help) Perl module to automate POD display.

[Pod::LaTeX](https://metacpan.org/pod/Pod::LaTeX) Convert Pod data to formatted Latex.

[LaTeX::Pod](https://metacpan.org/pod/LaTeX::Pod) Transform LaTeX source files to POD.

[Pod::Index](https://metacpan.org/pod/Pod::Index) Index and search PODs using X&lt;&gt; entries.

[Pod::PP](https://metacpan.org/pod/Pod::PP) POD pre-processor - has not seen any release for ages.
It is based on Pod::Parser which itself is considered legacy code.

[Pod::Rtf](https://metacpan.org/pod/Pod::Rtf), convert pod documentation to Rich Text Format (rtf) suitable for compilation by a Windows Help compiler.

[Lip::Pod](https://metacpan.org/pod/Lip::Pod) Literate Perl to POD conversion.

[Pod::Cats](https://metacpan.org/pod/Pod::Cats) The POD-like markup language written for podcats.in

[Pod::Site](https://metacpan.org/pod/Pod::Site) Build browsable HTML documentation for your app.


[Pod::L10N](https://metacpan.org/pod/Pod::L10N) Pod with L10N.

[Pod::Wrap](https://metacpan.org/pod/Pod::Wrap) Wrap pod paragraphs, leaving verbatim text and code alone. (no release since 2004.)
based on Pod::Parser.

[Pod::Stripper](https://metacpan.org/pod/Pod::Stripper) strip all pod, and output what's left. (no release since 2002)

[Pod::WSDL](https://metacpan.org/pod/Pod::WSDL) Creates WSDL documents from (extended) pod.

[Pod::Trac](https://metacpan.org/pod/Pod::Trac) Convert a POD to trac's wiki syntax and add it to the trac. (no release since 2007)

[Pod::Tidy](https://metacpan.org/release/Pod-Tidy) reformatting Pod Processor.


[Pod::HTML](https://metacpan.org/pod/Pod::HTML) Translate POD into HTML file (from 1996)

## POD Best Practices

Read [perlpod](https://metacpan.org/pod/perlpod) and [perlpodstyle](https://metacpan.org/pod/perlpodstyle).


