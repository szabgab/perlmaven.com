---
title: "Using the exiftool library from php (in place of native php function)"
timestamp: 2008-02-28T13:21:33
tags:
  - Image::ExifTool
  - PHP
published: true
archive: true
---



Posted on 2008-02-28 13:21:33-08 by dbrb2

Hi,

I have a directory full of geocoded images. I need to extract info into an
[XML file](http://bbarker.co.uk/photography/London_2_Paris/exif.xml)


This file can then be parsed by a website to display them on a map.
I initially coded this in php, looping through each image and using exif_read_data().
This worked, but I found that on many images I got a large number of errors complaining
about the headers (and no exif data returned, even though other software had succesfully
read the headers) and hence many images mere missing from the
[XML file](http://bbarker.co.uk/photography/London_2_Paris/).

I then found this library. I ran some of the same problem photos through this parser
(using the windows tool) and it worked fine on all of them,
so I am tempted to use the php interpreter in php to use this function.
Any ideas how well this might work?

Also, can anyone explain why the native php function gives the errors it does? Is it just quite buggy?

Cheers,

Ben

Posted on 2008-02-28 14:25:35-08 by exiftool in response to 7220

I can't help you with your PHP problem, but with a bit of work ExifTool could be used
to generate an XML file in this format. The commands would be as follows:

```
echo "<photos>" > out.xml exiftool -n -p prt.fmt DIR >> out.xml echo "</photos>" >> out.xml
```

where DIR is the name of a directory containing the images.

This command uses a "prt.fmt" file containing the following line:

```
<photo FileName='$filename' Width='$imagewidth' Height='$imageheight'
  Date='$mydate' Time='$mytime' Datum='' Lat='$gpslatitude' Lon='$gpslongitude'/>
```

And to separate the date and time and get the date format that you use,
I have created two user-defined tags, "MyDate" and "MyTime", using the following config file:

```perl
%Image::ExifTool::UserDefined = (
    'Image::ExifTool::Composite' => {
        MyDate => {
            Require => 'DateTimeOriginal',
            ValueConv => '$val=~/(\d{4}):(\d{2}):(\d{2})/ ? "$3/$2/$1" : $val',
        },
        MyTime => {
            Require => 'DateTimeOriginal',
            ValueConv => '$val =~ s/\S+\s+//; $val',
        },
    },
);
1;
#end
```

- Phil

Posted on 2008-02-28 14:56:18-08 by dbrb2 in response to 7221

Wow - that was both a very rapid and a very helpful reponse -
I'll try it this evening and post here with the results!

Cheers,

Ben

Posted on 2008-02-28 20:55:17-08 by tistre in response to 7221

Hi, thanks for the great work on ExifTool! Just a short question -
a built-in option to do a full image metadata dump to XML would be great for us "non-Perlers";
any plans for adding something like this to ExifTool?
Or do you know of an existing implementation? I've had a quick look at Mediator
(from http://openlab.savonia-amk.fi/mediapilotti/) which seems to be based on ExifTool,
but it displays a lot less metadata than ExifTool does when invoked directly.
I'm not sure, but I think simply wrapping ExifTool output in XML tags wouldn't be
sufficient since some character set magic would have to be applied?
(I can imagine IPTC info in the Mac character set mixed with UTF-8 in XMP...
or is there already a safe way to guarantee clean UTF-8 output of all metadata?)
Thanks again, Tim Strehle http://www.strehle.de/tim/

Posted on 2008-02-29 11:58:26-08 by exiftool in response to 7224

Hi Tim,

The character set wouldn't be a problem because exiftool outputs everything in UTF8 by default.
The problem would be deciding on an XML format that would be most useful.
If you have any ideas here, I would like to here them.

- Phil

Posted on 2008-03-03 20:17:07-08 by tistre in response to 7230

Hi Phil,

thanks for the quick reply!

> The problem would be deciding on an XML format that would be most useful.

Good question - we're currently generating (using the native PHP functions) a
home-grown XML format containing all the metadata we've been able to extract.
It's not beautiful, I'm not proud of it, but it's better than nothing :-)
Here's an example: http://www.strehle.de/tim/metadata.xml
(generated from the image http://www.strehle.de/tim/goettingen_maciptc.jpg).

Seems like Oracle invented their own Metadata Schemas -
[see](http://download.oracle.com/docs/cd/B28359_01/appdev.111/b28414/ap_xmlschms.htm#AIVUG65000).
XSD is hard to read, not sure whether it's a good XML format...

I don't know much about XMP, but I thought their aim was to be able to incorporate all
other metadata formats. So it should be possible to output some XMP dialect
(although I'm not a fan of RDF). Maybe inventing your own simple format that matches
your internal data structures is the best way to go?

> The character set wouldn't be a problem because exiftool outputs everything in UTF8 by default.

It's great to learn that exiftool is all-UTF-8 by default. There may still be issues
with character sets; my sample JPEG file contains metadata partly in UTF-8 and partly in
Mac Roman (check the last name of the photographer, Swen P.)
and we had to add some heuristics to detect Mac IPTC data and properly convert it to UTF-8.
(Does exiftool already contain such heuristics?)

By the way - you probably have a large collection of sample image files with all sorts
of metadata to test exiftool. Are they available, or do you know of any other
publicly available set of files for testing metadata extraction and embedding?
(All I have is the Adobe XMP SDK sample files and a couple of interesting images
collected from customer sites over the years.)

Regards, Tim

Posted on 2008-03-03 21:35:58-08 by exiftool in response to 7253

Hi Tim,

Thanks for the XML links. I'll read them when I get a chance and think about this some more.

OK, yes, character handling can be a problem in IPTC. I outline how exiftool
handles the character codings in FAQ number 10.

Yes, I have quite a collection of meta information, but the only files I
currently make public are the samples in the t/images directory of the full distribution,
and my JPEG sample images (but these are straight from the camera and in general don't
contain IPTC or XMP).

- Phil

Posted on 2009-02-26 08:37:57-08 by tistre in response to 7255

Hi Phil,

a colleague just showed me that XML output support (-X) has been added to ExifTool in October 2008.

Thanks a lot, this is a great feature that will make integration so much easier!

Kind regards,
Tim


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/3706 -->



