---
title: "Add attributes to Markua - round 1"
timestamp: 2020-06-15T07:00:01
tags:
  - attributes
  - type
  - format
published: true
books:
  - markua
author: szabgab
archive: true
---


The [Markua specification](https://leanpub.com/markua/read) has plenty of information about [attributes](https://leanpub.com/markua/read#attributes) that are key-value pairs attached to the elements of a Markua file. One can add attributes manually in a JSON-like format, but there are certain attributes that are created automatically.

An explicit attribute list looks like this:

```
{key_one: value1, key_two: value_two, key_three: "value three!", key_four: true, key_five: 0, key_six: 3.14}
```

An example of implicit attributes are `{type: code, format: text}` attached to resource that are decided base on the extension of the included file.

Let's start adding the implicit attributes to included files.


The spec defines the mapping of file extensions to [resource types and formats](https://leanpub.com/markua/read#resource-types-and-formats) and says that if the extension not in the table then the default `type` is `code` and the default `format` is `guess`. As I understand that will leave the the guessing of the actual programming language to a later stage in the processing.

## Mapping of extension to format and type

I've created a partial copy of the [resource types and formats](https://leanpub.com/markua/read#resource-types-and-formats) in the code and then wrote some code to split it up into two hashes. I felt this way we can have a nice, human-readable table of the mapping and then use it in the code as well:

```perl
# Based on https://leanpub.com/markua/read#resource-types-and-formats
my $extensions = <<'EXTENSION';
txt        text    code      Unformatted code
(other)    guess   code      Formatted code
jpeg       jpeg    image     JPEG image
jpg        jpeg    image     JPEG image
png        png     image     PNG image
EXTENSION

my %format;
my %type;
for my $line (split /\n/, $extensions) {
    chomp $line;
    my ($ext, $format, $type) = split /\s+/, $line;
    $format{$ext} = $format;
    $type{$ext} = $type;
}
```

## Add attributes to resources

In the part of the code that parses the include elements, I've added this to extract the extension from the filename
and then look it up in the two hashes we created earlier. This will create the `%attr` hash.

```perl
my ($extension) = $file_to_include =~ m{\.(\w+)\Z};
if (not defined $extension or not exists $format{$extension}) {
    $extension  = '(other)';
}

my %attr = (
    type   => $type{$extension},
    format => $format{$extension},
);
```

A few lines later I've also included the `%attr` in the hash appended to the `@entries` array:

```perl
eval {
    my $text = path("$dir/$file_to_include")->slurp_utf8;
    push @entries, {
        tag   => 'code',
        title => $title,
        text  => $text,
        attr  => \%attr,
    };
};
```

## Update the expected DOM

If I run the tests now they will fail as the code changes will also change the DOM. So first we run

```
perl bin/generate_test_expectations.pl
```

and let it update the JSON files that contain the expected DOM. The only file that changes was the `t/dom/include.json` that had examples of including files. I looked at the changes. They looked exactly as I thought the attributes should be added.

The expected DOM now looks like this:

{% include file="examples/markua-parser/e97efb5/t/dom/include.json" %}

## Test and commit

Now we can make sure nothing else broke by running the tests `prove -l` and then we can commit the changes:

```
git add .
git commit -m "add type and format attributes to included files"
git push
```

[commit](https://github.com/szabgab/perl5-markua-parser/commit/e97efb5cf356407d41fe770f682d705be954dfdb)

## Improved test coverage?

After a few minutes I got the e-mail from Coveralls: `coverage increased (+0.1%) to 96.875% for commit: add type and format attributes to included files`. This actually surprised me. After all we have added a conditional statement checking if we can recognize the file-type based on the extension and out of the 3 cases we only covered one.

1. no extension
1. extension in the table
1. extension not in the table

We only covered the 3rd case.

Let's see what Devel::Cover says about this.

