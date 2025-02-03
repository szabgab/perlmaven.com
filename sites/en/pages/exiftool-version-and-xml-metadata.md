---
title: "ExifTool versions and xmp metadata"
timestamp: 2007-05-19T14:08:33
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2007-05-19 14:08:33-07 by bogdan

Hi Phil,

I have jpg file, where (some time ago) I've set:

```
-xmp:city="somename" my.jpg
```

Now I've set xmp:city="newname" (using ExifTool v6.90) and after doing that and executing:

```
exiftool -a -xmp:all my.jpg
```

-ExifTool shows both:

```
City=somename
City=newname
```


Examining jpg file with some HexViewer, I can see that "somename" was probably set
with ExifTool v 6.87 -because I can see that version entry inside file.
Now... I assume new entry (for xmp:city) should replace old one and entering:
exiftool -xmp:city="verynewname" my.jpg
-confirmed that: "newname" was replaced with "verynewname", but "somename" remain there.
I've tried to delete xmp:city entry, but only "verynewname" was deleted. Any idea?

Bogdan

Posted on 2007-05-20 11:54:21-07 by exiftool in response to 5170

Hi Bogdan,

Are you sure that the old City tag is XMP? ExifTool writes IPTC by default,
so if you used "-City=name" you wrote the IPTC, not the XMP tag. Use -g1 -a
when extracting information to see where the tags are stored. (This is FAQ #3).

- Phil

Posted on 2007-05-20 12:36:28-07 by bogdan in response to 5174

Thanks for response,
Yes, I've tried as you suggested too, and I'm sure both are inside XMP.
I'll send image to you via mail, so you can see two City entries inside XMP:
"Olimje" and "LONDON"

Bogdan

Posted on 2007-05-21 11:35:33-07 by exiftool in response to 5175

Hi Bogdan,

Thanks for the sample. I had considered this possibility when I wrote my last response,
but I have never seen it happen so I went for the more obvious solution first.
In your JPEG image, there are two XMP records. I have never seen this before,
but somehow it has happened. One record is in the proper place, but the other
is inside the EXIF ApplicationNotes as you would find in a TIFF image, not a JPEG.
I have done a few tests so far and can't figure out how you could coerce exiftool
into writing the ApplicationNotes in a JPEG image, although apparently this happened
since ExifTool 6.87 signed the XMP written here in your image.

I have tried using ExifTool 6.87 to do various things like write XMP in your
image and copy all tags from a TIFF image to a JPEG, but so far I haven't been able to
reproduce this. Give me a bit of time to sort this one out.

If you can give me any details about the history of the file, it may be helpful.
(ie. were the tags ever copied from a TIFF or RAW image?)

Thanks for pointing out this problem.

- Phil

Posted on 2007-05-21 17:22:05-07 by bogdan in response to 5181

I've gone thru history of this file and could repeat this behaviour.
And the good news first: I think this isn't ExifTool issue.
Here are some details:

I've written XMP location tags directly into Canon raw (CR2)
file with ExifTool -as ExifTool is the only tool I trust for doing that.

After that I've converted CR2 to JPG using Canon's Digital Photo Professional (latest version).
While doing that, DPP "copies" XMP tags into resulting JPG file too, which is expected
behaviour -except (as it seems), these tags cannot be modified later
(no matter what ExifTool version being used).

As you may know, Canon DPP modifies raw files too, by writing various DPP settings into file.
But that doesn't affect previously written XMP data inside CR2: I can modify
XMP data in raw without problem later (after DPP wrote modify data inside CR2).

So my conclusion: If XMP data exists inside CR2, Canon DPP doesn't know how to write
that data properly into converted file.
So,... keep on doing good work :-)

Bogdan

Posted on 2007-05-21 20:36:12-07 by exiftool in response to 5188

Good detective work! This makes sense. It doesn't surprise me that Canon DPP could do this.
I would suggest a bug report to Canon, but I'm 90% sure that it would result in a response of:
"Sorry, we don't support modified CR2 images".

But since it has happened now, I feel obliged to add the ability to exiftool to modify
and/or delete this misplaced XMP information. I'll look into this, and you may find this
new feature in an upcoming release.

- Phil

Posted on 2007-05-22 13:27:04-07 by exiftool in response to 5190

I have looked into this in a bit more detail. I can't add the ability to edit this misplaced
XMP information without resulting in a performance hit when writing information.
To speed processing, ExifTool does not process EXIF in a JPEG image when only writing XMP.
Even just adding a check to see if the XMP exists in the EXIF would slow things down,
and would be unnecessary for any properly formatted JPEG image.

But the good news is that you can use the current exiftool to edit this
information by forcing it to process the EXIF. This can be done by writing any EXIF tag.
For instance, you could do something like trying to delete ISO from IFD1 (it never exists there anyway).
This would cause the EXIF to be processed, allowing the contained misplaced XMP to be edited. ie)

```
 exiftool -xmp:city="newname" -ifd1:iso= my.jpg
```

- Phil

Posted on 2007-05-22 16:31:25-07 by bogdan in response to 5200

Phil, this is genius.
If I understand you advice correctly, then I can use ifd1:iso as "dummy" tag -just to force
ExifTool to do XMP work inside exif section. Of course in this case such
XMP tags remain inside exif section, but at least we are able to change their content.
Following your suggestion, I was able to delete complete "old" XMP tags, by using:

```
exiftool -xmp:all= ifd1:iso= my.jpg
```

-and add new (correctly written) XMP tags... so nobody can blame ExifTool doing something wrong :-)

I haven't tried, but I agree there's no point to give a note to Canon -I believe
they use answering machines for such complains.
And one more note (if somebody wonder): when DPP converts raw file to tif,
such odd things (as with jpg) doesn't happen -must be pure luck.

Have a nice day,
Bogdan

Posted on 2007-05-22 17:27:06-07 by exiftool in response to 5202

Hi Bogdan,

It sounds like you understand what is going on, but just one note:

The CR2->TIFF conversion doesn't suffer from the same quirks because CR2
is a TIFF-based format and all of the meta information is stored in the same locations
in both files. It's only the JPEG which is different: With JPEG the XMP and the
IPTC are both split off from the EXIF/TIFF information and stored in separate JPEG segments.

- Phil


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/5170 -->


