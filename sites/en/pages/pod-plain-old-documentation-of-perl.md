---
title: "POD - Plain Old Documentation"
timestamp: 2013-03-02T18:40:59
tags:
  - POD
  - perldoc
  - =head1
  - =cut
  - =pod
  - =head2
  - documentation
  - pod2html
  - pod2pdf
published: true
books:
  - beginner
author: szabgab
---


Programmers usually dislike writing documentation. Part of the reason
is that programs are plain text files, but in many cases developers
are required to write documentation in some word processor.

That requires learning the word processor and investing a lot of energy in
trying to make the document "look good" instead of "having good content".

That's not the case with Perl. Normally you would write the
documentation of your modules right in the source code and rely
on external tool to format it to look good.


In this episode of the [Perl tutorials](/perl-tutorial)
we are going to see the <b>POD - Plain Old Documentation</b> which is
the mark-up language used by perl developers.

As simple piece of perl code with POD looks like this:

{% include file="examples/script.pl" %}

If you save this as `script.pl` and run it using `perl script.pl`,
perl will disregard anything between the `=pod` and the `=cut` lines.
It will only execute the actual code.

On the other hand, if you type in `perldoc script.pl`, the <b>perldoc</b> command
will disregard all the code. It will fetch the lines between `=pod` and `=cut`,
format them according to certain rules, and display them on the screen.

These rules depend on your operating system, but they are exactly the same as
you saw when we learned about the
[standard documentation of Perl](/core-perl-documentation-cpan-module-documentation).

The added value of using the embedded POD is that your code will never be supplied
without documentation by accident, as it is inside the modules and the scripts.
You can also reuse the tools and infrastructure the Open Source Perl community
built for itself. Even for your in-house purposes.

## Too simple?

The assumption is that if you remove most of the obstacles from writing
documentation then more people will write documentation. Instead of learning
how to use a word processor to create nice looking documents, you just
type in some text with a few extra symbols and you can get a reasonably
looking document. (Check out the documents on [Meta CPAN](http://metacpan.org/)
to see nicely formatted version of PODs.)

## The markup language

Detailed description of the [POD markup language](http://perldoc.perl.org/perlpod.html)
can be found by typing in [perldoc perlpod](http://perldoc.perl.org/perlpod.html) but
it is very simple.

There are a few tags such as `=head1` and `=head2`
to mark "very important" and "somewhat less important" headers.
There is `=over` to provide indentation and `=item`
to allow the creation of bullet points, and there are a few more.

There is `=cut` to mark the end of a POD section and
`=pod` to start one. Though this starting one isn't strictly required.

Any string that starts with an equal sign `=` as the first character in a row will
be interpreted as a POD markup, and will start a POD section closed by `=cut`

POD even allows the embedding of hyper-links using the L&lt;some-link&gt; notation.

Text between the markup parts will be shown as paragraphs of plain text.

If the text does not start on the first character of the row, it will be taken verbatim,
meaning they will look exactly as you typed them: long lines will stay
long lines and short lines will remain short. This is used for code examples.

An important thing to remember is that POD requires empty rows around the tags.
So

```perl
=head1 Title
=head2 Subtitle
Some Text
=cut
```

won't do what you are expecting.

## The look

As POD is a mark-up language it does not by itself define how things will be displayed.
Using an `=head1` indicates something important, `=head2` means something less important.

The tool that is used to display the POD will usually use bigger characters to display the
text of a head1 than that of a head2 which in turn will be displayed using bigger fonts than the regular
text. The control is in the hands of the display tool.

The `perldoc` command that comes with perl displays the POD as a man-page. It is quite useful on Linux.
Not so good on Windows.

The [Pod::Html](https://metacpan.org/pod/Pod::Html) module provides another command line tool called
`pod2html`. This can convert a POD to an HTML document you can view in a browser.

There are additional tools to generate pdf or mobi files from POD.

## Who is the audience?

After seeing the technique, let's see who is the audience?

Comments (the thing that start with a # ) are explanations for
the maintenance programmer. The person who needs to add features
or fix bugs.

Documentation written in POD is for the users. People who should not
look at the source code. In case of an application those will be
so called "end users". That's anyone.

In case of Perl modules, the users are other Perl programmers who need
to build applications or other modules. They still should not
need to look at your source code. They should be able to use
your module just by reading the documentation via the
`perldoc` command.


## Conclusion

Writing documentation and making it look nice is not that hard in Perl.


## Comments

Probably cannot be stressed too much that perlpod lines must start with = as the first character - not even a space is allowed. I tried to copy and paste the example above: example\script.pl, only to be frustrated for a couple minutes, since the clipboard buffer added about 4 space characters to every line of text. Thus,

  =head1 DESCRIPTION

  became

  =head1 DESCRIPTION

My clue that something was wrong was that all the text was the same color as the rest of the code, and the words, "and" "print" and "given" were in slightly bold text. When I finally backspaced the "=" all the way to the left side, all the pod instantly greyed out.

Thanks for the tutorials!


