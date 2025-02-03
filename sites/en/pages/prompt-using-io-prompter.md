---
title: "Prompt for user input using IO::Prompter"
timestamp: 2019-04-27T12:30:01
tags:
  - IO::Prompter
  - prompt
  - STDIN
published: true
author: szabgab
archive: true
---


In a [Command Line Interface](/cli) you will probably need to ask the user for input.
You can do that by [reading from STDIN](/read-from-stdin) yourself or by using a module
to wrap your interaction with the user.

[IO::Prompter](https://metacpan.org/pod/IO::Prompter) is a module that you can use.



## Simple input and input passwords

In the first example we ask the user for a simple input and then we ask for a password. The special thing
in the password is that we don't want the system to echo back the characters as we type them so other
people won't see them.

{% include file="examples/prompter_credentials.pl" %}


## Selector

In the second example we see how to ask the user to select an item from a list of items:

{% include file="examples/prompter_selector.pl" %}

