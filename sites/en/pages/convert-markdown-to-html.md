---
title: "Convert Markdown to HTML"
timestamp: 2024-02-22T10:30:01
tags:
  - PerlMaven
published: true
types:
  - markdown
  - html
author: szabgab
archive: true
description: "Convert Markdown including tables to HTML"
show_related: true
---


I have lots of documents written in Markdown format and I was looking for a way to convert them to HTML.


First I tried the [Text::Markdown](https://metacpan.org/pod/Text::Markdown) module, it seemed like the obvious pick. Onfortunately it did not handle
tables.

Then I found [Text::MultiMarkdown](https://metacpan.org/pod/Text::MultiMarkdown) and that worked as I expected.

{% include file="examples/markdown.pl" %}

