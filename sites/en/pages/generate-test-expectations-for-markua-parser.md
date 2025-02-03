---
title: "Generate test expectations for the Markua parser"
timestamp: 2020-03-29T09:30:01
tags:
  - JSON::MaybeXS
  - pretty
  - sort_by
published: true
books:
  - markua
author: szabgab
archive: true
---


In every earlier test-case we created the Markua input file manually and then we created the expected DOM in JSON representation also manually.

When we implemented the parsing and testing of [Markua resources](/markua-resources-include-files) we ran the tests first and then took the dump of the error message and used that to create the JSON representation of both the DOM and the error report. It was a bit of unnecessary manual work. After all we could convert the generated DOM to JSON. Look at it to verify that we really  want that to be the expected results and then save it as the expected JSON.

How can we make this easier?


## Generate pretty JSON

I've created a script that will go over all the input files we have in the `t/input/` directory.
Parse each one of them and then save the resulting DOM and resulting errors (if there are errors) to the corresponding
JSON files.

{% include file="examples/markua-parser/f97f4a2/bin/generate_test_expectations.pl" %}

I used [JSON::MaybeXS](https://metacpan.org/pod/JSON::MaybeXS) as a front-end to the actual JSON encoder
though I personally use [Cpanel::JSON::XS](https://metacpan.org/pod/Cpanel::JSON::XS).

I've also set the "utf8", "pretty", and "sort_by" parameters to make sure we handle Unicode properl,
to make the JSON human readable, and to sort the keys in the hashes of the JSON data structure.

We need to make it human readable as we would like to be able to look at the JSON and decide if the data structure makes sense.

We need to sort the keys, otherwise every time I run this code it might generate the JSON in a slightly different order.

That would make it harder to manually verify that this is what we expect and it would also mean we change the JSON files without there be an actual meaningful change in the DOM.

We also save the errors in the `t/errors/` directory, but only if there were errors. We don't want a bunch of files with an empty pair of square brackets in them.

## The result

I ran the script. It updated all the files in the t/dom/ and t/errors directories. Looking at the <a href="">diff</a> we can see the changes in the level of indentation and the order of the keys. Hopefully, from now on these won't change as we used both the "pretty" and the "sort_by" parameters.

[commit](https://github.com/szabgab/perl5-markua-parser/commit/f97f4a29a77b600c6df288eb37d5c486df24063a)
