---
title: "Extra information in Canon EOS 350 .CR2 after using Digital Photo Professional"
timestamp: 2005-09-27T16:03:36
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2005-09-27 16:03:36-07 by minimal

Hi,
I've been experimenting with IPTC additions (under OS X) to Canon EOS 350D
(aka: Digital Rebel XT) RAW files (.CR2 and it's all very simple: thanks !) and it looks like
the Canon supplied RAW tweaking software Digital Photo Professional 1.6.1 (DPP) creates extra data
that ExifTool can't understand and so removes when writing back to the edited RAW file.

For those without the software, DPP allows colour alterations using curves as
well as other histogram based alterations, cropping, simple dust retouching and the like,
but it does this non-destructively on the RAW file by applying what Canon term
a 'Recipe' to the .CR2 file. DPP computes a changed preview thumbnail for viewing within
the main app browser window but applies the steps in the recipe to the original
file before allowing more edits. The changes can then be applied in batch elsewhere,
but again all changes are non-destructive with respect to the original data.

If I add an IPTC tag before retouching, then everything is fine.
If I retouch and then add a tag, DPP looses the changes and thinks the file is fresh from the camera.
A quick glance at the file sizes shows that a far chunk of information (500KB or so)
has been removed in this process, but DPP still understands the file and nothing crashes.

This makes me think that the extra information applied by DPP is done so in a sane fashion
that is correctly tagged in terms of size etc., but what are the next steps I can take
in order to find out the essential header data to allow ExitTool to leave the DPP block intact ?

I'm pretty happy at the command line and perl doesn't scare me (although my code may scare others !)
but if anyone has some pointers for how to go about investigating this then I'd be most grateful.
If others wish to look then I can provide any number of example images
(but they are all aorund 8MB in size).
TTFN,
--
Ian Spray

Posted on 2005-09-27 16:32:22-07 by exiftool in response to 1055

Ouch! You're right!
I happen to have DPP here so I just tried this out and the editing information is lost as you said.

CR2 is basically a TIFF format, and ExifTool will copy over any information even
if it doesn't recognize it, as long as it is properly referenced in a TIFF image file directory (IFD).

Unfortunately, this extra information is not referenced directly from any TIFF IFD (bad Canon!),
so it is not copied to the new file. I will do some more investigating to see if I can figure
out how this extra information is referenced.

Posted on 2005-09-27 18:21:59-07 by exiftool in response to 1056

I now understand what DPP is doing. It is simply appending a block of data to the end
of the file without otherwise modifying the file at all.
This makes a certain amount of sense, and explains why the data isn't referenced from within the
TIFF structure. But this is a bit of a pain to say the least because TIFF is not a sequential format,
so it is not as easy as just copying everything after then end of the TIFF image because
you can't easily tell where the TIFF image ends.
I'll keep working on it and hopefully I can come up with a solution, but it may take a few days.

Posted on 2005-09-27 19:43:21-07 by minimal in response to 1058

Hmm, like you say it sort of makes sense, at least as far as image integrity goes but it's hardly friendly.
Thanks for taking the time to have a look at it: I expect you'll get there faster than I would !
Recipe's can also be saved out as stand-alone files from DPP, so I'll have a look to see
if the data is the same in each case, and then try to see if there's anything helpfully
unique about the block that you might be able to use.
--
Ian

Posted on 2005-09-27 20:03:36-07 by exiftool in response to 1059

The block begins with the character sequence "CANON OPTIONAL DATA".
However, this is of limited use because it would slow things down too much to search for this string.

However, I think I may have found a solution which doesn't slow things down too much.
I have added some code to keep track of the last data block read from the TIFF, and simply
copy anything found after this to the new file. I don't like polluting my general
TIFF writer code to copy this non-TIFF information, but it seemed to be the simplest way.

I have modified the 5.64 pre-release version with this change (OK, so I was a bit quicker than I thought),
and if you want to test it out you can download it from
http://owl.phy.queensu.ca/~phil/exiftool/Image-ExifTool-5.64.tar.gz.
I still want to do more testing to be sure this is doing what I want before
I release this version officially.

Posted on 2005-09-27 20:13:17-07 by minimal in response to 1059

Just in case this helps: it doesn't appear to be exactly the same data embedded
into the .CR2 as that which can be exported as a stand-alone recipe (a .VRD file),
but it does appear to be wrapped in exactly the same text string, namely:
CANON OPTIONAL DATA

After a check of another couple of hundred untouched files it appears that the camera
never appends this string. Obviously, it's possible that this might come up inside a free-form text tag,
but if it's possible to examine the portion of the file between the last declared block
and the fsize idea of the file length (hmm, showing too much C there: sorry), then looking for
those strings and keeping the data in between ought to be fairly safe. ie: only accept the string
as a block delimiter outside of the TIFF structure.

HTH,
--
Ian.

Posted on 2005-09-27 20:15:20-07 by minimal in response to 1060

Gah - spent so long getting the formatting right our posts overlapped !
Thanks for that very speedy work: I'll try it out and see if I can break it :)
--
Ian.

Posted on 2005-09-28 13:30:19-07 by exiftool in response to 1062

After running some more tests, I managed to break it myself! :P
When running in batch mode (editing a number of pictures at once), the editing information
isn't always copied over for files after the first. I had forgotten to reset a necessary
variable between files. This is now fixed and the pre-release has been updated.

Also, I discovered an 8-byte block of information at the start of the file that wasn't being
referenced from the TIFF IFD either. This block exists in all of my CR2 sample images
(from the 350D, 20D and 1DmkII). It is a small header with a pointer to the IFD containing the
RAW data -- possibly used in camera, but not used by any of any of the Canon utilities or dcraw
as far as I can tell. But just to be safe I also added the code to generate this header
when rewriting a file.
So thanks for pointing out the original problem with the DPP information.
I think we now have a better CR2 writer.
I should be making an official release of version 5.64 within a few days.

Posted on 2005-09-28 13:45:01-07 by minimal in response to 1064

Excellent news! Thanks very much for sorting it all out for me - I hadn't found any of those issues,
but I was trying much simpler stuff (set an option, edit it lots in DPP, check and set another one etc.)
which was mainly trying to find a point where either DPP or ExifTool got upset.

They didn't.

I look forward to the official release, but I'm off to play with this one some more now.
TTFN,
--
Ian.

Posted on 2005-09-28 14:57:58-07 by exiftool in response to 1065

Oops. I had left some debugging code enabled when I did the last update.
I have fixed this and added a CR2 test to the test suite, and updated the pre-release on my web site
Sorry for any inconvenience.

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/3706 -->



