---
title: "Refactor test cases of the Markua Parser in Perl 5"
timestamp: 2020-01-27T09:00:01
tags:
  - prove
published: true
books:
  - markua
author: szabgab
archive: true
---


Earlier I've mentined that I don't like the fact that we used copy-paste in the test script and duplicate code.
Before we go on and add more test, let's refactor the test code.



I've created an array called `@cases` listing all the (2) test cases. We'll have more.

```perl
my @cases = ('heading1', 'headers');
```

I've also changed the code processing the test cases to be in a loop and use the values
from the `@cases` array:

```perl
for my $case (@cases) {
    my $result = $m->parse_file("t/input/$case.md");
    is_deeply $result, decode_json( path("t/dom/$case.json")->slurp_utf8 );
}
```

Finally, though in the code it is earlier, I've updated the `plan` to be based
on the number of entries in the `@cases` array.


The previous test file is here:

{% include file="examples/markua-parser/c580d63/t/01-test.t" %}

The new test file is here:

{% include file="examples/markua-parser/79d9bfe/t/01-test.t" %}

We can then record our changes in git:

```
$ git add .
$ git commit -m "refactor test code"
$ git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/79d9bfe516ab143b5dc7b81e263f62e529c8c1da)


