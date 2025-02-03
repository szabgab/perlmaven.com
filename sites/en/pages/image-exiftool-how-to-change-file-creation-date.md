---
title: "Image::ExifTool: How to change file creation date?"
timestamp: 2008-08-02T06:21:19
tags:
  - Image::ExifTool
published: true
archive: true
---





Posted on 2008-08-02 06:21:19-07 by ce

After searching through the manual I could not find a way to set the file creation date in exiftool.
I was expecting a "tag" such as FileCreateDate that works the same way as FileModifyDate.

I want to reset the filesystem creation date to the date the picture was taken,
since the file date gets reset when i move files from one drive to another.

Thanks

Posted on 2008-08-02 11:45:44-07 by heiko in response to 8470

Hello, you can use
`ExifTool "-DateTimeOriginal>FileModifyDate" name.jpg`

to do your job Regards Heiko

Posted on 2008-08-02 15:44:04-07 by ce in response to 8472

The suggested solution will only change the "Modified" date in the file system,
but the "Created" date in the filesystem will not be affected.
I would like to set the filesytem creation date to the date when the picture was taken,
which seems to be impossible with exiftool.exe.

Surely it would be an easy task in perl.

Posted on 2008-08-15 11:04:38-07 by exiftool in response to 8473

Unfortunately the filesystem create date is not part of a Unix filesystem,
so Perl has not evolved a built-in command to modify this date.

- Phil

Posted on 2011-05-03 14:48:58.687919-07 by mlt in response to 8558

I know it is an old post but I came across it while having the same problem.
While there are some difficulties on *nix, it is possible on Win32.
Here is a tiny perl script that fixes file creation date in current directory:


```perl
use Win32API::File::Time qw{:win};
use Image::ExifTool qw(:Public);
use Date::Parse;
opendir(DIR, ".");
@files = readdir(DIR);
close(DIR);
foreach $file (@files) {
    next if $file !~ /.+\.jpe?g$/;
    my $tag = "CreateDate";
    $values = ImageInfo($file, $tag);
    $value = $$values{$tag}; # can be a different name !!!
    # http://search.cpan.org/~exiftool/Image-ExifTool-8.50/lib/Image/ExifTool.pod#ImageInfo
    print "Setting $file file creation date to $value\n";
    $time = str2time($value);
    if (! SetFileTime($file, undef, undef, $time) ) {
        warn "Error occured: $^E\n";
    }
}
print "Done!\n";
```

Posted on 2011-05-05 21:14:49.724048-07 by namakamsu in response to 13325

yes, any info would be a great help. wintergartenmoebel Wohnzimmermoebel Tisch aus Rattan

Posted on 2011-06-25 07:53:56.974353-07 by woro80 in response to 13327

Its a very god quastion. Can you help us? Suchmaschinenoptimierung | Rankstats

Posted on 2011-06-25 07:55:40.677495-07 by woro80 in response to 13379

and also MPU BfK

Posted on 2011-07-04 01:30:08.574742-07 by mili in response to 13379

Re: How to change file creation date?

STEP 1: Start Windows Explorer - click on Start button, then point to Programs,
then Accessories, then click on Windows Explorer icon.
Starting Windows Explorer from Accessories menu

STEP 2: Locate file which dates (creation date, last modified date and / or last accessed date)
you want to change. Locate file to change file dates

STEP 3: Press right mouse button on that file.
Drop down menu will appear. Menu items may vary, but usually last one is Properties.
Context menu for file

STEP 4: From Drop down menu choose Properties. File's Property tabs will appear.
Windows properties - general tab

STEP 5: Click on Date tab. Now you are ready to change file dates
(creation date, last modified date and last accessed date).
Windows properties - date tab

STEP 6: First of all, check "Created" checkbox (you can use shortcut: ALT+C)
and enter date, time values for file creation date. change file Creation date

STEP 7: Now check "Modified" checkbox (you can use shortcut: ALT+M) and enter date,
time values for file modification date. change file Modification date.

STEP 8: Now check "Accessed" checkbox (you can use shortcut: ALT+E) and enter date,
time values for file last accessed date. change file Last accessed date

STEP 9: Also check / clear "Include subfolders" - to process subfolders
(in case if folder(s) selected) and "Don't apply to system files" - to preserve system files dates
(if system files / folders selected). Now click on OK button. change file dates

STEP 10: You have just changed file dates - creation date, modified date and last accessed date!


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/8470 -->

