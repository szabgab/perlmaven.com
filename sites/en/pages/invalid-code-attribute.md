---
title: "Invalid CODE attribute"
timestamp: 2021-04-09T11:31:01
tags:
  - Attribute::Handlers
published: true
author: szabgab
archive: true
show_related: true
---


I encountered <b>Invalid CODE attribute</b> error quite a few times while trying to write examples for [Attribute::Handlers](/attribute-handlers).


In a basic case this would happen if you try to set an attribute on a function that has not been declared.

The obvious case is this, when we have not declared the <b>Wrap</b> attribute in the code:

{% include file="examples/attributes/wrap.pl" %}

However this also happened to me when I was trying to <b>import</b> the attribute from the module where I declared it.
The only solution I found so far is to inherit from the module (e.g. using <b>base</b>) as you can see in the
article about [Attribute::Handlers](/attribute-handlers).
