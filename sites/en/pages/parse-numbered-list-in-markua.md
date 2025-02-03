---
title: "Parse numbered list in Markua"
timestamp: 2020-05-06T08:32:01
tags:
  - 1)
  - 1.
published: true
books:
  - markua
author: szabgab
archive: true
---


I am not sure if we have fully implemented the [bulleted list parsing](/parse-bulleted-list-in-markua), but we can sat that aside for now and start to implement the [numbered lists](https://leanpub.com/markua/read#numbered-lists). It seems to be a lot more complicated as the bulleted list. There are a lot more options.

Also I have a feeling that there are some issues in the spec or just some thing that I have not understood yet. I've asked Peter, the author about them. We'll see.

Anyway let's start with some simple cases and then learn more and make progress that way.


## Start with simple test casses

As before we start with the creation of test cases.

{% include file="examples/markua-parser/60c8214/t/input/numbered-list-1-3.md" %}

## Processing numbered lists

In the case of the [bulleted lists](/parse-bulleted-list-in-markua) we constantly checked if the list is still as expected and we maintained an attribute called "ok" to indicated if it is still ok or if there was a problem.

In the case of the numbered lists this is going to be a lot harder the numbers can be ascendig, descending, or fixed. In order to know which one and if the list behaves properly we would need the information for the whole list.

So let's delay the decision if list being ok or not ok to the end of processing the list in the `save_tag` function.

Every time when we encounter a line that looks like part of a numbered list we store the parsed data structure about it in the "list" attribute. Including the origial line as "raw". That will be useful in case we need to revert the whole thing to be a simple paragraph entry.

In the `save_tag` we <b>should</b> verify that the number is correct, but for now we don't do that. We just add a <b>TODO</b> note to remind us to come back to this later. Fir now we assume that the list is correct.

We remove the attributes that we don't really need to save ("raw", "sep", "space"). They will be useful for the verification step that we are skipping now.

{% include file="examples/markua-parser/60c8214/lib/Markua/Parser.pm" %}

## Expected DOM

When we run `perl bin/generate_test_expectations.pl` we generate the expected DOM that looks like this:

{% include file="examples/markua-parser/60c8214/t/dom/numbered-list-1-3.json" %}

## New commit

```
git add .
git commit -m "parse numbered list"
git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/60c821462e0aa060c8d2ed5a643a6ee9c2647302)

Coveralls reports: `coverage decreased (-16.9%) to 80.435% for commit: parse numbered list`

Looking at the report, I just realize I've forgotten to add the new test case to the list in the `t/01-test.t` file.

This is the second time I make this mistake. How could I avoid it?

## Avoid forgetting to add test-case

I can stop having a fixed list of test-cases, just go over the list of files in the `t/input/` directory. That would work, but then I don't have control over the order of the tests cases. Which, thinking about it again, might no be an issue.

The alternative would be to add a test case that checks if the list I have in the test-file is the full list of files in the `t/input` directory. This can also make sure I don't skip any of the test files by mistake. Then again, if I do skip some tests cases the test coverage will fall and I'll know about it.

Both solution assume that I'd want to run all the test cases. This is correct now, though if I ever need to reimplement the parser I might want to start with the re-implementation of only some of the test cases.

That's not now. I guess I should not worry about it.

So I replaced

```
my @cases = ('heading1', 'headers', 'paragraphs', 'include', 'bulleted-list', 'bulleted-list-dash');
```

by

```
my @cases = sort map { substr $_, 8, -3 } glob 't/input/*.md';
```

```
git add .
git commit -m"read the list of test cases from the disk"
git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/b5440b0331479e8c695e8ca821d82dcdf4c0177e)


