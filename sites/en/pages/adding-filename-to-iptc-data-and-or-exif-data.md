---
title: "Adding filename to IPTC data and-or exif data"
timestamp: 2007-07-21T00:10:33
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2007-07-21 00:10:33-07 by timflang

Dear everyone

I have recently come across exiftool so I am new to the way it works.
I have 5,000 photographs which all have long file names descirbing what
they show and when they were taken (100-200 characters is common for a filename in this case).

I've recently signed up to a photo sharing site and they take the photo caption
from one of the meta data fields. Therefore I would like to place the filename into
IPTC metadata and-or the EXIF data. I've still to work out which field
I will use as it will depend on what the photo sharing site reads.

To do this, do I simple use the -FILENAME tag to copy the filename or do
I need to tell the IPTC-EXIF tag that it = filename.

E.g.

```
exiftool -FILENAME>IPTC:[field that is chosen]
```

or is it

```
exiftool -IPTC:[field that is chosen]=FILENAME
```

When writing the new information, does the program modify any of the creation
and/or modification dates on the file attributes? I would be writing to the
original files as I have back ups of all my work, via a nightly
back up system that I run should anything go wrong. I will of course be running tests first.

Thank you for all your help in advance.

Tim

Posted on 2007-07-21 07:04:58-07 by bogdan in response to 5784

You can do that by typing:

```
exiftool "-iptc:caption-abstract<filename" *.jpg
```

-this will set filename into iptc on all jpg files in working directory.

Greetings,
Bogdan
Direct Responses: 5786 | Write a response
Posted on 2007-07-21 10:26:46-07 by timflang in response to 5785
Re: Adding filename to IPTC data and-or exif data
Bogdan

Thank you for your reply. I would never have got that, not without hours of studying
of the help file which I have printed out and been reading.
It gets quite complicated at times which is understable, given what the program offers.

What character does &l stand for (assuming it is a character)?

Is it possible to tell the program to work through all subdirectories?

Regards

Tim

Posted on 2007-07-21 10:54:01-07 by bogdan in response to 5786

Hi Tim,

Indeed, there's nothing ExifTool can't do (in one or another way) :-)

You've probably copy/pasted the example I wrote...
This forum doesn't allow directly writting < character (so & +lt is used -as "less than").

Working on subdirectories... I believe you can use:

exiftool "-iptc:caption-abstract<filename" *

-that is: you use only single asterisk (but you can't filter out jpg only in this case).
Anyway, give big try/check before you apply above on your master files.
I believe, there's also "official" command for work with subdirectories...
which I can't recall right now.

Bogdan

Posted on 2007-07-21 11:50:30-07 by exiftool in response to 5787

Hi Tim,

The command is:

```
exiftool "-iptc:caption-abstract<filename" -r DIR
```

(Bogdan's "&lt" should have had a semicolon after it to show up as a "<" symbol.)

DIR is a directory name, and the -r option causes all subdirectories to be processed as well.

- Phil

Posted on 2007-07-21 12:31:35-07 by bogdan in response to 5788

Hi again,

About "less than" character I've used... does it mean you don't see it in your browser?
I mean, is there a difference you see for: "<" and "<"? -because I see both equal (in IE7).

Bogdan

Posted on 2007-07-21 18:25:03-07 by timflang in response to 5787

Hi Bogdan

Thank you for your further comments. The command makes much more sense now.
I tried a test and it worked in most cases. However whenever it came across a
German special letter such as an a (ae), o (oe), or u (ue) I.E. with umlauts,
it came up with an error message, stopped copying the title and moved on to the next file.
The error is Warning: Malformed UTF-8 characters(s) followed by the filename,
which when it comes to the special letter, has a different character shown.
Could that be due to the font that windows XP dos uses?
The filenames appear correctly in windows explorer, even the original copy and
the half updated new file. It was only by chance that my test included a folder
with special German letters.

As I have taken photos in Austrian towns where such letters are used,
I need to include the letters in my filenames-captions. I could use oe but
I think it's a lazy way of typing and I find it harder to read names spelt that way.

If I outputted the complete list of errors to a text file, I could then
manually amend the files using a program called Exifer. However there must be a way
of doing this automatically and I don't have time to keep amending the titles in
Exifer, every time a problem occurs.

Although I've not been able to view the TIFF ITPC info in Exifer and XnView,
it appears that something has been written to it. Apart from the issues above
all the other files worked perfectly. Very powerful program that could be run
over night. It also ignored without error any files which were not in the right format,
such as TXT and AVI files. That was good as I have those scattered across my photo folders.

Kind regards

Timothy Langner

Posted on 2007-07-21 21:59:17-07 by exiftool in response to 5791

ExifTool expects special characters in UTF8 unless otherwise specified.
Your filename characters are likely Windows Latin1, and if
so adding a -L option to the command will solve the problem.
With -L, exiftool assumes the input text is in Windows Latin1.

Bogdan: Both of your last <'s worked, however earlier ones in the command
appeared as "&lt" for some reason.

- Phil

Posted on 2007-07-21 22:55:08-07 by timflang in response to 5792

Phil

Thank you for your prompt replies, very helpful.
It saved me having to look it up UTF-8 on the Internet.
I'm going to do another test and if it works
I'm going to run the program over night.
I've got all my photos backed up using a nightly back up system
so I can easily undo any any major problems.

Regards

Tim


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/5784 -->

