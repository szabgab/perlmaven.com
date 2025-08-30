---
title: "exists - check if a key exists in a hash"
timestamp: 2020-08-15T18:00:01
tags:
  - exists
published: true
books:
  - beginner
author: szabgab
archive: true
---


In a hash a key-value pair have 3 different possible statuses.

The `defined` function checks if a **value** is [undef](/undef) or not.

The `exists` function check if a **key** is in the hash or not.

Those two conditions create 3 valid situations.


## Syntax of exists

```perl
if (exists $phone_of{Foo}) {
}
```

This code checks of the hash `%phone_of` has a key "Foo".


## The 3 valid situations of a key-value pair

* There is a key and the value which is not `undef` then both the `exists` and `defined` functions will return true.
* There is a key and the value is `undef` then `exists` will return true and `defined` will return false.
* If there is no such key, then there cannot be a corresponding values. In that case both `exists` and `defined` will return false.

## An example

{% include file="examples/exists.pl" %}

In this hash the key Foo `exists` and its value is `defined`.

The key Qux `exists` but its values is NOT `defined`.

Finally the key `Bar` NOT `exists` and if we check the defined-ness of its value we get false.

```
Foo exists
Foo: defined
Qux exists
Qux not defined
Bar does not exist
Bar not defined
```


## Conclusion

If `defined $hash{key}` is false we still don't know if the key is in the hash or not.
So normally first you need to check `exists $hash{key}` and only then `defined $hash{key}`.


