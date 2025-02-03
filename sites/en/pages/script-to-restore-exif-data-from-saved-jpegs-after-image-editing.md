---
title: "Script to restore EXIF data from saved JPEGs (After image editing)"
timestamp: 2007-05-22T04:15:23
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2007-05-22 04:15:23-07 by morganglines

Is there a stock script for backup / restore of EXIF data to files you'd be willing to share?
I'm particularly curious about doing this via bash at the moment.
I think I've got the backup part -- in DOS this seems to work:

```
for %f in (*.cr2) do if not exist %~nf.jpg exiftool -b -PreviewImage -w .thumb %f
for %f in (*.thumb) do if exist %~nf.cr2 exiftool -b -AllTagsFromFile %~nf.cr2 -o %~nf.jpg %f
```

and in BASH:

```
exiftool -if '$jpgfromraw' -b -jpgfromraw -w %d%f.jpg -execute -if '$previewimage' -b -previewimage
    -w %d%f.jpg -execute -tagsfromfile @ -srcfile %d%f.jpg -overwrite_original -common_args --ext jpg
    --ext xmp FolderNameHere
```

But restoring from the backed up JPEGs to edited JPEGs to over-write the mangled EXIF is eluding me.
I did try Google and am surprised that I don't find instructions for backup / restore using EXIFtool.
I've had pretty good results using a program called EXIFer but EXIFTool seems to support more tags.
Any examples of backing up EXIF data for all files in a folder then restoring, particularly in
BASH that you might share?

Thank you in advance,

-mg

Posted on 2007-05-22 12:01:39-07 by exiftool in response to 5194

By "restore EXIF" I assume you mean "copy all meta information from one image to another", right?
If so, you don't need a script to do this. A single exiftool command will do, but the exact
command depends on where the files are located and what their names are.
In your example, you're extracting JPEG images from RAW files and copying the meta information
from the RAW to the JPEG. Then you say that your image editor is mangling the EXIF of the JPEG.
Why not just re-copy the information from the original RAW image using this?:

```
exiftool -tagsfromfile %d%f.cr2 -ext jpg FolderNameHere
```

- Phil

Posted on 2007-05-23 02:56:27-07 by morganglines in response to 5199

Thanks! Not only does that do the trick, it also saves me two steps and exporting
the JPEGs altogether! -mg

Posted on 2007-05-29 10:03:31-07 by birdman in response to 5199

Dear Phil, I have about the same problem: I would like to copy the whole original
Exif-Information in one directory from my raw-files (.pef) to my jpg-files.
The exiftool -tagsfromfile %d%f.cr2 -ext jpg FolderNameHere probably should work in some way there too?
But I do have a problem modifying it since I am using the Windows stand alone version of
Exiftool where I need to mask some of the syntax, is that correct? Could you give
me a hint how to write it correctly? Thanks a lot, Birdman

Posted on 2007-05-29 11:42:45-07 by exiftool in response to 5248

I'm not on a windows box right now, so I can't test this out, but something like
this should work for you (from the command line):

```
exiftool -tagsfromfile "PEFFolderName\%f.pef" -ext jpg JPEGFolderName
```

I'm not sure if the quotes are necessary in Windows, but they couldn't hurt.

- Phil

Posted on 2007-05-29 12:34:27-07 by birdman in response to 5250

Dear Phil, I tried it without the foldernames since I am processing the
cmd-batch in the folder where the files are in the following way:

```
exiftool -tagsfromfile "%f.pef" -ext jpg
```

It only says "no file specified" and nothing happens.
I also tried it with a double % [%%f.pef] but this won't help either.

Posted on 2007-05-29 12:46:26-07 by exiftool in response to 5252

Hi Birdman,

Use "." to specify the current directory:

```
exiftool -tagsfromfile "%f.pef" -ext jpg .
```

This command should work if both the pef and the jpg are in the current directory.

The double '%' is only necessary for commands inside Windows .bat files.

- Phil

Posted on 2007-05-29 13:57:42-07 by birdman in response to 5253

Hi Phil, Thanks a lot, the "." really did it. As you stated I also had to add a second "%"
since I am working with a Windows CMD-batchfile. The only thing that I am wondering about:
the modified jpg-files all now have XMD-information as well eventhough the pef-files did not.
Any idea? Birdman

Posted on 2007-05-29 14:24:16-07 by exiftool in response to 5254

Hi Birdman,

This is all in the documentation, but I admit there is a fair bit of reading
to do before you discover details like this:

When copying information, if no group is specified then ExifTool will "commute"
the information to its preferred group. This is necessary when copying between
images which don't support the same type (group) of meta information (ie. CRW -> JPEG),
but isn't strictly required for PEF -> JPEG because PEF is TIFF format and
JPEG images support TIFF information.

So the answer is that for PEF -> JPEG you can keep the information in the same group
(and prevent creating XMP and IPTC if it didn't previously exist) by specifying a
group name for copied information. Even the special "all" group name will cause the
group to be preserved:

```
exiftool -tagsfromfile "%f.pef" -all:all -ext jpg .
```

- Phil

Posted on 2007-05-29 15:05:47-07 by birdman in response to 5255

Dear Phil, You are right, I really overlocked that.
But your suggestion did it, thanks a lot again. Great on-time support!!! Birdman

Posted on 2007-06-02 04:48:10-07 by morganglines in response to 5248

Ah, I remember why I'd been doing it this way -- with my older cameras there's no CR2 --
they just write out JPEGs directly so I'd been trying to back up the exif data without
backing up the whole JPEG image.

Is it possible to restore from an HTML dump?

```
exiftool -htmldump -w ./EXIFBackup/%f%e.htm .
```

works fine for backup too but it seems to stop on restore.
I know this must be something I'm doing . . . or not doing . . . :-D Or is there a way to
(would it be easier to) pipe the output of exiftool -s to a set of text files and then
pipe the text files' contents back into the jpegs?

Posted on 2007-06-03 23:57:11-07 by exiftool in response to 5301

Exiftool doesn't read plain text files or information from the body of an html file
(it only reads the html meta information).

I suggest using MIE format to store the JPEG meta information:

```
exiftool -o ExifBackup/%f%e.mie .
```

- Phil

Posted on 2007-06-08 02:59:12-07 by morganglines in response to 5304

1. You rock - thank you very much. :-)

and

2. I'm not sure if it will help, but here are my scripts if they save anyone time.

In BASH for backup:

```
#!/bin/bash
echo "Hello, $USER.  A new folder will be created to back up EXIF info."
Mkdir ./ExifBackup

exiftool -o ./ExifBackup/%f.mie -ext cr2 .
exiftool -o ./ExifBackup/%f.mie -ext crw .
exiftool -o ./ExifBackup/%f.mie -ext pef .
exiftool -o ./ExifBackup/%f.mie -ext tif .
exiftool -o ./ExifBackup/%f.mie -ext jpg .
```

Pictures are then edited . . . I know the imaging programs shouldn't mess with
the raw files anyway (at least not in this generation of image editors),
but I try to be consistent since a couple of my older cameras only shoot JPEGs.

In BASH for restore:

```
#!/bin/bash
echo "Hello, $USER.  Restoring EXIF."
exiftool -s *.jpg>0exifinfoprerestore.txt
exiftool -overwrite_original -tagsfromfile ./ExifBackup/%f.mie -ext jpg .
exiftool -overwrite_original -keywords+='YourStandardKeyword1Here' -keywords+='YourStandardKeyword2
+Here' *.jpg
echo "All done . . ."
```

In Windows XP for Backup:


```
exiftool -o ExifBackup/%%f.mie -ext cr2 .
exiftool -o ExifBackup/%%f.mie -ext crw .
exiftool -o ExifBackup/%%f.mie -ext pef .
exiftool -o ExifBackup/%%f.mie -ext jpg .
exiftool -s *.jpg >ExifBackup/JPEGsPreBackup.wri
exiftool -s *.cr2 >ExifBackup/CR2PreBackup.wri
exiftool -s *.crw >ExifBackup/CRWPreBackup.wri
exit
```

In Windows XP for Restore:

```
exiftool -s *.jpg >ExifBackup/JPEGsPreRestore.wri
exiftool -overwrite_original -tagsfromfile %%d/ExifBackup/%%f.mie -ext jpg .
exiftool -overwrite_original -keywords+="KeywordHere" -Software= *.jpg
```

Hope this saves someone else some time (or perhaps makes it easier to write a better
set of scripts based on your own needs). Thank you again - this is an awesome tool. -mg

Posted on 2007-06-08 11:22:29-07 by exiftool in response to 5358

Hi Bogdan,

Thanks for posting these. Just one suggestion:

These commands:

```
exiftool -o ./ExifBackup/%f.mie -ext cr2 .
exiftool -o ./ExifBackup/%f.mie -ext crw .
exiftool -o ./ExifBackup/%f.mie -ext pef .
exiftool -o ./ExifBackup/%f.mie -ext tif .
exiftool -o ./ExifBackup/%f.mie -ext jpg .
```

Can all be replaced with a single command:

```
exiftool -o ./ExifBackup/%f.mie -ext cr2 -ext crw -ext pef -ext tif -ext jpg .
```

- Phil

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/5194 -->


