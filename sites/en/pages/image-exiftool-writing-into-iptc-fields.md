---
title: "Image::ExifTool - Writing into IPTC-fields"
timestamp: 2005-05-31T13:22:50
tags:
  - Image::ExifTool
  - IPTC
published: true
archive: true
---



Posted on 2005-05-31 13:22:50-07 by linuxuser

Is it possible to write data into IPTC-fields with exiftool? If so, give an example please.

Posted on 2005-05-31 15:14:28-07 by exiftool in response to 524

Writing IPTC is the same as writing any other type of meta information with ExifTool.

"exiftool -city=kingston test.jpg" will write the IPTC city tag since "City"
doesn't exist in the EXIF or GPS information, and the IPTC is the next highest priority group.
(The priority order is 1) EXIF, 2) GPS, 3) IPTC, 4) XMP, 5) MakerNotes).

Alternatively, you can specify the IPTC group to be sure you are writing the IPTC information:
ie) "exiftool -iptc:keywords=help test.jpg"

Posted on 2005-05-31 15:38:26-07 by scottlindner in response to 529

"Writing IPTC is the same as writing any other type of meta information with ExifTool."

I think the problem is understanding the structure and Exiftool naming convention for all of the tags.
I've reread your website many times and I still do not know how one knows when to use
ExifIFD or some other tag group name.

I've taken your request seriously to provide useful comments to help with this.
I am very good at that. I want to use Exiftool for a while longer first so I can make sure
I understand it before sending you off with shortsighted comments to rework your web page.

Cheers,
Scott

Posted on 2005-05-31 18:04:24-07 by exiftool in response to 532

Excellent! I look forward to your comments, and appreciate the fact that you're
taking your time to understand ExifTool (and the meta information jungle!) before making them. :)

Posted on 2005-05-31 18:59:07-07 by linuxuser in response to 536

I wished I found exiftool earlier :-) I will write a little bit more of my exif-problems,
but it takes time to write down my thoughts and problems realizing it.
Some exif-problems took me crazy for months, but now, with exiftool, I found a workaround
at least for all the problems. Thanks for this tool! I found a little problem with exiftool,
although it is probably a problem of the camera manufacturer. -s -s -s -Make produces spaces
at the end of "Caplio R1". Could you change it, that the output of -s -s -s has no blanks
at the beginning and and the end?
BTW should -sss work too, it didn't work. In the meantime my bash-script uses
.. | sed 's/^ *//' | sed 's/ *$//' If you would like to have a picture for testing,
please tell me where to send it.

Posted on 2005-05-31 19:35:03-07 by exiftool in response to 537

I'll have to think about trimming the spaces to see if that might cause problems for other tags.
I have a Caplio RR1 test file here, and I can see the spaces Ricoh inserts after the make.
I don't know why they do that.

Stringing multiple options together is not possible because then you generate a tag name. ie)
is "-make" a request to extract "Make", or the "-m -a -k -e" options?
For this reason, you can't combine options into a single argument with exiftool.

Posted on 2005-06-02 11:25:59-07 by exiftool in response to 538

I've released ExifTool 5.24 which trims trailing whitespace from values in the exiftool script printout.

Posted on 2005-06-02 11:57:59-07 by linuxuser in response to 564

Thanks for updating exiftool. I am not so familiar with perl. How do I update?
I installed with "cpan -i Image::ExifTool" How do I downgrade, in case
I find other problems with the new release? Of course I will tell you, which problems occured.
I couldn't find an update option in "man cpan"

Posted on 2005-06-02 12:06:44-07 by exiftool in response to 570

I only upload production versions to CPAN. For other versions, visit my web site.
See the README file for my website URL and installation instructions.

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/524 -->


