---
title: "Exif ColorSpace tag value 2 is wrong?"
timestamp: 2006-08-14T15:36:06
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2006-08-14 15:36:06-07 by boscarol

Hi all.

At this page tag ColorSpace is listed with values 1 = sRGB, 2 = Adobe RGB, 65535 = Uncalibrated.

I think that value 2 (Adobe RGB) is wrong.

The specification for EXIF 2.21 (JEITA CP3451-1, section 4.6.5-B) states that
"if a color space other than sRGB is used, Uncalibrated (=FFFF.H) is set.

In fact Exif 2.21 discriminates between sRGB and AdobeRGB not by means of ColorSpace tag,
but of InterOperability Index tag.

Am I wrong?

Thank you.

Mauro Boscarol

Posted on 2006-08-22 13:04:28-07 by exiftool in response to 2784

You are correct about the EXIF specification. However, ExifTool also reads/writes
non-standard information. I will have to do a bit of work to determine where
I found the definition for the value of 2 -- unfortunately I didn't reference it
in the code like I have been doing more recently. Let me look into this.

- Phil

Posted on 2006-08-22 19:19:57-07 by geve in response to 2818

This is not only the case for this tag, but for all tags. Should we document which
values are valid for which camera's. And with valid a mean proven. This is a tremendous job.

But in the other hand an example:

```
Tag: $0009 ImageSize for Pentax, we though we next was valid (comparison IDF and makernote values)
8 = 2560x1920 // S50, S55, S5i
22 = 2304x1728 // S4, S40, S45, S4i, S5n
But making pictures with a Optio S6 showed:
8 = 2304x1728 //S6 verified
22 = 2592x1944 //S6 verified
```

Posted on 2006-08-23 11:54:29-07 by exiftool in response to 2821

I have not been able to find my source for the ColorSpace value of 2,
but it is most certainly not standard EXIF. Also, none of my digital camera samples use this value,
so it is very uncommon if used at all.

The ExifTool EXIF tag table documentation contains information from a wide variety of sources,
including private and proprietary tags which are not part of the EXIF specification.
Documenting these a bit more carefully is certainly a good idea, but would take some work.

Documenting all of the maker notes tags for every camera model as geve suggests takes this
to a whole new level, and would require a vast set of test images (not only one image
per camera as I am currently collecting, but one image per camera per possible setting
or combination of settings!). Very useful, but essentially impossible to validate all possible values.

It is unfortunate that Pentax (and other companies) use the same tag value to mean different
things for different camera models. This breaks forward compatibility of decoding software
and makes the job much more difficult to provide a reliable meta information reader/writer.


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/2784 -->


