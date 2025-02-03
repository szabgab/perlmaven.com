---
title: "Regexp::Grammars parse text with markup or markdown"
timestamp: 2021-07-19T06:15:01
tags:
  - Regexp::Grammars
published: true
author: szabgab
archive: true
---


Parsing text with markup (or markdown) is not easy. It took me several days to wrap my head around this, but eventually I think I've figured it out.


## The input

We have some sample text. It has special parts enclosed in underscores `_`, other special parts enclosed in stars `*`, and
links with the format `link:URL[TITLE]`. How can we parse this and split it up into usable chunks?

{% include file="examples/data/text_with_markup.txt" %}

## Recursive parsing and flattening at the end

{% include file="examples/parse_text_flatten_with_structure.pl" %}

If we run this script, it will generate the following output:

```perl
$VAR1 = {
          'Document' => {
                          'Text' => {
                                      'FreeText' => 'The ',
                                      'Text' => {
                                                  'FreeText' => ' module is awesome. It makes parsing text in ',
                                                  'Star' => '*Perl*',
                                                  'Text' => {
                                                              'FreeText' => ' even ',
                                                              'Text' => {
                                                                          'FreeText' => '.
You can ',
                                                                          'Star' => '*easily*',
                                                                          'Text' => {
                                                                                      'FreeText' => ' ',
                                                                                      'Text' => {
                                                                                                  'FreeText' => ' ',
                                                                                                  'Star' => '*recursive*',
                                                                                                  'Text' => {
                                                                                                              'FreeText' => ' grammars, and once you figure it out, it is also easy to
parse text like this. Read more about it at ',
                                                                                                              'Link' => 'link:https://metacpan.org/pod/Regexp::Grammars[Regexp::Grammars]',
                                                                                                              'Text' => {
                                                                                                                          'FreeText' => '
Enjoy!'
                                                                                                                        }
                                                                                                            }
                                                                                                },
                                                                                      'Underscore' => '_create_'
                                                                                    }
                                                                        },
                                                              'Underscore' => '_easier than before_'
                                                            }
                                                },
                                      'Underscore' => '_Regexp::Grammars_'
                                    }
                        }
        };
```

followed by this output 

```perl
$VAR1 = [
          [
            'Text',
            'The '
          ],
          [
            'Underscore',
            '_Regexp::Grammars_'
          ],
          [
            'Text',
            ' module is awesome. It makes parsing text in '
          ],
          [
            'Star',
            '*Perl*'
          ],
          [
            'Text',
            ' even '
          ],
          [
            'Underscore',
            '_easier than before_'
          ],
          [
            'Text',
            '.
You can '
          ],
          [
            'Star',
            '*easily*'
          ],
          [
            'Text',
            ' '
          ],
          [
            'Underscore',
            '_create_'
          ],
          [
            'Text',
            ' '
          ],
          [
            'Star',
            '*recursive*'
          ],
          [
            'Text',
            ' grammars, and once you figure it out, it is also easy to
parse text like this. Read more about it at '
          ],
          [
            'Link',
            'link:https://metacpan.org/pod/Regexp::Grammars[Regexp::Grammars]'
          ],
          [
            'Text',
            '
Enjoy!'
          ]
        ];

```


Let's have an explanation for this working solution. Then we can see some other working solutions and then some failed experiments. Hopefully they will help better understand how this,
and Regexp::Grammars in general work.

Before you can get started, you'll need to [install](/how-to-install-a-perl-module-from-cpan) [Regexp::Grammars](https://metacpan.org/pod/Regexp::Grammars)
and [Path::Tiny](https://metacpan.org/pod/Path::Tiny) that I used as a helper module to read in the content of the text file.

In this solution first I used Regexp::Grammar to parse the text into a deep structure, and then added a loop to flatten it.

* `nocontext` is included only to eliminate some additional tags that are primarily used for debugging.
* We use the `\A` and `\Z` anchors to indicate that we would like the text to match the whole text.
      This is actually strange, I though the parser will match the whole text by default, but without those the last free-text part (the string "Enjoy!" was left off).
* The additional level of the "Document" is only needed so we can have the first text enclosed between those two anchors.
* The catch-all "FreeText"-only alternative in the definition of "Text" must be the last option or it will capture all the text not allowing the other parts to match anything.
* A "Text" is defined using "Text" itself, but it is critical that the recursive use of the "Text" token will come at the end of the expression. If it would come at the beginning, get an `Infinite recursion in regex` exception.
* We must use "token" for definition if we would like to keep the white-spaces between the words.


## Even flatter

Changing the flattening part (pushing the values only instead of small arrays)  will make the result even more compact,
but we lose the information about the types of elements we found.

{% include file="examples/parse_text_flatten.pl" %}

The result of the flattening now looks like this:

```perl
$VAR1 = [
          'The ',
          '_Regexp::Grammars_',
          ' module is awesome. It makes parsing text in ',
          '*Perl*',
          ' even ',
          '_easier than before_',
          '.
You can ',
          '*easily*',
          ' ',
          '_create_',
          ' ',
          '*recursive*',
          ' grammars, and once you figure it out, it is also easy to
parse text like this. Read more about it at ',
          'link:https://metacpan.org/pod/Regexp::Grammars[Regexp::Grammars]',
          '
Enjoy!'
        ];
```

## Catch-all must be the last alternative

In our solution the "FreeText" token will catch everything. Therefore in the definition of "Text",
the stand alone-case of "FreeText" must be the last art of the alternatives separated by `|`.

If we would put it as the first expression like in this version:

{% include file="examples/parse_text_short_first.pl" %}

we would get the following results:

```
$VAR1 = {
          'Document' => {
                          'Text' => {
                                      'FreeText' => 'The _Regexp::Grammars_ module is awesome. It makes parsing text in *Perl* even _easier than before_.
You can *easily* _create_ *recursive* grammars, and once you figure it out, it is also easy to
parse text like this. Read more about it at link:https://metacpan.org/pod/Regexp::Grammars[Regexp::Grammars]
Enjoy!'
                                    }
                        }
        };
```

The very first time "FreeText" will eat all the text.

## The recursive call must be at the end of the expression

Inside the complex parts of the definition of "Text" we use "Text" itself, thereby creating a recursive
definition. Here we must ensure that the recursive call is not the first one. If we turned it around and
put "Text" at the beginning as in this example:

{% include file="examples/parse_text_recursive_first.pl" %}

We would get an exception, even before we have a chance to use the regex.

```
Infinite recursion in regex at parse_text_recursive_first.pl line 26.
```

## Everything must be tokens

You might have noticed that we only used "token"s in this grammar. No "rule" was used. While in many parsing
operations we might want to disregard spaces, here we probably need to keep the spaces between the structure
as we will need them when we want to put the text back together in some other format. So every declaration
is a "rule".


