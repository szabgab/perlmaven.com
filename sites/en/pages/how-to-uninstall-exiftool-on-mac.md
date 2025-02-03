---
title: "How to Uninstall ExifTool on Mac OSX"
timestamp: 2008-06-28T00:45:42
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2008-06-28 00:45:42-07 by pixel

I downloaded and installed ExifTool for the Mac. This program is way beyond my comprehension,
as far as using the Terminal etc.
Can someone please give me simple directions for uninstalling the program without
any obscure Unix-type jargon. I'm not even sure where it is located. Thanks.

Posted on 2008-06-28 13:16:43-07 by exiftool in response to 8188

Here is the OS X uninstall procedure:

1) Open the "Terminal" application.

2) Type "open /usr/bin" (without the quotes) in the Terminal window, then press RETURN.
(This opens a folder that you normally can't access from OS X.)

3) Drag "exiftool" and "lib" into the trash from the "bin" folder you opened.
You should first confirm that "lib" contains only two sub-folders: "File" and "Image".
If it contains anything else, don't trash it because you have the wrong "lib" folder.

- Phil

Posted on 2008-06-29 10:52:28-07 by pixel in response to 8191

Thanks. That worked.

Posted on 2008-07-22 15:25:19-07 by jkooyman in response to 8191

Thanks a lot !!

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/8188 -->


