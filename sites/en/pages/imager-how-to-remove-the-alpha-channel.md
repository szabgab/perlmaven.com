---
title: "Imager: How to remove the alpha channel?"
timestamp: 2013-01-16T01:55:51
tags:
  - Imager
published: true
archive: true
---



Posted on 2013-01-16 01:55:51.886443-08 by bugmenot

I'm currently using ImageMagick's convert command to convert a png to a
tiff and to remove the transparent background and replace it with white
(this is needed by tesseract ocr):

```
convert img.png -background white -alpha off -alpha remove
```

I haven't been able to figure out how to remove the alpha channel with Imager.
So far all I have is

```perl
$image->write(file => 'output.tiff', i_background => '#ffffff')
```

but because tiff supports transparent backgrounds apparently,
the i_background doesn't have an effect. how do i remove the alpha channel
while making the background white?

Posted on 2013-01-16 03:56:25.050922-08 by tonyc in response to 13860

Create a new image, fill it with white and use rubthrough to compose
the original over the background:

```perl
# source in $image
my $back = Imager->new(xsize => $image->getwidth, ysize => $image->getheight);
$back->box(filled => 1, color => "#FFFFFF");
$back->rubthrough(src => $image);
$back->write(file => "output.tiff");
```

Posted on 2013-01-18 14:45:20.266128-08 by bugmenot in response to 13861

Thank you, that works great. I did notice, though, that the resulting
TIFF produced by Imager is 3x the size of that produced by convert.

Posted on 2013-01-18 15:27:44.373874-08 by tonyc in response to 13867

If the input image is greyscale with alpha you can make the output image greyscale instead:

```perl
my $back = Imager->new(xsize => $image->getwidth, ysize => $image->getheight,
        channels => $image->getchannels() > 2 ? 3 : 1);
```

Assuming your fill colour is monochrome. Also, size will depend on what compression
options you use, Imager defaults to packbits compression for TIFF,
you can override that with `tiff_compression => "lzw"` for example.

Posted on 2013-01-18 22:45:10.804898-08 by hansey in response to 13868

How to cut video frame by frame and keep the key frames only on Mac MTS
recordings from AVCHD camcorder are often highly compressed before stored,
such a compressed movie contains key frames and non-key frames. Key frames
can be displayed independently, while non-key frames can not be displayed
without key frames. So such a functionality to locate and display every
frame correctly, no matter key frame or non-key frame, is called frame accuracy
(frame by frame). (Tip: Frame is one of the many single photographic images in a video.)

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/13860 -->

