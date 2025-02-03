---
title: "Embed ICC Color Profile in JPEG"
timestamp: 2006-08-30T20:10:26
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2006-08-30 20:10:26-07 by gumpix

Hi, i would like to embed an ICC Color Profile like sRGB or AdobeRGB in a JPEG. How can i do that with Exiftool? Thanks a lot for help!

Posted on 2006-08-31 18:13:55-07 by exiftool in response to 2873

First, you need a valid ICC profile to write into the file. You can extract it from any other image containing a profile with a command like this:

```
exiftool -icc_profile -b src.jpg > profile.icc
```

Then this command writes the profile to "dest.jpg":

```
exiftool "-icc_profile<=profile.icc" dest.jpg
```

- Phil

Posted on 2006-09-01 15:54:27-07 by gumpix in response to 2883

Thank you Phil! It works perfect!!! :-)


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/3706 -->



