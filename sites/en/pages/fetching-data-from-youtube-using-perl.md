---
title: "Fetching data from YouTube using Perl"
timestamp: 2014-07-09T08:45:56
tags:
  - YouTube
  - WebService::GData
  - WebService::GData::YouTube
  - Email::Send::SMTP::Gmail
  - email
types:
  - screencast
published: true
author: szabgab
---


As I am trying to follow how [my screencasts](https://www.youtube.com/gabor529)
are doing on YouTube I keep visiting the web site checking out the number of subscribers
and the number of views of the videos. It's getting a bit boring so I thought I should
automate it.


{% youtube id="a03jf68iz-M" file="youtube_api.mp4" %}

YouTube provides an [API](http://code.google.com/apis/youtube/overview.html)
for a lot of things. I wanted to be able to fetch the statistics of
[my account](https://www.youtube.com/gabor529).

I started by installing the [Padre on Strawberry Perl for Windows](http://padre.perlide.org/)
package but it would work on any other distribution of Perl, and on any other operating system.

Then I went to [Meta CPAN](https://www.metacpan.org/) to search for something related to
<b>Youtube</b> and settled with [WebService::GData](https://metacpan.org/pod/WebService::GData).
I went to the CPAN shell in the Strawberry -> Tools submenu and typed in

```
cpan> install WebService::GData
```

After brief reading of the docs, and some copy-pasting I got this script:

```perl
#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

use WebService::GData::YouTube;
my $yt = WebService::GData::YouTube->new();

my $p = $yt->get_user_profile('gabor529');
say $p->about_me;
my $s = $p->statistics;
say $s->view_count;
say $s->subscriber_count;
#say $s->video_watch_count;
say $s->total_upload_views;
```

This would fetch my user profile - without even logging in to YouTube - and 
print out the statistics. I have 105 subscribers, when I prepared the screencast in June 2011. There are 551 in July 2014.

Then I wanted to send the resulting data to myself via Gmail. Another short search on Meta CPAN
for <b>Gmail</b> and I found [Email::Send::SMTP::Gmail](https://metacpan.org/pod/Email::Send::SMTP::Gmail).
Some more copy pasting and here
is the script that would send an e-mail using my gmail-account to myself. I guess I could use the
same code to send to anyone else as well.

```perl
use Email::Send::SMTP::Gmail;

my $mail=Email::Send::SMTP::Gmail->new( -smtp=>'gmail.com',
                                        -login=>'gabor529@gmail.com',
                                        -pass=>'google and me');

my $text = '';
$text .= "view count " . $s->view_count . "\n";
$text .= "subscribers " . $s->subscriber_count . "\n";
$text .= "total views"   . $s->total_upload_views . "\n";

$mail->send(-to=>'gabor529@gmail.com',
          -subject=>'youtube update',
          -verbose=>'1',
          -body=> $text,
#         -attachments=>'full_path_to_file'
);

$mail->bye;
```

That was all of it. It took me almost 15 minutes to write this! (And 3 more hours to prepare 
the screencast.

ps. That is not really my e-mail address. I was just using it for this demo.

