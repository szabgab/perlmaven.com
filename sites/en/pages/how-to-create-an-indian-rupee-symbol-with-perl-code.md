---
title: "How to create an Indian Rupee symbol with Perl code"
timestamp: 2013-03-16T10:30:02
tags:
  - binmode
  - Unicode
  - STDOUT
  - UTF8
published: true
books:
  - beginner
author: szabgab
---


Recently I got an e-mail from one of the readers asking how to create a Indian Rupee symbol with Perl.
I told him to check <b>what is the Unicode character for the Rupee symbol</b> and then to check
<b>how to print Unicode characters with Perl</b>.

As this might be interesting to more people, let me show it here.


The first search led me to the Wikipedia page describing the <a
href="http://en.wikipedia.org/wiki/Indian_rupee_sign">Indian Rupee sign</a>.

Apparently there is a <b>Generic Rupee sign</b> U+20A8 `&#8360;` and a specific <b>Indian Rupee sign</b> U+20B9
`&#8377;`.

If you'd like to print a Unicode character to the screen (standard output or STDOUT), then you need to
tell Perl to change the encoding of the STDOUT channel to UTF8. You can do this with the `binmode`
function. (Check out the [Unicode intro](http://perldoc.perl.org/perluniintro.html) for further details.)

For the specific code points you'd use the `\x` sign and then put the Hexadecimal values, in our case
20A8 and 20B9 respectively in curly braces.

```perl
use strict;
use warnings;
use 5.010;

binmode(STDOUT, ":utf8");

say "\x{20A8}"; # &#8360;
say "\x{20B9}"; # &#8377;
```


Of course if you are creating an HTML page then you'd better include the HTML entity representing the same character
which is an at sign (&) followed by a pound sign (#), followed by the decimal representation of the code point,
followed by a semi-colon. To convert the Hexadecimal values to decimal values you can do the following in perl:

```perl
print 0x20A8, "\n";  # 8360
print 0x20B9, "\n";  # 8377
```

So in HTML you would include `&amp;#8360;` and `&amp;#8377;` respectively.

I have used perl 5.14.2 on Linux to test the above. In older versions of Perl the above might not work.

{% include file="examples/rupee.pl" %}


