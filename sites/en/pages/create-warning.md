---
title: Create a lexical warning that can be turned on and off with the "warnings" pragma.
timestamp: 2021-06-14T08:10:01
tags:
  - warnings
  - warnings::warnif
  - warnings::enabled
published: true
author: szabgab
archive: true
---


Since the release of Perl 5.6 in 2000 we can and should use the `warnings` pragma.
It allows the turning on and off of warnings in lexical blocks, that is withing any set of curly praces.

It also allows us to create our own warnings together with our own warning categories.


## Warn in a module with your own category

This is how you can add a lexical warning to your code:

{% include file="examples/MyMod.pm" %}

Then if you call the `MyMod::f` function with the incorrect number of parameters,
for example without any parameters, then you get a warning. (Assuming `use warnings` was
added to your code.

You can turn off this specific warning in the whole file or in a block of code (enclosed in curly braces)
with the `no warnings 'MyMod';` statement as it is done in the middle of this script:

{% include file="examples/mycode.pl" %}

If we run `perl mycode.pl` we get the following output:

<pre>
Function f() must be called with 1 parameter! Calleed at mycode.pl line 7.
Use of uninitialized value $x in addition (+) at MyMod.pm line 14.
Use of uninitialized value $x in addition (+) at MyMod.pm line 14.
Function f() must be called with 1 parameter! Calleed at mycode.pl line 16.
Use of uninitialized value $x in addition (+) at MyMod.pm line 14.
done
</pre>

So the 1st and 3rd calls emit our warning, but the 2nd call, where we turned off this specific warning will only emit
the "uninitialized" warning.


## Use existing warning categories

Instead of having your own warnnig category based on the name of the module where you registered it
you can also reuse [existing categories](https://metacpan.org/pod/warnings#Category-Hierarchy),
and make your warning dependent on those.

This can be done by passing the name of that category to the `warnings::enabled()` function:

{% include file="examples/MyMod2.pm" %}

Then we turn on-off the warning using that category:

{% include file="examples/mycode2.pl" %}

The output then:

<pre>
Function f() must be called with 1 parameter! Calleed at mycode2.pl line 7.
Use of uninitialized value $x in addition (+) at MyMod2.pm line 14.
Use of uninitialized value $x in addition (+) at MyMod2.pm line 14.
Function f() must be called with 1 parameter! Calleed at mycode2.pl line 16.
Use of uninitialized value $x in addition (+) at MyMod2.pm line 14.
done
</pre>

## warnif

Instead of the long form:

```
if (warnings::enabled('cat')) {
    warnings::warn('text');
}
```

We could achieve the same using `warnif`:

```
warnings::warnif('cat', 'text');
```

