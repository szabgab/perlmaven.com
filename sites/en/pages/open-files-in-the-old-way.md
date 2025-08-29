---
title: "Don't Open Files in the old way"
timestamp: 2013-03-21T00:45:17
tags:
  - open
published: true
books:
  - beginner
author: szabgab
---


Earlier in the [Perl Tutorial](/perl-tutorial)
we saw how to open a file for reading or writing.
Unfortunately, when you search the web, or when you look at code
in corporations you will see some slightly different syntax.

Let's see what is that, what is the problem with that and why to avoid?


## So what shall I do?

Before explaining what you should **not** do, let me link you to the articles explain what you should do:

Read [how to open file for reading in a modern way](/open-and-read-from-files)
or the one about [writing to file in Perl](/writing-to-files-with-perl).

## The danger

Coming up with examples why using the old-style open is generally a bad idea, let me point you
to the article explaining [how to break in a Transcend WiFi SD Cards](http://haxit.blogspot.com.es/2013/08/hacking-transcend-wifi-sd-cards.html).
There are many programming mistakes exploited in that article, using old-style open is just one of them,
but there is no good reason to keep using the old way.


Now let's get back to the old, and not-so-good-any-more practices.

## The old and not recommended way

Until perl 5.6 came out - that's until 2000 - we used to write code
like this to open a file for writing:

```perl
open OUT, ">$filename" or die ...;
```

and code like this for reading:

```perl
open IN, $filename or die ...;
```

The "or die" part was the same as we do today, not fully spelled out here.

As you can see `open` got two parameters. The first is a set
of (usually upper-case) letters. That's the thing that will get the
filehandle. The second is the combined opening mode and the path to
the file that needs to be opened.

That is, in the first case you see the greater-than sign meaning we
are opening the file for writing, but in the second example we used to
omit the opening mode. That's because `open()` defaults to reading.

There are two big differences:

## Filehandle glob

The first is that we use the strange variable without the
leading `$` to hold the filehandle.
(This is actually a **bareword**, but one that does not trigger
the [Bareword not allowed while "strict subs" in use](/barewords-in-perl)
error.)

It works as it worked in the early days of Perl, but there are several problems with it:

It is global to all the script you write so if anyone
uses the same name (IN or OUT in our example) those
will clash with yours.

It is also harder to pass these variables to functions,
than to do the same with regular scalar variables.

## 2 parameter open

The second difference is the fact that in these examples `open` got only two parameters.

What if the variable `$filename`, that you are using to open
a file for reading, contains >/etc/passwd ?

Oops.

The `open IN, $filename` will actually open that file for writing.

You just deleted the password file of your Linux operating system.

Not good.

## Need to close that filehandle

Another advantage of using **lexically scoped scalar variables**
as filehandles is that they will automatically be closed when
they go out of scope.

## How to avoid these problems?

It's better to avoid both of these practices and use the "new",
(available since 2000 !) <a href="/open-and-read-from-files">3-parameter open
with scalar lexical variable</a> for storing the filehandle.

There are even policies in [Perl::Critic](http://www.perlcritic.com/)
that will help you analyze the code and locate every place where someone has used either
of the above forms.

## Good and Bad for reading

Bad:

```perl
open IN, $filename or die ...;
```

Good:

```perl
open my $in, '<', $filename or die ...;
```

## Good and Bad for writing

Bad:

```perl
open IN, ">$filename" or die ...;
```

Good:

```perl
open my $in, '>', $filename or die ...;
```

## So what is it about 3-argument open that protects you from overwriting /etc/passwd?

If we accept a filename from the user, and then we try to open it for writing, without checking
the name of the file, then the 3-argument open won't help. (though I really hope you don't run
your scripts as root and thus you will "only" overwrite files owned by a less privileged the user)

OTOH if you are opening a file for reading then this is what can happen:

```perl
my $filename = get_filename_from_user();

open my $in, '<', $filename;

open IN, $filename;
```

If `get_filename_from_user` return `&gt;/etc/passwd` then the first call to `open` would fail, as it 
cannot find a file called `&gt;/etc/passwd`, on the other hand, the second call to `open` will happily open
`/etc/passwd` for writing.


