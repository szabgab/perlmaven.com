---
title: "Perl syntax to inject external XMP data into image files"
timestamp: 2008-04-24T17:13:10
tags:
  - XMP
  - Image::ExifTool
published: true
archive: true
---



Posted on 2008-04-24 17:13:10-07 by stainsby

I found Phil's example from 2005 and have command line syntax working just fine.

```
exiftool -xmp'<=../xmp/external.xmp' -o ./test/%f.%e .
```

When I fire ImageInfo I get exactly what I need to see. However, I cannot for the life of
me see how to specify the equivalent behaviour in the perl scripts I am setting up.
My current guess runs something like this:

```perl
my $exif = Image::ExifTool->new();
$exif->SetNewValuesFromFile( $xmpfn, 'XMP:*' );
$exif->WriteInfo( $fn );
```

Clarification? Anyone? Erik

Posted on 2008-04-24 17:29:35-07 by exiftool in response to 7756

Hi Erik,

Your script will copy the tags individually from the XMP file, but the command line set the value of the "XMP" tag from the data of the file. ie)

```perl
my $exif = Image::ExifTool->new();
my $data;
open FILE, $xmpfn or die;
read FILE, $data, 1000000 or die;
close FILE;
$exif->SetNewValue( 'XMP', $data );
$exif->WriteInfo( $fn );
```

Of course, this code imposes an arbitrary restriction of 1000000 bytes on the size of the XMP file -- this was done just to simplify the example.

- Phil

Posted on 2008-04-24 17:34:54-07 by exiftool in response to 7757

Also, I should mention that

```
 -o ./test/%f.%e
```

is equivalent to

```
-o test
```

provided the "test" directory already exists.

- Phil

Posted on 2008-04-24 17:37:58-07 by exiftool in response to 7758

I just read my own documentation and realized that

```
-o test/
```

(with the trailing slash) is equivalent to what you have done, even if the test directory doesn't already exist.
(ie. the "test" directory will be created.)

- Phil

Posted on 2008-04-24 20:13:15-07 by stainsby in response to 7757

Exactly what was needed. Thanks, Phil, and thanks so much for the great tool.


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/7756 -->


