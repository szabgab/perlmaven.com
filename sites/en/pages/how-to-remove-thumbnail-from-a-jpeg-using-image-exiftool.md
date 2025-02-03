---
title: "How to remove thumbnail from a jpeg using Image::ExifTool"
timestamp: 2009-07-14T10:09:17
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2009-07-14 10:09:17-07 by jbphoto

Hi, The pictures (jpg) I want to put on my website are about 60Ko with a 20Ko thumbnail inside!!!
How can I remove this thumbnail, but keeping Exif and IPTC info
(which are displayed on my site: http://www.jeb.photo.free.fr)

Thanks for your help
JB

Posted on 2009-07-14 11:00:47-07 by exiftool in response to 11170

To remove just the thumbnail:

```
exiftool -thumbnailimage= FILE
```

where FILE is one or more file or directory names.

But doing this will leave behind some tags like the thumbnail resolution which
are no longer necessary. So if you are dealing with JPEG images a
better method would be to delete all IFD1 tags, which will remove the
Thumbnailimage and all associated tags. (IFD1 is the thumbnail IFD in JPEG images.):

```
exiftool -ifd1:all= -ext jpg FILE
```

Here I have added "-ext jpg" to be sure only JPEG images are processed
if FILE is a directory. This is important because you don't want to delete
IFD1 from other image formats.

- Phil

Posted on 2009-07-14 11:41:11-07 by jbphoto in response to 11172

Hi Phil,

```
exiftool -ifd1:all= -ext jpg FILE
```

seems to work perfectly my test file went from 57.584b to 42.702b for jpg
to web it's about 15% great!!

the more I use Exiftool, the more I like it!!
I have another question about reducing the size of jpg for the web but I'll open a new thread.

JB

Posted on 2009-08-08 15:17:53-07 by storhaug in response to 11172

When removing the preview-image, is the parameter
`-PreviewImage= ` good enough, or is it best practice to remove related
tags which are unnecessary without the preview-image?

Posted on 2009-08-11 11:27:17-07 by exiftool in response to 11255

In a JPEG image, tags related to the PreviewImage are usually stored in the
makernotes, so in general they can not be deleted, so -previewimage= is all you can do.

- Phil

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/11170 -->

