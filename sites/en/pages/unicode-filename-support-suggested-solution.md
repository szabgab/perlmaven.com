---
title: "Unicode File Name Support - Suggested Solution"
timestamp: 2009-05-09T09:15:48
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2009-05-09 09:15:48-07 by ce

Hello, I have written a software that is using exiftool.exe for setting meta data. It is supposed to work with all Unicode (UTF-8) characters.
The only problem that I could not find a solution for is when it comes to filenames that contain characters which are not supported by the system's ANSI code page.
In that case, it is impossible to process those files directly in exiftool.exe. Apparently, exiftool internally calls the
ANSI Win32 API for this purpose. Would it be possible to optionally use the UTF-16 Win32 API such as CreateFileW() when opening files in exiftool?
That way one could pass a UTF-8 encoded filename in an argfile and be 100% sure it can be opened by exiftool. Right now its a bit of a hit-and-miss
game when dealing with international character sets; and the only workaround is to rename/move 'suspicious' files to a different location prior to editing.
Any help in this matter would be highly appreciated. Chris

Posted on 2009-05-09 10:41:20-07 by exiftool in response to 10658

Hi Chris,

ExifTool uses the standard Perl "open" function to open a file. If anyone knows how to make this compatible with
Windows UTF-8 filenames while maintaining platform independence, please let me know.

The work-around is to pass exiftool the DOS-equivalent filenames. I know some exiftool users are doing this,
but I don't know the details of how to implement this.

- Phil

Posted on 2009-05-09 15:14:00-07 by johnrellis in response to 10659

On Perl 5.10 for Windows, I recently discovered an easy workaround for filenames containing characters whose ordinal
value is in the range 128 to 255, the Latin-1 Supplement characters, which include the common European characters such as German umlauts.
(Note that I am expert neither in Perl, Unicode, or Win32, so take everything here with two grains of salt, and please correct me if I have said anything wrong.)

Internally, though Perl uses UTF-8 to represent strings, it apparently has two different representations for such characters: a single byte and the
UTF-8 encoding as two bytes. For example, the Unicode character 00FC could be represented internally by Perl either as
the single byte 0xfc or as two bytes 0xc3 0xbc. According to the Perl documentation, chr(0xfc) uses the single-byte representation for backward compatibility.

If you force a string representing a filename to use the single-byte representation, then the Perl filesystem calls such as open()
will handle the filename correctly. See the function SingleByteStr below for a brute-force method of doing this. There may be a more elegant way, but I could not find it.

Of course, this solution does not work for characters larger than 255, but it was an easy, partial fix for a very common case.


```perl
###########################################################################
# SingleByteStr ($s)
#
# Given a string, returns an equivalent string with each char whose ordinal
# value is less than 255 encoded as a single byte. This is required for the
# Perl Windows file-system primitives such as -e and open (), which expect
# strings of single bytes.  The Perl file primitives can't in general
# handle arbitrary Unicode strings, since the Perl Windows implementation
# doesn't use the Windows "wide" system calls. But the primitives can
# handle characters from 128 to 255, as long as they are encoded as a
# single byte.
#
# Unfortunately, the Perl implementation allows for two different
# representations of such characters -- as a single byte or as a 2-byte
# UTF-8 sequence.  Even more unfortunately, the DBI::Sqlite driver returns
# unicode strings using the correct 2-byte UTF-8 sequence.  So this
# function converts such UTF-8 encodings to single-byte encodings.
#
# Note that if $s has characters larger than 255, the file-system
# primitives won't know how to handle them.

sub SingleByteStr ($s) {
    my ($s) = @_;

    my $newS = "";
    for my $i (0 .. length ($s) - 1) {
        $newS = $newS . chr (ord (substr ($s, $i, 1)));}
    return $newS;
}
```

Posted on 2009-05-09 23:34:33-07 by ce in response to 10659

Hi,

thanks for your suggestions. The problem with so called DOS 8.3 file names is that first, they
may or may not be supported by the current file system. It is possible to turn them off for performance reasons in NTFS file systems.
Second, if ExifTool recreates a file referenced with an 8.3 name, the original file name can be lost and the file
will only show up with the truncated 8.3 name.

So the only solution that currently works 100% is to rename the original file to a safe name
and copy it to a safe path and edit it in that place, then move it back to the original path and name.
Obviously this technique is quite slow and it is not possible to process multiple files in batch mode.
Thats why I would love any direct support of unicode file names.

Using the Win32 Unicode APIs, it might actually be quite simple to be 100% Unicode compatible - though this will not work on other platforms:

```perl
use Win32API::File qw(CreateFileW OsFHandleOpenFd :FILE_ OPEN_EXISTING);
my $h = CreateFileW(encode("UTF-16LE", "\x{2030}.jpg\0"), FILE_READ_DATA, 0, [], OPEN_EXISTING, 0, []);
```

I am not sure if Perl has to offer any alternatives to Win32API::CreateFileW().
Would it be possible to make use of such a platform-specific API?

Thanks. Chris

Posted on 2009-05-10 12:18:03-07 by exiftool in response to 10662

Hi Chris,

I will look into this. Thanks for the suggestion.

- Phil

Posted on 2009-05-11 22:59:21-07 by exiftool in response to 10665

Hi Chris,

I have looked into this. Unfortunately, the consensus seems to be that native Perl is essentially broken w.r.t. Unicode filenames in Windows.
The alternative you have suggested is the only feasible alternative I have found. Unfortunately, there are big problems implementing this:

1) The Win32API module is not included in the standard Windows Perl distribution, so I would have to add a dependency.
OK, so this isn't really a big problem, but ExifTool so far has no other dependencies, and I would like to keep it this way.
If I implemented this, I could make Win32API optional, and only required if you want to use Unicode filenames.

now for the big problem:

2) It seems I would have to rewrite nearly all of the file handling. At a minimum, includes replacing
all open() and close() calls, all rename(), unlink() and utime() calls, and all file test operations (-e and -s operators, etc).
There are a couple of hundred of these throughout the code, and changing all of these will be messy and very time consuming. I believe it is possible,
but it certainly wouldn't be easy. I think I could probably get around replacing all of the read() and write() calls by reopening all
native Windows filehandles as Perl files using Win32API::OsFHandleOpen(), which is little consolation because then
I effectively have to do 2 open's and close's for each file, and is may more work than just replacing the
read/write calls in the first place (since most of my read/write calls are localized in a few ExifTool functions.

I wish it was possible to implement a partial solution, but much of the file logic in the exiftool application
would break if I attempted this. And nobody wants an unreliable application. So it is all or nothing.

And for now, I'm sorry, but it looks like it will have to be nothing.

For what it is worth, I don't think this problem is Perl specific. The Perl file handling is based entirely
on the C stdio libraries, which must suffer from similar problems when it comes to Windows Unicode filenames.

- Phil

Posted on 2009-05-12 00:36:56-07 by johnrellis in response to 10677

Phil, I just went through that same learning process for my application and came to the
same conclusion -- punt. (My partial solution above allows the Latin-1 Supplement characters in filenames,
but that was as much as I was willing to do for now.)

But here's a brainstorm: What if Exiftool had a global variable called "io" whose value
was an object with a method for each of the Perl builtin i/o functions: open(), close(), rename(), unlink(), exists(), etc.
The signature of each method would be identical to the Perl builtin function.
By default, Exiftool would initialize "io" to an instance that simply called the Perl built-ins.
But a client could set "io" to a value whose methods called the Win32 equivalents.

This would require straightforward but tedious editing of the Exiftool source to change all i/o calls,
e.g. unlink ($f) to io->unlink ($f), etc. You could decide to implement only the default instance of "io",
letting some other brave soul implement the Win32 instance.

I am not pushing for this, just putting it out as an approach that would minimize the disruption and changes to Exiftool,
if you ever decide to take it on.

John

Posted on 2009-05-12 11:21:28-07 by exiftool in response to 10679

Hi John,

Thanks for your suggestion. This is a good idea, and would avoid messing up the code.
Of course, I would have to introduce functions instead of the file test operators that I use, but that isn't a big problem.
And with any luck the extra function call for each i/o operation wouldn't have much impact on performance.

- Phil

Posted on 2009-05-13 18:07:17-07 by ce in response to 10681

Hi Phil,

thanks for looking into this. I understand that changing standard I/O behaviour in ExifTool would be quite a tough job.
Should you ever get to implement it, I would support John's suggestion of introducing an i/o abstraction layer.

As you have mentioned, the problem is not Perl specific, however the Windows
C stdio has native support for unicode filenames (via wfopen) for more than a decade now.
That way it is actually quite easy to write cross platform C code that has (optional) UTF-16 file name support.
I had a look into the C sources for Perl recently, hoping to find some sort of a wfopen() implemented, but it's 8-bit characters everywhere...

With regard to alternatives, we have experimented with all kinds of workarounds, including 8.3 "DOS" filenames,
soft and hard links and passing files via stdin. The only solution that worked in all cases was to copy the file to and
from a temporary location for reading and writing, which is an expensive operation.

I am going to describe how this was done in the hope that others might find it useful:
When do files need to be renamed before opening in ExifTool?

In this case, the most important decision when dealing with temporary files is whether or
not the file needs to be renamed prior to opening it in ExifTool. No temp file is necessary if the
path and name of the current file can be safely represented as an 8-bit ANSI string.

Due to the codepage system, there is no static set of convertible characters for any given system.
ExifTool might be perfectly fine opening a file with a Japanese name on a Japanese codepage system,
but may or may not open the file on a system with a chinese code page.
So in order to minimize the number of file renames,
I wrote the following Win32 C++ function that determines file name compatibility:

```
BOOL IsConvertibleText( PCWSTR sFile )
{
    if ( !sFile )
        return FALSE;

    int iBuffer = WideCharToMultiByte( CP_ACP, 0, sFile, -1, NULL, 0, NULL, NULL );
    if ( iBuffer == 0 )
        return FALSE;
    iBuffer += 1;
    PSTR a = (PSTR)HeapAlloc( GetProcessHeap(), 0, iBuffer );
    if ( !WideCharToMultiByte( CP_ACP, 0, sFile, -1, a, iBuffer, NULL, NULL ) )
        return FALSE;
    iBuffer = MultiByteToWideChar( CP_ACP, 0, a, -1, NULL, 0 );
    if ( iBuffer == 0 )
        return FALSE;
    iBuffer = ( iBuffer + 1 ) * sizeof(WCHAR);
    PWSTR w = (PWSTR)HeapAlloc( GetProcessHeap(), 0, iBuffer );
    if ( !MultiByteToWideChar( CP_ACP, 0, a, -1, w, iBuffer ) )
        return FALSE;
    HeapFree( GetProcessHeap(), 0, a );
    BOOL bRet = FALSE;
    if ( CompareStringW( LOCALE_SYSTEM_DEFAULT, 0, sFile, -1, w, -1 ) == CSTR_EQUAL )
        bRet = TRUE;
    HeapFree( GetProcessHeap(), 0, w );
    return bRet;
}
```

For those using C#:

```
bool IsConvertibleText( string sFile )
{
    byte[] b = Encoding.Default.GetBytes( sFile );
    string s = Encoding.Default.GetString( b );
    return sFile.Equals( s, StringComparison.CurrentCulture );
}
```

If the above function fails, files need to be renamed prior to opening with ExifTool.
Alternatively you could use a simple CreateFileA() in C and see if it succeeds.
There is one last workaround in my mind that does not require temporary files:
if you could add an option to write the modified image to stdout, we could use the following in Windows:

```
type some_incompatible_file_name.jpg | exiftool.exe -UserComment=abc -write_to_stdout ->some_incompatible_file_name.jpg
```

I am piping a file into stdin and redirect stdout to a file. Off course this could include error handling if used from within another program.
Thanks!
Christian Etter

Posted on 2009-05-13 18:47:54-07 by exiftool in response to 10692

Hi Christian,

Thanks for the details. This is very useful information.

ExifTool can be used in a pipe exactly as you specified by using "-" as the file name.
(See the PIPING examples in the exiftool app docs.), so you can already do this.


- Phil

Posted on 2009-05-13 19:32:24-07 by ce in response to 10694

Great! Something that might work as well.
Chris

Posted on 2009-09-05 11:15:10-07 by tni in response to 10677

Phil, while the complete Win32API module isn't included with standard Perl, Win32API::File is.

That being said, the library interface/ExtractInfo() works fine with a file handle opened
via Win32API::File::CreateFileW (good enough for me anyway).

There is an open bug for the Perl Unicode file handling on Win32 (which will hopefully get fixed eventually):
http://rt.perl.org/rt3/Public/Bug/Display.html?id=60888

-- Tilo


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/10658 -->

