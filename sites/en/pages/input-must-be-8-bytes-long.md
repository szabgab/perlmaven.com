---
title: "input must be 8 bytes long at DES.pm line 58. while using Net::SFTP"
timestamp: 2006-05-01T21:05:05
tags:
  - Net::SFTP
  - utf8
published: true
archive: true
---



Posted on 2006-05-01 21:05:05-07 by arul

I have integrated NET:SFTP module and trying test the "sftp put" functionality.

```perl
put($lclfile, "$remfile");
```

Occasionally I get this error <b>"input must be 8 bytes long at DES.pm line 58."</b>.

When I execute the same command next time the sftp put works fine.
Any clue?

Posted on 2006-05-02 19:09:54-07 by arul in response to 2224

More precisely I get this error first time after SFTP setup.After exchanging the keys. Please help..

Posted on 2006-07-03 05:30:56-07 by lyask in response to 2226

Hi arul, Have you resolved this issue yet? I also encountered this problem when using Net-SFTP. i
It seems wired and I can't find the exactly solution to it.
-Leo

Posted on 2006-08-03 12:18:18-07 by rahed in response to 2569

Possible culprit could be encoding. Your input has to have characters 8 byte long.
If it's in e.g. utf8, change it this way: from_to ($input,'utf8','iso-8859-1')
where from_to must be imported from Encode module. Radek

Posted on 2007-02-27 16:18:58-08 by jestill in response to 2747

I was having the same problem when sending a User Password that was taken from the command line.
The following code worked for me:

```perl
use utf8;
# .. MORE CODE HERE ..
# GET USER PASSWORD
print "\nPassword for $UserName\n";
system('stty', '-echo') == 0 or die "can't turn off echo: $?";
my $UserPassword = <STDIN>;
system('stty', 'echo') == 0 or die "can't turn on echo: $?";
chomp $UserPassword; # Remove newline character
# Convert to utf8 to avoid problem with DES.pm module
utf8::encode ($UserPassword);

# THE SFTP CONNECTION THEN WORKS AS
$sftp = Net::SFTP->new(
    $IndTarget,
    user=> $UserName,
    password=> $UserPassword,
    debug=>"true",
);
```

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/2224 -->


