---
title: "Here documents, or how to create multi-line strings in Perl"
timestamp: 2013-06-30T08:01:01
tags:
  - <<
  - /m
  - /g
  - q
  - qq
published: true
books:
  - beginner
author: szabgab
---


Once in a while you need to create a string that spreads on several lines.
As usual in Perl, there are several solutions for this.
Using a here-document is one of the common solutions.


A <b>here-document</b> allows you to create a string that spreads on <b>multiple lines</b> and preserves
white spaces and new-lines. If you run the following code it will print exactly what you see
starting from the word Dear till the line before the second appearance of END_MESSAGE.

## Non-interpolating here document

{% include file="examples/non_interpolating_here_document.pl" %}

Output:

```
Dear $name,

this is a message I plan to send to you.

regards
  the Perl Maven
```

The here document starts with two less-than characters `&lt;&lt;` followed by and arbitrary string that becomes
the designated end-mark of the here-document, followed by the semi-colon `;` marking the end of the statement.
This is a bit strange as the statement does not really end here. Actually the content of the here document
just starts on the line after the semi-colon, (in our case with the word "Dear"), and continues till Perl finds the
arbitrarily selected end-mark. In our case the string <b>END_MESSAGE</b>.

If you have already seen here-documents in code, you are probably surprised by the single-quotes around the first
<b>END_MESSAGE</b>. I think if you find examples of here-documents on the Internet, or behind the corporate firewalls,
you'll probably see the opening part without any quotes around it. Like this:

{% include file="examples/non_interpolating_here_document_default.pl" %}

It works and it behaves the same as if you put double-quotes around the END_MESSAGE like in the next example,
but it is less clear. I'd recommend you do not use here-document without quotes around the definition of the end-string.

{% include file="examples/non_interpolating_here_document_double_quotes.pl" %}

If you already know the
[difference between single-quotes and double-quotes](/quoted-interpolated-and-escaped-strings-in-perl)
in Perl, then you won't be surprised that the here-documents have the exact same behavior.
The only difference is, that the quotes are
around the end-mark and not the actual string. If no quotes are provided, Perl defaults to double-quotes.

If you look back to the first example, you will notice we had `$name` part of the here-document
and it also remained part of the output. That's because Perl did not try to fill the place
with the content of the `$name` variable. (We did not even have to declare that variable in the
code. You can try the script, even without the `my $name = 'Foo';` part.)

## Interpolating here document

In the next example we use double quotes around the end-mark and thus it will interpolate
the `$name` variable:

{% include file="examples/interpolating_here_document.pl" %}

The result of running this script is:

```
Hello Foo,

how are you?
```

## Warning: exact end-string at the end

Maybe just a note. You have to make sure the end-string is duplicated at the end of the string
<b>exactly</b> as it was at the beginning. No white-spaces before, and no white spaces after.
Otherwise Perl will not recognize it and will think the here-documents have not ended yet.
That means you cannot indent the end tag to match the indentation of the rest of your code.
Or can you?

## Here documents and code indentation

If the here document needs to be in a place where we'd normally indent
code, we have two problems:


{% include file="examples/here_document_with_indentation.pl" %}

One is that as I mentioned above, the end string must be exactly the same both at its
declaration and at the end of the string, so you cannot indent it at the end.

The other problem is that the output will have all those leading whites-spaces in every line:

```
        Dear Foo,

        this is a message I plan to send to you.

        regards
          the Perl Maven
```

The lack of indentation of the end-mark can be solved by using one that already
includes enough leading white-spaces: (I am using 4 real spaces here, as the tabs don't
work well in the article, but they could work in real code. If you are in the indent-by-tab
camp.)

{% include file="examples/here_document_indent.pl" %}

The extra indentation of the actual text can be removed using a substitution at the assignment.

{% include file="examples/here_document_remove_indent.pl" %}

In the substitution we replace 8 leading spaces by the empty string. We use two modifiers:
`/m` changes the behavior of `^` from matching at the <b>beginning of the string</b>
to match at the <b>beginning of line</b>.  `/g` tells the substitution to work <b>globally</b>,
that is to repeat the substitution as many times as it can.

Together these two flag will get the substitution to remove 8 leading spaces from every line in the
variable on the left-hand side of `=~`.
On the left-hand side we had to put the assignment in parentheses because the precedence of the
assignment operator (`=`) is lower than the precedence of the regex `=~`. Without
the parentheses, perl would first try to run the regex substitution on the here-document itself
resulting in a compile-time error:

Can't modify scalar in substitution (s///) at programming.pl line 9, near "s/^ {8}//gm;"

## Using q or qq instead

With all this explanation, actually I am not sure if I should really recommend using here-documents.
In many cases, instead of here-documents, I use either the `qq` or the `q` operator.
Depending if I want interpolating, or non-interpolating strings:

{% include file="examples/using_q_or_qq.pl" %}

## Comments

Hello,

I think it is worth noting that if you use "qq" operator like in your example, you end up with
newline character in the beginning of the string in $message.
To avoid this you should start your message text in the same line as qq operator.
Regards,
Zymuar

<hr>

I have a multi-line here-text that (in UltraEdit) contains line breaks coded as \r\n. However, when I subsequently print it out to a file, the \r's seem to have been dropped and only the \n's remain. Is there a way to change that behaviour?

---
have you tried using q or qq instead?
---
No I didn't. However, I added a

$here_doc=~ s/\n/\r\n/g;

to the code right after the $here_doc definition. That also did the trick, although probably not standard business practice, but at least I see what's happening. Regards, Mario

<hr>
In the 'non-interpolating' section you have two examples that do do interpolation.
The label on those two still says 'non-interpolation'!
<hr>
One benefit I can see with using here-documents versus qq.

If I'm trying to put some javascript into a string, it is very common to find square braces, curly braces, pipes, and any other single character I might want to use as a delimiter all contained within that string.

here-documents completely avoid that issue, as I can choose an arbitrary end-sequence, which will never appear within the script block.
---
I use $whatever = qq~ whatever~; The tilde is very rare within a string.

<hr>

Time to update and refer `<<~` :-)

<hr>
You didn't mention the way I like to do it :( I like to use double quotes with the newline character and the concatenation operator. It's a bit verbose, but quite explicit.

---
I do it like:

use constant bs => '\\'; # backslash
use constant bt => '`'; # backtick
use constant dq => '"'; # double-quote
use constant nl => "\n"; # newline
use constant nlx2 => "\n" x 2; # 2 newlines
use constant sq => "'"; # single quote
use constant tab => "\t"; # tab
use constant tabx2 => "\t" x 2; # 2 tabs
use constant tabx3 => "\t" x 3; # 3 tabs
use constant tabx4 => "\t" x 4; # 4 tabs
use constant tabx5 => "\t" x 5; # 5 tabs

print 'Manage partitions' . nlx2
. tab . '--help' . tabx4 . 'Basic usage.' . nl
. tab . '--full-help' . tabx3 . 'More detailed help.' . nl
. tab . '--future-help' . tabx3 . 'Unimplemented features...' . nl
;


<hr>

I love the surprise ending!

"Heredocs, here's how they work, bla bla, ..."

and then, at the end:

"I am not sure if I should really recommend using here-documents. ... instead of here-documents, I use either the qq or the q operator"

That's a great plot twist. And a useful page, so thanks.


