---
title: "What is a text file and what is a binary file?"
timestamp: 2013-08-02T19:30:10
tags:
  - ASCII
  - UTF-8
  - Unicode
published: true
books:
  - beginner
author: szabgab
---


If you are not coming from a programming background it might not yet be clear what is really a file?
What is a **binary file** and what makes something a **text file**?

Is a Microsoft Word document a text file or a binary file?

Is an spreadsheet a text file or a binary file?

Let's try to explain this.


A little disclaimer:

There is actually a lot more variation to this, but I'll focus on files of Unix/Linux systems, Windows and Mac.
Wikipedia has some more to say about [text files](http://en.wikipedia.org/wiki/Text_file)
and [binary files](http://en.wikipedia.org/wiki/Binary_files), so if this article does not 
to satisfy your curiosity, then please check out those articles.

## What is a file?

Basically every file is just a series of bytes one after the other. That is, numbers between 0 and 255.
In order to facilitate the storage device they are on, a file might be spread out to several areas on
that device. From our point of view, each file is just a series of bytes.
In general every file is a **binary file**, but if the data in it contains only text (letter, numbers
and other symbols one would use in writing, and if it consists of lines, then we consider it a **text file**.

## What is a text file?

(I am going to simplify here a bit for clarity and for now assume that the files are only use
[ASCII characters](http://en.wikipedia.org/wiki/ASCII).)

When you open a text file with Notepad or some other, simple text editor you will see several lines of text.
The file on the disk on the other hand isn't broken up to such lines. It is a series of numbers
one after the other. When you open the file using Notepad, it translates each number to a visual representation.
For example if it encounters the number 97, it will show the letter **a**. We can say that the
`a character is represented by the number 97 in ASCII`.

The reason that you see several lines in your editor is that some of the bytes in the file,
that are called **newlines**, are actually instructions to the editor to go to the beginning of next line.
Thus the character that was in the file after the **newline character** will be displayed in the next line.

## What is a newline?

Which number represents the newline?

Actually none of the characters in the [ASCII table](http://en.wikipedia.org/wiki/ASCII) is called a **newline**.
When we say **newline** we usually mean **the sign that can convince the computer to go to the beginning of next row**.

There are various sets of bytes that represent a **newline** depending on the operating system.
In the operating systems we care about in this article a **newline** is always represented by a combination
of two characters that in the ASCII table are called `LF - line feed` (hexa 0x0A or decimal 10) and
`CR - carriage return` (hexa 0x0D or decimal 13).

If you have ever seen a [Typewriter](http://en.wikipedia.org/wiki/Typewriter), you will
remember, in order to go to the next line, the user had to pull a handle towards the beginning of
the line. (Usually to the left side of the paper.)
This movement first pushed the "carriage" to the beginning of the paper and when it arrived to the
beginning (and got stuck), further pulling of the handle turning the paper a bit so the
carriage would point to the next line. Then the typewrite was ready for the next line.

That is, they used two operations
**carriage return**, pushing the "carriage" to the beginning of the paper and
**line feed** - going to the next line.

<img src="/img/Underwoodfive.jpg" alt="typewriter" />

(Image from [Wikipedia](http://en.wikipedia.org/wiki/Typewriter))

Therefore on MS Windows, a newline is represented by two characters: `CRLF`.
A `Carriage return` followed by a `line feed`.

On Unix/Linux systems and on Mac OSX, the **newline** is represented by a single
`LF` (`line feed`).

Just for curiosity, Mac OS Classic (before OSX),
Commodore, [ZX Spectrum](http://en.wikipedia.org/wiki/ZX_Spectrum),
[TRS-80](http://en.wikipedia.org/wiki/TRS-80)
all used a `CR` (`Carriage Return`) to represent a **newline**.

(I learned programming on a HT-1080Z which was a TRS-80 clone and later switched
to a ZX Spectrum.)

Wikipedia has even more to say about [newline](http://en.wikipedia.org/wiki/Newline).

So if you have a file filled with [ASCII printable characters](http://en.wikipedia.org/wiki/ASCII)
with a few "newlines" sprinkled in, then you have a **text file**.

## Encoding

Of course if you looked at the [ASCII](http://en.wikipedia.org/wiki/ASCII) table you saw that
only very few languages could be written with those letters. Mostly the Latin based languages.
Many languages that use those characters have a few extra letters.
For example in [Hungarian](http://en.wikipedia.org/wiki/Hungarian_alphabet)
there are a few more vowels: aáeéiíoóöőuúüű. The 5 from Latin and 9 extra. For fun.)
You cannot represent then within the ASCII table.

Therefore people have invented other [Encodings](http://en.wikipedia.org/wiki/Encoding),
besides ASCII. Without going into the details, each encoding is a mapping between numbers that
can be saved in a computer file and "drawings" that should be displayed on the screen.

Remember, even in ASCII, you don't have a letter `a` in a file. You have a decimal number 97
saved that your computer knows to display as the letter `a`. The computer will display the
letter `a` if it thinks that your file is in `ASCII` encoding,
or in any of the ASCII-based or ASCII-compatible encodings,
such as [Latin1](http://en.wikipedia.org/wiki/Latin1)
or [UTF8](http://en.wikipedia.org/wiki/UTF-8).

So in the ancient times people used various encoding to represent their own language,
but these encodings overlapped. The same number was used to represent difference characters (drawings)
in the different languages. That did not allow the mixing of these languages in the same
file and if the application was used the incorrect encoding to display a file, all you got
was a mix of unintelligible list of characters from some other language.

You can still see this problem when a web page is written in one of these ancient-time
encodings, but the browser uses a different encoding to show it. The solution would be
to include a hint about the encoding in the HTML page, but at times people forget to do this.

The other good solution is to use [UTF-8](http://en.wikipedia.org/wiki/UTF-8) encoding
as this encoding maps out **all** the characters in the known universe. Unfortunately
[Klingon](https://en.wikipedia.org/wiki/Klingon_writing_systems) is not yet included.

[UTF-8](http://en.wikipedia.org/wiki/UTF-8) is one of good ways to
map [Unicode](https://en.wikipedia.org/wiki/Unicode) characters to numbers.
As Unicode currently includes more than 110,000 characters it cannot be represented in one byte
which can hold only numbers between 0 and 255. So in UTF-8, every character is represented by 1 to 4
bytes. If you open a file that was written using the UTF-8 encoding, with a tool
that can only handle ASCII characters, you will see lots of "garbage". That's because in UTF-8
some of the characters are represented by numbers that are "control characters" in ASCII.

So to the casual viewer, the file would be indistinguishable from a **binary file**.

## Binary file

A binary file is basically any file that is not "line-oriented". Any file where besides the
actual written characters and newlines there are other symbols as well.

So a program written in the C programming language is a text file, but after you compiled it, the
compiled version is binary.

A Perl program is a text file, but if you package it with
[PAR::Packer](https://metacpan.org/pod/PAR::Packer) it will be a binary file.

A Microsoft word file is a binary file as besides the actual text, it also contains various
characters representing font size and color.

An [Open Office Write](https://en.wikipedia.org/wiki/OpenOffice) file is binary
as it is a zipped set of XML files, but the XML files inside are considered text files.
Even though they contain both text and characters that represent font-size and color.

An HTML file, is a text file too, even though it contains lots of characters that are
invisible when viewed in a browser. It is considered a text file even though a newline,
as described above, won't cause the next character to be displayed on the next line
when viewed through a browsers.
It is considered a text file, because all the "control characters" are themselves
"printable characters", when viewed in a regular text editor.


## Comments
"When we say newline we usually mean the sign that can convince the computer to go to the beginning of next row." I'd say that newline means new line, not new line AND beginning of next row.
## 

Super explanation

