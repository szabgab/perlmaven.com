---
title: "Restrict the import by listing the functions to be imported"
timestamp: 2017-02-17T07:45:11
tags:
  - import
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


As seen in the [previous episode](/import) if a module author exports a list of functions, for example:
`our @EXPORT = qw(add multiply);` and if the module user loads the module using `use Module::Name;`
then the user will get **all** the functions listed in the `@EXPORT` array.

This can be dangerous.


{% youtube id="cbZoVOAVkgA" file="advanced-perl/libraries-and-modules/restrict-the-import" %}

If I just import everything the module provides and then I upgrade the module, then
in the new version the module might start to export several new functions that can collide
with existing function in my code, or functions that are being imported from other modules.

That's why I always recommend to restrict the list of functions one imports as it is done in the
example in **calca_2.pl**:

```perl
#!/usr/bin/perl
use strict;
use warnings;

use A::Calc qw(add);

print add(2, 3), "\n";
```

As a user of a module, when I load the module with the `use` statement, I can also
provide a list of functions I'd like to import from the module. This must be a subset of the
functions being exported, but this way I can explicitly say which function I'd like to have
in my name-space.

This has several advantages:

1. I won't be surprised by the module exporting additional functions. They will not be imported by my code.
1. If the function was removed from the newer version of the module, I'll notice it as perl will complain about the missing function.
1. Helps documenting the code.

Just imagine you load lots of modules. Each one imports several functions. Then someone, who is not familiar with you code-base
starts to read the code. Sees an `add` function but she does not know where that function comes from. She has to go over all
the modules in order to find out which one declared and exported the `add` function.

If we explicitly wrote the list of the functions that we import, then searching in the same file for a declaration
is very easy.

The maintainer of your code will thank you if in every case where relevant you have explicitly declared the list of
functions.

