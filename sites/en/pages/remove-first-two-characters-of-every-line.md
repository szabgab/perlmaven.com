---
title: "One-liner: Remove first two characters of every line"
timestamp: 2023-03-14T21:30:01
tags:
  - perl
published: true
author: szabgab
archive: true
show_related: true
---


In a project creating a [Ladino dictionary](https://kantoniko.com/) in which I have a few thousands of [YAML](/yaml) files. They used to include lists of values, but a while ago I split them up into individual entries. I did this because the people who are editing them are not used to YAML files and it makes it a lot easier to explain them what to do.

However the previous change left me with 1-item lists in each file. I wanted to clean that up.


## Example files

Here are a few examples files that were also reduced in size for this demo.

{% include file="examples/remove-columns/a.yaml" %}
{% include file="examples/remove-columns/b.yaml" %}
{% include file="examples/remove-columns/c.yaml" %}

As you can see each one has an entry for a Ladino expression. Some of the files have translations to English. Other files in the real data-set had further translations to Hebrew, Turkish, French, Portuguese, and Spanish.

Some files had comments.

That dash at the first row and the indentation is the left-over from the time when more than one of these were in each file.

So I wanted to get rid of the first two columns in every line, except when they start with a hash-mark (#).

Here is the Perl one-liner to do so.

```
perl -p -i -e 's/^[^#].//' *.yaml
```


* The '*.yaml' at the end is a shell expression that will list all the YAML files in the current directory as the parameters of this command.
* The -p tells perl to read the content of each file line-by-line and print it.
* The -i tells perl to replace the original files with the content that was printed.
* The -e tells perl that the following string is a perl program and not the name of the file where the perl program is
* The perl program 's/^[^#].//' will be execute on every line read from the files.
* The 's///' is regex substitution. It works on the current line and changes the current line. So the lines that are saved back to the files are the modified lines.
* Between the 1st and 2nd slash is the regex.
* The first <b>^</b> means the match must start at the beginning of the line.
* The <b>[^#]</b> means that there must be a character that is not <b>#</b>. This will match any character on the first place of the file except #.
* The <b>.</b> means match any character</b>.
* The string that is between the 2nd and 3rd slash is the replacement. It is an empty string so if there is a match it will be replaced by the empty string.

That's the whole thing.

## Improvement

Now that I am explaining it, it occurred to me that this would be a safer solution:

```
perl -p -i -e 's/^[- ] //' *.yaml
```


Here the regex is <b>s/^[- ] //</b> which means the first character must be either a dash or a space and the second character must be a space and those two are replaced.
So if there is anything else as the first two characters the line will not be changed. This is safer as it is more specific as what we would like to match for replacement.

## Results

For this article I saved the resulting files in a separate place:

{% include file="examples/remove-columns-after/a.yaml" %}
{% include file="examples/remove-columns-after/b.yaml" %}
{% include file="examples/remove-columns-after/c.yaml" %}

