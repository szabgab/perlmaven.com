---
title: "Running exiftool in Mac OS X"
timestamp: 2005-06-07T09:42:06
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2005-06-07 09:42:06-07 by macosx

Is there information for beginners like myself who are trying to get started
with Apple's Terminal and Perl and ExifTool all at the same time.
I am really only interested in one feature at the moment and that
is extracting JPEGs from CANON RAW image files.
I have tried to follow the directions but I have been unsuccessful and it's getting
quite painful. I would appreciate tutoring
as my real work is photography and not computer programming.

-John

Posted on 2005-06-07 13:03:40-07 by exiftool in response to 592

It is really simple. Here are the steps:

1) Using your favourite browser (ie. Safari), download the latest version of exiftool
from http://owl.phy.queensu.ca/~phil/exiftool/ to your desktop.

2) Open a terminal window (by running "Terminal" from the /Applications/Utilities folder).

3) In the terminal window, type the following:

<coed>
cd ~/Desktop
tar -xzf Image-ExifTool-5.25.tar.gz
```

(Note: Replace "5.25" with the version number you actually downloaded.)

4) Assuming your Canon RAW file is on the desktop and named "Canon.CRW",
type the following to extract the JPEG image:

```
Image-ExifTool-5.25/exiftool -JpgFromRaw -b Canon.CRW > Canon_JFR.JPG
```

Or if your Camera produced .CR2 format RAW files, you need to extract the PreviewImage instead:

```
Image-ExifTool-5.25/exiftool -PreviewImage -b Canon.CR2 > Canon_JFR.JPG
```

You should now have a file called "Canon_JFR.JPG" on your desktop.
This is the JPEG extracted from the CRW or CR2 file.

5) If you want to transfer the EXIF information from the original
RAW file to the extracted JPEG, type the following:

```
Image-ExifTool-5.25/exiftool -TagsFromFile Canon.CRW Canon_JFR.jpg
```

(or use Canon.CR2 if the file was CR2 format)

That's about it. If you want, you can follow the instructions in the
README file to do a standard installation. Then you won't have to specify
the exiftool directory on the command line.
Note that some MacOS systems don't have the required Perl header files to do
the `"perl Makefile.PL"` step. Instead, you can just copy "exiftool"
and the "lib" directory to anywhere in your PATH
(type "printenv PATH" in the terminal window to show your PATH directories).

Let me know if you have any troubles.

Posted on 2005-09-22 23:30:19-07 by dayo in response to 593

Hello.

I am pretty much in the same situation as the original poster in that as a recent Mac adopter,
I don't know very much about terminal etc so your response is very welcome.
Some additional questions.

1. In the example you gave (Point 4) was is the step if the file not on the desktop.
How to you specify the path to it.

2. The main reason I am interested in this tool is that I want to create Exif data
for TIFF files from a scanner. Is this possible?

3. If it is, can I write into the exposure fields such as shutter speed, Aperture etc.
I have scans using a Minolta Scan Dual III and have all the exposure data for each
shot as I used a Minolta Dynax 7 that allows me to output text files with this data.

4. I have checked and know that the file properties section of my scanned
files do not have fields for aperture etc. Is it possible to create these fields in a
TIFF files that doesn't have one? Perhaps transfer from one image that has then to these ones?

5. I noticed that some other post had something about lenses from the Minolta Dynax 7D.
I am a hybrid shooter as in addition to the Dynax 7, I own a Minolta Dynax 7D and a Dimage A2.
Are the raw files from these units supported?

Sorry for the number of queries and thanks for your assistance.

Posted on 2005-09-23 00:59:51-07 by exiftool in response to 1028

I'll answer your questions as best I can:

1) You can prefix any filename by the path where it is located.
Directory names are separated by '/'. A complication is that on the Mac it is
common to have spaces and sometimes other funny characters in directory and file names.
This complicates things a bit on the command line because if this happens
you have to either put quotes around the whole name or put a '\' before each space character.

So for instance, if the image was in my "/Users/phil/Pictures" directory, and assuming
exiftool is in the current directory, I could type the following to extract the preview
into a directory called "Previews" in the root directory of my boot disk:

```
./exiftool -previewimage -b ~/Pictures/Minolta.MRW > /Previews/Minolta.jpg
```

Hints: The '~' character used above is a short form for your home directory name,
which is '/Users/phil' in my case. Also, it makes typing a lot faster
if you know about "tab completion": It is usually not necessary to type
an entire directory name -- once you have typed a few characters,
press the 'tab' key and the rest of the name will be completed
unless there is another directory beginning with the same sequence of characters.

2) Yes, you can add EXIF information to any TIFF file (as well as a number of other file types).

3) You can write all the information you mention, plus a lot more.

4) You can either create this information from scratch, or copy it from another image.
Whichever is easiest for you.

5) ExifTool should work on MRW images from any Minolta camera.
I have tested it personally with raw files from the 7D and A2.

I hope this helps.

Posted on 2005-09-23 10:03:06-07 by dayo in response to 1029

Thanks a million for the quick reply. I'll give it a bash.
I'll go get a book and educate myself on using Terminal.

Funny that I am quite competent with the DOS Prompt in Windows and often write complex
batch files but if I thought I could migrate my knowledge intuitively to Terminal,
I couldn't have been more mistaken. I'll correct this oversight.

Looking at some of the other posts with references to excel etc.
I suppose it is possible to write a series of tags to be loaded into an external
file and have the program loop through a series of files and update them.
However, I need to learn the basics first.

Thanks again, the hints were particularly useful

Posted on 2006-12-19 17:47:19-08 by pedroparamo in response to 593

I realize this is an old post but I'm just starting to install and use exiftool.
How do I copy the "exiftool" and the "lib" directory to my PATH?

Pedro

Posted on 2006-12-19 18:51:49-08 by exiftool in response to 3839

There are a few ways, and the exact steps depend on the shell you are using.
(The default shell is tcsh for OS X 10.3 and earlier, but it changed
to bash for OS X 10.4. Which do you use?)

Here are the steps:

1a) If you are using tcsh (the OS X 10.3 default), add the following line to the ".cshrc"
file in your home directory. (If ".cshrc" doesn't exist, use ".tcshrc" instead,
otherwise create one of these and add the line.)

```
setenv PATH ${PATH}:/usr/local/bin
```

1b) If you are using bash (the OS X 10.4 default), instead add the
following line to the ".bashrc" file in your home directory:

```
export PATH=${PATH}:/usr/local/bin
```

2) Start a new terminal window, and in that window type:

```
mkdir /usr/local
mkdir /usr/local/bin
cd /usr/local/bin
tar -xzf ~/Desktop/Image-ExifTool-#.##.tar.gz
```

This will create the /usr/local/bin directory and expand the exiftool
files in that directory. (You should change the "#.##" to the actual
version number that you downloaded. This command assumes that you
have downloaded it to your Desktop.)

After doing this, you should be able to run exiftool in a terminal window
by just typing "exiftool". (Of course, you will have to add options
and file names on the command line to do what you want after that.)

- Phil

Posted on 2006-12-20 15:46:49-08 by pedroparamo in response to 3846

Thanks. I've got that part done, but when I try to run something like:
`exiftool -h -refine test/JPEGS/60537-01.JPG`
I get the error message `-bash: exiftool: command not found.`

Do I need to be in my local/bin directory when I run exiftool,
or my home directory, or does it matter? Pedro

Posted on 2006-12-20 16:55:15-08 by exiftool in response to 3853

If you set your PATH properly, then typing "exiftool" alone should be good.
Here is a bash terminal session showing you how things should be set up:

```
u88:~/source/qsno_cvs phil$ printenv PATH
/bin:/sbin:/usr/bin:/usr/sbin:/Users/phil/bin:/usr/local/bin

u88:~/source/qsno_cvs phil$ ls -l /usr/local/bin/exiftool
-rwxr-xr-x   1 phil  phil  88398 Dec 15 07:36 /usr/local/bin/exiftool

u88:~/source/qsno_cvs phil$ which exiftool
/usr/local/bin/exiftool

u88:~/source/qsno_cvs phil$ exiftool -ver
6.66
```

Try these commands and paste your terminal session if you are still having problems.

- Phil

Posted on 2006-12-20 19:27:48-08 by pedroparamo in response to 3854

I don't think things are set up correctly. My home directory is as follows:

```
.ActivePerl
.rnd Movies
.CFUserTextEncoding
.sversionrc Music
.DS_Store
Applications
Pictures
.Trash
CPA
Archive
Public
.Xauthority
CPA iView Cat Reader Sites
.bash_history
Desktop
ppm4.log
.cshrc
Documents
.lpoptions
Library
```

My local/bin directory is:

```
Image-ExifTool-6.66
frombin
tobin
font2res
ps2pdf
ufond
fondu
showfond
```

I'm just guessing but don't I need an exiftool file (folder?)
in my local/bin directory somewhere?? I'm assuming that you wanted me to
run the commands you sent replacing 'phil' with the name of my home
directory -- which is 'home' -- here's my terminal session:

```
yubana147:~ home
$u88:~/source/qsno_cvs home
$ printenv PATH -bash: u88:~/source/qsno_cvs:
No such file or directory

yubana147:~ home$ u88:~/source/qsno_cvs home$ printenv PATH -bash: u88:~/source/qsno_cvs: No such file or directory
yubana147:~ home$ -bash: u88:~/source/qsno_cvs home$ printenv PATH/bin:/sbin:/usr/bin:/sbin:/Users/home/bin:/usr/local/bin -bash: -bash:: command not found
yubana147:~ home$ u88:~/source/qsno_cvs home$ ls -l /usr/local/bin/exiftool -rwxr-xr-x 1 home home 88398 Dec 15 07:36 /usr/local/bin/exiftool -bash: u88:~/source/qsno_cvs: No such file or directory
yubana147:~ home$ u88:~/source/qsno_cvs home$ which exiftool /usr/local/bin/exiftool -bash: u88:~/source/qsno_cvs: No such file or directory
yubana147:~ home$ u88:~/source/qsno_cvs home$ exiftool -ver 6.66 -bash: u88:~/source/qsno_cvs: No such file or directory
yubana147:~ home$ Thanks for all your help. Pedro
```

Posted on 2006-12-20 20:59:17-08 by exiftool in response to 3859

Hi Pedro,

Thanks. I'm sorry, it's my fault. Expanding the distribution in the /usr/local/bin directory created a subdirector called Image-ExifTool-6.66. The exiftool files have to be moved to the parent directory. ie)

```
cd /usr/local/bin
cp -r Image-ExifTool-6.66/exiftool .
cp -r Image-ExifTool-6.66/lib .
```

Also, there was some confusion about my terminal session.
Everything before the '$' was just part of the prompt, not a command.
So my idea there didn't work too well. I wanted you to type the following:

```
printenv PATH
ls -l /usr/local/bin/exiftool
which exiftool
exiftool -ver
```

But I think we know now that the 'ls' command wouldn't find exiftool since
it was in the Image-ExifTool-6.66 sub-directory. Sorry about that.

- Phil

Posted on 2006-12-27 15:50:20-08 by pedroparamo in response to 3860

Hi Phil, I think I've got everything straight, but I can't seem to get exiftool to work.
I want to get the exif info of a file in a folder on my desktop "test/60512F-01.CR2".
When I run (from the terminal window, in the home directory)
`exiftool -h -test/60512F-01.CR2`
I get the following error `-bash: exiftool: command not found`
Does it matter which directory I am in when I run exiftool?

Thanks. Pedro

Posted on 2006-12-27 17:21:24-08 by exiftool in response to 3907

Hi Pedro,

You need to either type the exiftool directory each time, ie)

 ~/Desktop/Image-ExifTool-6.66/exiftool  -h ~/Desktop/test/60512F-01.CR2

or add the exiftool directory to your PATH. Since you are using bash, it can be done like this:

 echo "export PATH=${PATH}:/Users/USERNAME/Desktop/Image-ExifTool-6.66" >> ~/.bashrc

where "USERNAME" is your user name. (Just cut and paste the above line as a command in your terminal window, substituting USERNAME appropriately.) Then you must open a new Terminal window for the new PATH to take effect.

Note that both of these examples assume that exiftool is in a directory called "Image-ExifTool-6.66". If it is somewhere else just change this to the proper directory name.

(Also, in these examples I have used "~", which is a shorthand for your home directory "/Users/USERNAME" that can be used in commands and filenames.)

- Phil

Posted on 2006-12-27 20:02:04-08 by pedroparamo in response to 3911


Phil, Now I'm a bit confused and I'm not sure where my exiftool is located.
My home directory looks like this:

```
. .lpoptions Documents .. .rnd Library .ActivePerl .sversionrc Movies .CFUserTextEncoding Applications Music .DS_Store CPA Archive Pictures .Trash CPA iView Cat Reader Public .Xauthority Canon_60152F-01.CR2 Sites .bash_history Canon_60512f-01.CR2 exiftool .cshrc Desktop ppm4.log
```

ExifTool-6.66 is located in my /usr/local/bin:

```
yubana147:~ home$ cd /usr/local/bin
yubana147:/usr/local/bin home$ ls -a
. fondu tobin .. frombin ufond Image-ExifTool-6.66 ps2pdf dfont2res showfond
```

Does this look correct? I added the exiftool directory to my PATH as per your instructions.
Should I now be able to run exiftool from my home directory by just typing commands?
Or do I need to type exiftool -h ~/Desktop/test/60512F-01.CR2 Thanks for your patience.

Pedro

Posted on 2006-12-27 22:33:00-08 by exiftool in response to 3914

Hi Pedro,

If you have the directory "/usr/local/bin/Image-ExifTool-6.66" in your PATH,
then you're good to go with command lines that begin with just "exiftool". So typing

 exiftool -h ~/Desktop/test/60512F-01.CR2

should do the job. FYI: You can verify your PATH by typing

 printenv PATH

but it sounds like you should be good to go.

- Phil

Posted on 2006-12-27 23:57:58-08 by exiftool in response to 3920

Here are a couple more command-line tricks that may be useful to you:

In OS X, you can use the "open FILE" command at the command line,
and it will do the same thing as if you had double-clicked on the file. For example, typing this:

```
exiftool -h ~/Desktop/test/60512F-01.CR2 > out.html
open out.html
```

Creates an output HTML file called "out.html" from information
in the specified image, then opens "out.html" in your default browser (probably Safari).

Another tip is that you can use the TAB key to avoid a lot of typing.
This tip applies to any system, including OS X, Unix and Windows.
The TAB will complete any unambiguous partial command or file name,
so usually it is only necessary to type the first few characters of each word.
For instance, in the above example, what I would actually type is more like this:

```
exift[TAB] -h ~/De[TAB]605[TAB] > out.html
open out.[TAB]
```

where "[TAB]" represents a press of the TAB key.

I sort of take all this stuff for granted now, but I thought it might be useful to mention because you may not know about these tricks yet.

- Phil

Posted on 2007-01-03 16:47:32-08 by pedroparamo in response to 3921

Thanks Phil. Unfortunately I still can't get ExifTool to work.
I think that it's either in the wrong place and/or
I did not add it to my PATH correctly. My PATH is:

```
yubana147:~ home$ printenv PATH
/bin:/sbin:/usr/bin:/usr/sbin
```

In my home directory--the initial directory which I am in when
I open a terminal session contains the following:

```
yubana147:~ home$ ls -a
.
.lpoptions
Library
..
.rnd
Movies
.ActivePerl
.sversionrc
Music
.CFUserTextEncoding
Applications
Pictures
.DS_Store
CPA Archive
Public
.Trash
CPA
iView
Cat
Reader
Sites
.Xauthority
Canon_60152F-01.CR2
exiftool
.bash_history
Canon_60512f-01.CR2
ppm4.log
.bashrc
Desktop
.cshrc
Documents
```

I'm not sure what the exiftool file in my home directory is for?
If I change to my /usr/local/bin there is a folder called Image-ExifTool-6.66:

```
yubana147:~ home$ cd /usr/local/bin
yubana147:/usr/local/bin home$ ls -a
. fondu tobin .. frombin ufond Image-ExifTool-6.66 ps2pdf dfont2res showfond
yubana147:/usr/local/bin home$
```


The Image-ExifTool-6.66 folder contains the following:

```
yubana147:/usr/local/bin home$ cd /usr/local/bin/Image-ExifTool-6.66
yubana147:/usr/local/bin/Image-ExifTool-6.66 home$ ls -a
.
exiftool
..
html
Changes
iptc2xmp.args
ExifTool_config
lib
MANIFEST
perl-Image-ExifTool.spec
META.yml
t
Makefile.PL
xmp2iptc.args
README
```

What is my ExifTool directory? (To clarify, my USERNAME is the login
name I use to login to my computer, right?)

```
yubana147:~ home$ exiftool -h ~/Desktop/test/60512F-01.CR2
-bash: exiftool: command not found
```

I tried adding the exiftool directory to my path using the directory
/Users/Peter/Desktop/Image-ExifTool-6.66 And that did not work.
I also tried using the directory /Users/Peter/sbin/Image-ExifTool-6.66
But that didn't work either.
Can you tell what the problem is?

Thanks again for all your help and patience. Pedro

Posted on 2007-01-03 17:14:37-08 by exiftool in response to 3961

Hi Pedro,

Here are some answers for your questions:

1) The exiftool file in your home directory is extraneous and can be deleted.

2) Your USERNAME is the name you log in with, but my example was assuming that you had ExifTool in your Desktop directory (/Users/USERNAME/Desktop). But instead, your ExifTool directory is actually /usr/local/bin/Image-ExifTool-6.66

To set your PATH to include this directory, cut and paste the following in a Terminal window:

```
echo "export PATH=${PATH}:/usr/local/bin/Image-ExifTool-6.66" >> ~/.bashrc
```

then open a new terminal window. Your PATH (given by "printenv PATH") should then be:

```
 /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin/Image-ExifTool-6.66
```

So the last entry in your path is "/usr/local/bin/Image-ExifTool-6.66".
This is the directory that contains "exiftool" and it's libraries.
If this works, then you should be able to run exiftool by just typing "exiftool".

If you have any more questions, please email me (phil at owl.phy.queensu.ca).
I don't think it would be useful for others to continue this discussion in the forum.

Thanks.

- Phil


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/592 -->


