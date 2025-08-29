---
title: "Refactoring code snippet"
timestamp: 2021-01-13T10:30:01
tags:
  - refactoring
published: true
author: szabgab
archive: true
show_related: true
---


Recently I encountered a Perl script that had some issues. e.g. Lack of [use strict](/always-use-strict-and-use-warnings).

Let me show a quick refactoring of it:


## Part of the original code

{% include file="examples/code_snippet0.pl" %}

There are some interesting things here:

* missing **use strict**
* But declaring the global variable **$copyrightsfile** using **my**
* Not declaring **@COPYRIGHTS** (in plural) at all even though it is a global variable.
* Not declaring **@COPYRIGHT** (in singular) either, even though it should be locally scoped. And the confusion of having two arrays with very similar names.
* Using the implicit **$_** might be considered "perlish" by some, but I prefer to have a named variable in its place.
* I addedd the Data::Dumper code to make it easier to see the results.

## Sample imput file

{% include file="examples/code_snippet.txt" %}

Result:

```
$VAR1 = [
          {
            'firstname' => 'Jane',
            'lastname' => 'Doe'
          }
        ];
```


## Add **use strict**, Use lexical file-handle

Lexical file-handles and 3-part open.

That forces us to declare our varibales with **my**.

{% include file="examples/code_snippet1.pl" %}

## Replace @COPYRIGHT, by $firstname, $lastname

{% include file="examples/code_snippet2.pl" %}

## Use explicit $line instead of $_ in the while loop

{% include file="examples/code_snippet3.pl" %}

