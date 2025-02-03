---
title: "Parse bulleted list in Markua"
timestamp: 2020-05-23T20:31:01
tags:
  - *
  - -
published: true
books:
  - markua
author: szabgab
archive: true
---


Markua supports bulleted lists and numbered lists as explained in the section about [lists](https://leanpub.com/markua/read#leanpub-auto-lists).

We are going to implement the parser for the [bulleted list](https://leanpub.com/markua/read#bulleted-lists) first.


After reading the spec the first thing is to create a sample input file with various cases.

{% include file="examples/markua-parser/7c1ed67/t/input/bulleted-list.md" %}

As we already have the [DOM generator script](/generate-test-expectations-for-markua-parser) we created earlier we can run that to see what happens.

```
perl bin/generate_test_expectations.pl
```

It created a file called `t/dom/bulleted-list.json` with the following content:

```
[
   {
      "tag" : "p",
      "text" : "* A list with a single bullet"
   },
   {
      "tag" : "p",
      "text" : "*  Two spaces\n*  Another bullet point with 2 spaces"
   },
   {
      "tag" : "p",
      "text" : "*    Four spaces is still a bulleted list"
   },
   {
      "tag" : "p",
      "text" : "*     Five spaces is not a bulletted list"
   },
   {
      "tag" : "p",
      "text" : "* One space\n*  Another number of spaces. The whole thing becomes a paragraph"
   },
   {
      "tag" : "p",
      "text" : "*No space means it is a paragraph"
   }
]
```

Everything was considered as paragraph.

## Implement parser

We can now start implementing our parser code (starting at line 34) and we can keep running the DOM generator to see if we make progress.
The regex `m{\A(\*)( {1,4}|\t)(\S.*)}` will match a row that starts with an star, followed by 1-4 spaces or a tab,
followed by some text. At least one character that is not a space or tab and then optionally more characters that can already include spaces and tabs as well.

According to the spec a bulleted list can be marked by either an star or a hyphen, but we can't mix them. We'll deal with hyphen later on.

The number of spaces also must remain the same in any give list.

If the parser is not currently in any tag then we store the information in our object. Including in the "tag" attribute.

If we are already in a list we verify that we still have the same bullet-type, the same spacing. If not we mark the whole list as not being a proper list by setting `$self->{list}{ok}` to 0.


In the `save_tag`  method we deal with lists separately. If it is a proper list ("ok" being true) then save it as it is.
Otherwise we convert th whole thing into a paragraph and let the rest of the function deal with it.

{% include file="examples/markua-parser/7c1ed67/lib/Markua/Parser.pm" %}

Once we implemented it to our satisfaction we can run `bin/generate_test_expectations.pl` again that will generate the following file:

{% include file="examples/markua-parser/7c1ed67/t/dom/bulleted-list.json" %}

I think this representation of the document is good for now. More or less. One thing I noticed that I don't like is that when we have a list where the number of spaces is not correct, and we treat it as a paragraph, we have eliminated the bullets. I think we need to fix that later.

For now, however, let's accept this version.

I've added the test "bulleted-list" to the test script:

{% include file="examples/markua-parser/7c1ed67/t/01-test.t" %}

Then I could run the tests and they all passed.

```
git add .
git commit -m "parse bulleted list"
git  push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/7c1ed67959d4bcd32a86417c6a3666a35050f0f8)

A few minutes later I got the e-mail notifying me that `coverage decreased (-0.6%) to 97.059% for commit: parse bulleted list`
Looking at the coverage report revealed that the line that was not covered was the line I added to make sure we have a very laud failure if we encounter some input that we did not know how to handle:

```
die "What to do if a bulleted list starts in the middle of another element?";
```

I can live with that line not being covered now.

## Bulleted list with a dash (hyphen)

The spec allows the use of `-` dash (or hyphen) instead of a `*` star for marking bulleted lists.

The only change we had to implement was in the regex to let it accept either a star or a dash:

`m{\A([\*-])( {1,4}|\t)(\S.*)}`

I've also copied the `t/input/bulleted-list.md` file to `t/input/bulleted-list-dash.md`, replaced the stars with dashes.

```
git add .
git commit -m "allow hyphen as well for bulleted lists"
git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/f476e01dd4aa4cfb3f3c007a6c229f04b5ac3b52)

A few minutes later I got an e-mail from Coveralls telling me `coverage decreased (-97.06%) to 0.0% for commit: allow hyphen as well for bulleted lists`. That is really strage. At first I thought maybe I broke the tests, but as I can on [Travs-CI](https://travis-ci.org/szabgab/perl5-markua-parser/builds/359264490) all the test pass. I am not sure how to understand this.

While trying to figure this out I noticed that I've forgotten to add the new `bulleted-list-dash` to the list of test-cases
in `t/01-test.t`. So I did that then committed the change again:

```
git add .
git commit -m "add bulleted-list-dash test case"
git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/c9676f37fe20feb1cf2e8f5d1033b150e473ab70)

Coveralls sent me a new e-mail: `coverage increased (+97.06%) to 97.059% for commit: add bulleted-list-dash test case`.

Really strange.


## Fix the incorrect list to paragraph switching

As I've mentioned earlier there is an issue that I don't like. In one of the examples where we had to fall back to interprete the list as a paragraph, we actually lost the bullets and the newslines.

In order to keep the original text we need to keep the raw data during the processing of the list. Then, if it is a proper list we discard the raw lines, but if we need to revert back to be a paragraph, thn we can use the raw strings.

This is what we did.

```
git add .
git commit -m "Fix the incorrect list to paragraph switching"
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/86b1b846b0421f4d4272f5577a172615f88cee08)

## Remove unnecessary fields from the DOM of lists

Just as we added the raw lines, we also included a number of additional fields in our DOM that is not necessary once we have processed the bulleted list. Earlier we included these fields in the DOM and so they also appeared in the expected DOM.

In the next change we have removed these fields just before we store the data. This will remove them from the DOM as well.

That means if we want our tests to keep working we'll need to update the expected data structures.

Luckily the `bin/generate_test_expectations.pl` script can generate the new version of the strings representing the DOM.

```
git add .
git commit -m "remove unnecessary fields from the DOM of lists"
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/e338a0c1e892ae7f791c9fbbcb65483ee339345f)

Coveralls reports: `coverage increased (+16.4%) to 96.842% for commit: read the list of test cases from the disk`

Back to normal.

