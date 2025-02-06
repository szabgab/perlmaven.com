---
title: "What is @INC in Perl?"
timestamp: 2016-12-22T07:01:01
tags:
  - "@INC"
  - use
  - require
  - do
description: "@INC is the search-path for perl to find modules to be loaded"
published: true
author: szabgab
archive: true
---


`@INC` is a built-in array perl provides. It contains a series of directories, the "search path" for perl when trying to load a module.


When perl encounters a `use` statement, a `require` statement, or a `do` statement:

```perl
use Module::Name;
```

```perl
require Module::Name;
```

```perl
do "Module/Name.pm";
```


perl will go over the directories listed in `@INC` and check if the appropriate file can be found.

In our example, if we try to load `Module::Name`. Perl will check if there is a `Module` subdirectory in any of
of the directories with a file called `Name.pm` in the directory.

perl will load the first such file.

## Content of @INC

The content of `@INC` is baked into your version of perl when perl itself was installed and it differs
based on the version of perl and your operating system.
You can however change it in a number of ways via the `PERLLIB` and `PERL5LIB` environment variables,
using the `-I` command line flag, or inside the code by manipulating `@INC` directly.

Search for [@INC](/search/@INC) and you'll find your

## Real examples

A couple of real examples you can run to see these statements working.

{% include file="examples/do_file_basename.pl" %}

{% include file="examples/use_file_basename.pl" %}

{% include file="examples/require_file_basename.pl" %}

