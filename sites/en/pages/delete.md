---
title: "delete an element from a hash"
timestamp: 2021-09-30T08:30:01
tags:
  - delete
  - exists
published: true
books:
  - beginner
author: szabgab
archive: true
---


The [delete](https://metacpan.org/pod/perlfunc#delete-EXPR) function will remove the given key from a hash.


{% include file="examples/delete.pl" %}

At first the key "Foo" `exists` in the hash and after calling `delete` it does not exist any more.

Result:

```
Foo exists
$VAR1 = {
          'Foo' => '111',
          'Moo' => undef,
          'Bar' => '222'
        };
Foo does not exist
$VAR1 = {
          'Moo' => undef,
          'Bar' => '222'
        };
```
