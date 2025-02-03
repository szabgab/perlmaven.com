---
title: "Image::ExifTool IPTC UTF-8 Support?"
timestamp: 2006-04-07T03:43:45
tags:
  - Image::ExifTool
published: true
archive: true
---



Posted on 2006-04-07 03:43:45-07 by pdi

According to IIM v4.1 ("IPTC headers") specs, ch. 5 Envelope Record, 1:90 Coded Character Set,
there seems to be a provision for utf-8 support.
I understand this is not often implemented due both to implementation difficulties
and native utf-8 support in XMP. I've read ExifTool's documentation but
I couldn't find anything on this. Is utf-8 for IPTC supported? Many thanks in advance.

Posted on 2006-04-07 13:05:23-07 by exiftool in response to 2114

Yes, you can write UTF-8 to IPTC using ExifTool.
If you do this, you are responsible for setting the value the CodedCharacterSet tag to "ESC % G",
this is not done automatically.
(Note: Use this exact string -- ExifTool translates to the proper byte sequence for the escape code.)

Posted on 2006-04-07 14:15:20-07 by pdi in response to 2115

Thank you for the reply. ExifTool never ceases to amaze me with what it can do.
I'm still having some difficulty. Here's what I do: 1. make a txt file with all the iptc tags needed,
including the line "-iptc:CodedCharacterSet=ESC % G" 2. pass the file to exiftool using the -@ ARGFILE.
The resulting jpg's iptc is not in utf-8. Must the txt file be in utf-8 encoding to begin with?
If yes, what is the use of CodedCharacterSet?

Posted on 2006-04-07 16:27:29-07 by exiftool in response to 2117

Perhaps I could have been a bit more clear: You can write IPTC strings
containing any arbitrary series of bytes using ExifTool. It is up to you to encode
them with the desired character set. ExifTool does not translate IPTC character strings.
So to write UTF-8, the values that you assign must be valid UTF-8 byte sequences.

The value of setting CodedCharacterSet is that it informs other applications that
your IPTC strings contain UTF-8 characters. As far as ExifTool is concerned though
it doesn't matter, because ExifTool places the translation in your hands.

So maybe you shouldn't be so amazed after all... ;)

- Phil

Posted on 2006-04-07 18:10:53-07 by pdi in response to 2121

Phil, This is crystal clear, many thanks for your clarification :-) Pandelis

Posted on 2006-04-11 06:45:41-07 by pdi in response to 2122

Phil,

Just one last point. Googling around I came across 3 different versions of
the 1:90 utf-8 escape sequence. Does it make any difference which string is used,
or can ExifTool interpret all of them?

```
1. "ESC % G", from your previous reply
2. "ESC %G", from Markus Kuhn's "UTF-8 and Unicode FAQ for Unix/Linux"
3. "ESC%G", from a post by the author (I think) of PictureSync
```

TIA
Pandelis

Posted on 2006-04-11 11:43:40-07 by exiftool in response to 2144

The actual hex byte sequence that must be written to the file is 0x1b 0x25 0x47 (3 bytes).

ExifTool converts "ESC " to 0x1b only if there is a space after "ESC".
Then it packs the remaining bytes by removing spaces and commas. Note that '%' = 0x25 and 'G' = 0x47.

So with your examples, either 1 or 2 will work, but 3 will not because
of the way that ExifTool translates the escape character.

Posted on 2007-04-15 15:00:57-07 by linuxuser in response to 2146

-IPTC:CodedCharacterSet="ESC % G" works for me, but why can't it be defined with -IPTC:CodedCharacterSet="UTF-8" (it doesn't work here)? I was a little bit confused with the FAQ #10, because it says: If CodedCharacterSet exists and has a value of "UTF8" (or "ESC % G") ...
Direct Responses: 4878 | Write a response
Posted on 2007-04-15 15:14:25-07 by exiftool in response to 4877
Re: IPTC UTF-8 Support?
-IPTC:CodedCharacterSet=UTF8 (not UTF-8) works again as of version 6.86 (somehow this feature got broken before this version).

IPTC uses the ISO 2022 standard for alternate character sets, and character sets are specified
via a sequence of escape characters. For UTF-8, the escape sequence is "ESC % G",
and for convenience ExifTool allows you to also specify "UTF8" which is
translated to the appropriate escape sequence internally.

You can use the -n option to bypass this translation to see actual escape sequence
(but in this case, the "ESC" character will appear as a "." because all control characters
are converted to "." in the output. But you can add the -b option to prevent
this conversion too if you want.)

I hope this makes sense.

- Phil


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/2114 -->


