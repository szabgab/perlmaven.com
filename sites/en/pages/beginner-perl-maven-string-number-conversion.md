---
title: "String to number conversion - video"
timestamp: 2015-03-05T07:03:06
tags:
  - string
  - number
types:
  - screencast
published: true
books:
  - beginner_video
author: szabgab
---


Perl does not care if you write something as a string or as a number. It converts between the two
automatically based on the context.


The number to string conversion is very simple. Just imagining that there are quotation marks around the value you write
on the paper.

The string to number conversion is also straight forward as long as the whole string can be interpreted as a number.
It is just imagining that there are no quotation marks around the number.

The only slightly complex and sometime surprising screnario is, when the string has some part that can be considered as
a number and other parts that cannot be. For example the string `"12.34xyz67"`. When Perl converts this to a number
it sterst from the left side of the string and takes in account all the characters up till the first character that does
not fit in the "picture of a number". This part will be the numerical value. The rest will be disregarded.

In the above case that means the numericla value is `12.34`.

{% youtube id="tYwlgLXsWVg" file="beginner-perl/string-number-conversion" %}

See also the article about [automatic string to number conversion](/automatic-value-conversion-or-casting-in-perl).

