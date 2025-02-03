---
title: "PadWalker for Windows Solution"
timestamp: 2008-03-05T14:42:33
tags:
  - PadWalker
published: true
archive: true
---


For instructions, how to install PadWalker on Windows and other Operating systems,
please check out the [article about PadWalker](/padwalker).


Posted on 2008-03-05 14:42:33-08 by ejhansen71

If you are attempting to install Padwalker for perl on windows,
go to your Perl Package Manager and add the following site as a place to look for perl packages:
http://www.bribes.org/perl/ppm/

This site was valid as of March 5, 2008.

In the activeperl PPM you can find the place to add sites to browse for Perl packages under

Edit---Preferences---Repositories

Once the packages get loaded up in the PPM, you can use the PPM to search and find Padwalker.
Select it , mark for installation and execute.

You have to do all this nonsense because this module is not part of the standard
perl library and EPIC decided to make it required without actually providing
it as part of its Eclipse installation. I guess they assume everyone develops on a unix or linux system.

Enjoy

Posted on 2009-02-06 09:41:17-08 by ken830 in response to 7273

I can't get Padwalker to work under Vista x64. I forced the PPM install
of PadWalker-1.7-PPM510.tar.gz, but Eclipse still complains about it not installed.

Posted on 2010-02-08 15:34:07.858904-08 by garipama in response to 7273

Hi, I am struggling to get the padwalker installed in Windows.
Please guide me. I followed the below procedure:

Launched the C:\perl\bin\ppm.bat
Went to Edit--Preferences-- Repositories
Added http://www.bribes.org/perl/ppm/ site

get below error:

```
Synchronizing Database
...
Downloading ActiveState Package Repository packlist ...
failed 500 Can't connect to ppm4.activestate.com:80 (connect: Unknown error)

Downloading http://www.bribes.org/perl/ppm/ packlist ...
failed 500 Can't connect to www.bribes.org:80 (connect: Unknown error)
Synchronizing Database done
```

Please help me....

Posted on 2010-12-23 21:35:12.810957-08 by ankit in response to 7273

I could able to install the Padwalker successfully on Windows XP (Running Perl 5.8.x), I followed:

1) Downloaded the PadWalker.ppd from http://www.bribes.org/perl/ppm/
And it saved under C:\Perl, but default it saved as .htm extension so
I have renames the extension to .ppd (so the file name becomes C:\Perl\PadWalker.ppd) And then ran

2) C:\Perl# ppm install PadWalker.ppd

it gave error "ppm install failed: No file at C:\Perl\PadWalker-1.92-PPM58.tar.gz"

Then I have downloaded the file PadWalker-1.92-PPM58.tar.gz from
http://www.bribes.org/perl/ppm/ and saved it into C:\Perl and again ran:

```
C:\Perl# ppm install PadWalker.ppd
Unpacking PadWalker-1.92...done
Generating HTML for PadWalker-1.92...done
Updating files in site area...done
6 files installed
```

and installation was successfully. Hope this will help.

Posted on 2012-02-17 06:47:43.373356-08 by nmanos in response to 13119

Make sure that the Module (PadWalker) filename format is:
[Module Name]-[Module Version]-[PPM Version].tar.gz

Otherwise it will keep failing with: ppm install failed: No file ...

Posted on 2013-04-11 19:39:19.655946-07 by ankutiger in response to 7273

Here follow the steps to install padwalker on windows.

Follow 3 simple steps
[here](http://perfect-blog-url.blogspot.com/2010/04/install-padwalker-on-windows-for-epic.html)

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/7273 -->

