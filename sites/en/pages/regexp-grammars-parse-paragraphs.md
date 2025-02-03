---
title: "Parse paragraphs with Regexp::Grammars"
timestamp: 2021-06-17T06:30:01
tags:
  - Regexp::Grammars
  - nocontext
  - token
  - rule
  - _Sep
published: true
author: szabgab
archive: true
---


[Regexp::Grammars](https://metacpan.org/pod/Regexp::Grammars) can be scary. Let's try to have a simple and useful example.


Before you can get started, you'll need to [install](/how-to-install-a-perl-module-from-cpan) [Regexp::Grammars](https://metacpan.org/pod/Regexp::Grammars)
and [Path::Tiny](https://metacpan.org/pod/Path::Tiny) that I used as a helper module to read in the content of the text file.

This is the text file. Nothing fancy, just a few paragrapsh separated by empty rows. What we can't easily see in this display
is that between the 2nd and the 3rd paragraph that line is not really empty. There are a few spaces on that line. Nevertheless we would like to
conside that as well a paragrah-separator.

{% include file="examples/data/text_with_paragraphs.txt" %}

The most compact solution I found:

{% include file="examples/parse_paragraphs.pl" %}

Running it results in :

```perl
$VAR1 = {
          'Text' => {
                      'Paragraph' => [
                                       'start text',
                                       'a second paragraph
that has two lines',
                                       'A third paragraphs
    with indented 2nd line.'
                                     ]
                    }
        };
```

First let's go over this solution and then we will also see some of my earlier attempts.

`nocontext` tells the parser to exclude some extra tags that would probably help in debugging. We don't really need them in our results.

The `Text` rule represents the whole text.

* `\A` always matches the beginning of the input string.
* `\Z` always matches the end of the input string.
* `&lt;[Paragraph]&gt;+` - the `+` tells the parser to match the "Paragraph" 1 or more time. The square brackets tell the parser to create an array of the results, instead of just including the last one.
* `%` tells the parser that we are about to tell what separates the "Paragraph" matches.`
* The next snippet is the separator. The `_Sep` gives a name for the sub-rule. It can be any name, however the underscore `_` at the beginning of the name that tells the parser to exclude the captured separator from the results. (See <a hre="https://metacpan.org/pod/Regexp::Grammars#Private-subrule-calls">Private subrule calls</a> for explanation.)
* In the next row we declare the "Paragraph" to be a substring that beginns at the beginning of a line `^` and end at the end of a line `$`. Instead of beginning and end of the whole string they match beginning and of a line due to the "m" modifier at the end of the regex. In the content of the regex `.` matches any character, including newlines as instructed by the `s` modifier at the end of the regex. `*` is the catch-all quantifier and `?` makes it a minimal match.
* The x modifier at the end of the regex makes it possible to include all the white-spaces in our regex to make it more readable.

See the [Regex Cheat sheet](/regex-cheat-sheet) for more details.

## An extra document

Before I got to the above solution, I had an extra rule wrapping the whole thing, but later I found out I can but the `\A` and `\Z` on the "Text" rule.

{% include file="examples/parse_paragraphs_document.pl" %}

The results had this extra level of "Document" that is really not necessary:

```perl
$VAR1 = {
          'Document' => {
                          'Text' => {
                                      'Paragraph' => [
                                                       'start text',
                                                       'a second paragraph
that has two lines',
                                                       'A third paragraphs
    with indented 2nd line.'
                                                     ]
                                    }
                        }
        };
```

## The separator as a separate token

Before using the `_Sep` tag to declare the item-separator in the same rule where it is used, I had it in a separate token and it was called "Sep".

{% include file="examples/parse_paragraphs_sep.pl" %}

The result was correct, but it included the extra field "Sep" that was a bit unnecessary.
Later I found out that the reason in the above solution we don't have the sepaator is the leading nderscore `_` and not the fact that it was declared inline. So I could change this solution and rename the separator to something starting with `_` and still keep it as a separate token.

```perl
$VAR1 = {
          'Document' => {
                          'Text' => {
                                      'Sep' => '

',
                                      'Paragraph' => [
                                                       'start text',
                                                       'a second paragraph
that has two lines',
                                                       'A third paragraphs
    with indented 2nd line.'
                                                     ]
                                    }
                        }
        };
```

## Deep recursion

The first successful solution I had did not use the quantifier on the Paragraph, (no repetition operator), instead it used a recursive declaration that a "Text" can be either a single "Paragraph" or it can be a "Paragraph", followed by a separator of "\n\s*\n", followed by some more "Text".

{% include file="examples/parse_paragraphs_deep.pl" %}

The result was corect here too, but it had a deep data structure. Probably not easy to work with later on and certainly not representing properly the fact that the paragraps are siblings.

```perl
$VAR1 = {
          'Document' => {
                          'Text' => {
                                      'Paragraph' => 'start text',
                                      'Text' => {
                                                  'Text' => {
                                                              'Paragraph' => 'A third paragraphs
    with indented 2nd line.'
                                                            },
                                                  'Paragraph' => 'a second paragraph
that has two lines'
                                                }
                                    }
                        }
        };
```

## Failed attempt

Before finding the working solutions I had tons of failed attempts.
Onve of them is here, in which I already included the separator, but have not turned it into a proper sub-rule.

{% include file="examples/parse_paragraphs_no_subrule.pl" %}

The result was this:. Each line was captured as its own "Paragraph".

```perl
$VAR1 = {
          'Text' => {
                      'Paragraph' => [
                                       'start text',
                                       'a second paragraph',
                                       'that has two lines',
                                       'A third paragraphs',
                                       '    with indented 2nd line.'
                                     ]
                    }
        };
```

