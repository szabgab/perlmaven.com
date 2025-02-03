---
title: "Add more tests to the Markua parser"
timestamp: 2018-04-05T10:30:01
tags:
  - Devel::Cover
published: true
books:
  - markua
author: szabgab
archive: true
---


Looking at the [coverage report](/devel-cover-for-markua-parser), we can devise some additional test cases
that will cover cases we thought about earlier but have not fully covered.

Theoretically in Test Driven Development (TDD) this should not happen. We are only supposed to write code that already has tests,
but in reality I don't think if 100% test coverage is attainable.

I am quite sure even if it is possible, the cost/benefit ratio might not worth it.

Besides. We can easily write code that even when it has 100% test coverage it still has bugs in it.

So let's look at the details.


## File Coverage / Statement Coverage

At first we look at the Statemet Coverage for our only pm file. It sais 90.9% cocerage.
As we scroll down watching the 2nd column we can see 3 statements that are not covered.

The `die` statement on line 71. The other `die` statement on line 99
and the

```perl
push @errors, {
    row => $cnt,
    line => $line,
}
```

expression on lines 146-149.

At this point none of them seems to worth the effort to write tests for. They are there to catch issues
during the development. And yes, we don't need a `die` statement on line 146 instead of
that `push` because our tests will fail if that line is ever executed during tests.

{% include file="examples/markua-parser/bb9bc43/lib/Markua/Parser.pm" %}

## Branch Coverage

The next level of details is looking at the Branch Coverage.

![](/img/markua-parser-branch-coverage.png)


## One-element numbered list

On line 60 the `if ($self->{tag} eq 'numbered-list') {` statement is never false. At first I thought it is because
we don't have one-element numbered lists in the test cases. Accordingly I went ahead and created a test-case for a
numbered list that only has a single item which, accoring to the spec, should be considered as a paragraph.

Later I found out that the test coverage report was indicating something else.

Oups.

Luckily, handling 1-element numbered lists is a special case in Markua, so we should have a test case and a proper implementation for it.

Anyway, let's see the test-case for the 1-element numbered list:
{% include file="examples/markua-parser/ce64f3e/t/input/numbered-list-1-item.md" %}

When I ran `perl bin/generate_test_expectations.pl` it generated the `t/dom/numbered-list-1-item.json`, but in it there were two lists. Clearly the code does not work properly. (Not surprising, I have not thought much about this example).

The solution was adding some code to the `save_tag` function to start to verify that the we have a proper numbered list.

Once that solution was in place, the `perl bin/generate_test_expectations.pl` generated the DOM I was expecting.

{% include file="examples/markua-parser/ce64f3e/t/dom/numbered-list-1-item.json" %}

All the other JSON files did not change so I knew I made progress.

```
git add .
git commit -m "test case for one-element numbered list"
git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/ce64f3e834e428e20c13341fa9d2285098b96158)


## Numbered or bulleted list in another element

I've created a test case with two cases. In one switching from numbered list to bulleted list, in the second the other way around.
AFAIK both should be parsed as paragraphs and both should have a error reported.

{% include file="examples/markua-parser/d6064c9/t/input/switching-lists.md" %}

Running the DOM genrator:

```
perl bin/generate_test_expectations.pl
```

I got the following exception:

```
What to do if a bulleted list starts in the middle of another element? at lib/Markua/Parser.pm line 99.
```

Adding an error to the `@errors` array and converting the list to a paragraph.

I ended up with this DOM:

{% include file="examples/markua-parser/d6064c9/t/dom/switching-lists.json" %}

and this error:

{% include file="examples/markua-parser/d6064c9/t/errors/switching-lists.json" %}

```
git add .
git commit -m "test and implement swiitching between list types"
git push
```

