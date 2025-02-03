---
title: "Net::SSH::Perl: Channel open failure: 1: reason 4: when connecting to Cisco router "
timestamp: 2005-08-06T21:04:35
tags:
  - Net::SSH::Perl
published: true
archive: true
---





Posted on 2005-08-06 21:04:35-07 by mdetreville

The script below is trying to connect to a Cisco router,
and is giving the error messages that follow.
The same code when aimed at a linux server, changing only the host,
user, password and command works fine. Any suggestions are appreciated.

```perl
use strict;
use Net::SSH::Perl;
use Net::SSH::Perl::Cipher;
my $port = "ssh";
my $host ="xxx.xx.x.x";
my $user = "xxxxxxxxx";
my $pass = "xxxxxx";
my $cmd = "show version";
my $ssh = Net::SSH::Perl->new($host,
debug => 1);
$ssh->login($user, $pass);
my($out, $err) = $ssh->cmd($cmd);
```

```
root@ivan #./test.pl
Reading configuration data /root/.ssh/config
Reading configuration data /etc/ssh_config
Allocated local port 1023.
Connecting to XXX.XXX.XXX port 22
Remote protocol version 2.0, remote software version Cisco-1.25
Net::SSH::Perl Version 1.28, protocol version 2.0.
No compat match: Cisco-1.25.
Connection established.
Sent key-exchange init (KEXINIT), wait response.
Algorithms, c->s: 3des-cbc hmac-sha1 none
Algorithms, s->c: 3des-cbc hmac-sha1 none
Entering Diffie-Hellman Group 1 key exchange.
Sent DH public key, waiting for reply.
Received host key, type "ssh-rsa".
Host "172.20.6.3" is known and matches the host key.
Computing shared secret key.
Verifying server signature.
Waiting for NEWKEYS message.
Enabling incoming encryption/MAC/compression.
Send NEWKEYS, enable outgoing encryption/MAC/compression.
Sending request for user-authentication service.

Service accepted: ssh-userauth.
Trying empty user-authentication request.
Authentication methods that can continue: password.
Next method to try is password.
Trying password authentication.
Login completed, opening dummy shell channel.
channel 0: new [client-session]
Requesting channel_open for channel 0.
channel 0: open confirm rwindow 1024 rmax 4096
Got channel open confirmation, requesting shell.
Requesting service shell on channel 0.
channel 1: new [client-session]
Requesting channel_open for channel 1.
Entering interactive session.
Channel open failure: 1: reason 4:
```

Posted on 2005-10-03 17:24:12-07 by mcmeel in response to 851

I am experiencing the same trouble, and believe to have narrowed
it down to the request for a new channel, and Cisco's SSH implementation
not supporting multiple channels on an SSH connection. I have emailed
the listed maintainer and included some supporting debugging and troubleshooting.
I was unable to find a method in the code that would specify to use the existing
channel for the cmd() call, but not being very proficient with perl I may have overlooked something.

Posted on 2005-11-03 02:05:48-08 by neilb in response to 1112

Did either of you figure this out? I just came across this issue trying to use Net-SSH-Perl
to maintain some routers, and am curious if you got anywhere with it.

Posted on 2005-11-25 19:16:35-08 by markspace in response to 1278

I found that if I limited my Cisco routers to version 2 ssh (global "ip ssh version 2"),
they couldn't support the connection. What this really means is it appears their reportedly
"openSSH derived" version 2 isn't fully compatible, and thus, you have to fall back
to version 1 support. I encourage you to file a bug report with Cisco,
since this Perl module works with all other major router vendors.
Alternatively, you could make this a future procurement requirement,
and products which do not pass are disqualified
(I know: that doesn't solve our problem with equipment we already have).
That's language Cisco does usually understand, even if you're not buying 00's or 000's of units.

-- Mark

Posted on 2006-01-17 20:17:02-08 by dandrown in response to 851

As mentioned later in this thread, the problem in the routers is opening a second channel.

I had the same problem with ssh'ing to PIXes, and to get them working,
I made the following changes to Net::SSH::Perl::SSH2:

sub login -> removed the code to open a "dummy channel"

sub client_loop -> change the check "last unless $oc > 1;" to "last unless $oc > 0;"

After making these changes, I am now able to open a Net::SSH::Perl connection to a PIX
configured to only support ssh2. I'm not quite sure why the dummy channel is needed,
perhaps servers disconnect once the channel count goes to 0.

Posted on 2006-01-30 14:48:10-08 by maestro in response to 1630

Thanks dandrown!

I had exactly the same problem connecting by ssh to a CISCO router,
and making those changes in SSH2.pm completely solved the problem!!!

Thank you very very much.

Posted on 2006-02-02 11:09:00-08 by maestro in response to 1718

While doing these changes gets Net::SSH::Perl to work with Routers Cisco,
now I am unable to execute multiple commands.

For example, I execute:

```perl
($stdout, $stderr, $exit) = $ssh->cmd("show version");
```

And the output is:

```
MyMachine: channel 0: new [client-session]
MyMachine: Requesting channel_open for channel 0.
MyMachine: Entering interactive session.
MyMachine: Sending command: show ver
MyMachine: Requesting service exec on channel 0.
MyMachine: channel 0: open confirm rwindow 1024 rmax 4096
MyMachine: input_channel_request: rtype exit-status reply 0
MyMachine: channel 0: rcvd eof
MyMachine: channel 0: output open -> drain
MyMachine: channel 0: rcvd close
MyMachine: channel 0: input open -> closed
MyMachine: channel 0: close_read
MyMachine: channel 0: obuf empty
MyMachine: channel 0: output drain -> closed
MyMachine: channel 0: close_write
MyMachine: channel 0: send close
MyMachine: channel 0: full closed
```

Then I execute:

```perl
($stdout, $stderr, $exit) = $ssh->cmd("show run");
```

And the output is:

```
MyMachine: channel 1: new [client-session]
MyMachine: Requesting channel_open for channel 1.
```

...and the process stops.

What can I do to execute multiple commands, while preventing the
"Channel open failure: 1: reason 4:" error??? Is it possible??

```perl
($stdout, $stderr, $exit) = $ssh->cmd("show version");
($stdout, $stderr, $exit) = $ssh->cmd("show run");
```

Thanks!

Posted on 2006-06-20 08:27:27-07 by cjenn75 in response to 1630

I am really battling to get this to work as you described.
I am unable to run any commands at all, it appears to be referencing other
parts of the script which i cant identify. Can you please post the exact
lines i should comment out? Here is my 'sub login':

```perl
sub login {
    my $ssh = shift;
    $ssh->SUPER::login(@_);
    my $suppress_shell = $_[2];
    $ssh->_login or $ssh->fatal_disconnect("Permission denied");
    # $ssh->debug("Login completed, opening dummy shell channel.");
    # my $cmgr = $ssh->channel_mgr;
    # my $channel = $cmgr->new_channel(
        # ctype => 'session', local_window => 0,
        # local_maxpacket => 0, remote_name => 'client-session');
    # $channel->open;
    # my $packet = Net::SSH::Perl::Packet->read_expect($ssh,
        # SSH2_MSG_CHANNEL_OPEN_CONFIRMATION);
    # $cmgr->input_open_confirmation($packet);

    # unless ($suppress_shell) {
        # $ssh->debug("Got channel open confirmation, requesting shell.");
        # $channel->request("shell", 0);
    # }
}
```

This seemingly allows me to login (it successfully authenticates to tacacs)
but this is as far as i get to being able to run a command:

```
....
Authentication methods that can continue: password.
Next method to try is password.
Trying password authentication.
channel 0: new [client-session]
Requesting channel_open for channel 0.
Entering interactive session.
Sending command: ls
Requesting service exec on channel 0.
channel 0: open confirm rwindow 1024 rmax 4096
```

and that's all.

When i uncomment the hashed lines in sub login and attempt to auth to a unix host i get this:

```
....
Authentication methods that can continue: publickey,gssapi-with-mic,password.
Next method to try is publickey.
Next method to try is password.
Trying password authentication.
Login completed, opening dummy shell channel.
channel 0: new [client-session]
Requesting channel_open for channel 0.
channel 0: open confirm rwindow 0 rmax 32768
Got channel open confirmation, requesting shell.
Requesting service shell on channel 0.
channel 1: new [client-session]
Requesting channel_open for channel 1.
Entering interactive session.
Sending command: ls
Requesting service exec on channel 1.
channel 1: open confirm rwindow 0 rmax 32768
channel 1: rcvd eof
channel 1: output open -> drain
input_channel_request: rtype exit-status reply 0
channel 1: rcvd close
channel 1: input open -> closed
channel 1: close_read
channel 1: obuf empty
channel 1: output drain -> closed
channel 1: close_write
channel 1: send close
channel 1: full closed
```

So everything from rcvd eof downwards is being skipped,
nothing is being outputted to $stdout so am not able to see output of command.
Any help you can provide would be great. Thanks!

Posted on 2006-07-23 20:46:34-07 by samvong in response to 1745

I am having the same problem executing multiple commands.
Did anyone find a way to do this? If so, could you please let me know? thanks.
I want to be able to do this too. 

```perl
($stdout, $stderr, $exit) = $ssh->cmd("show version");
($stdout, $stderr, $exit) = $ssh->cmd("show run");
($stdout, $stderr, $exit) = $ssh->cmd("show snmp");
```

Posted on 2007-05-16 23:56:02-07 by hsl in response to 1745

Could you share with us your perl script?
I am using a different router, but have a similar problem with a single
command let alone multiple commands. Thanks.

Posted on 2007-12-11 06:32:02-08 by udk in response to 5156

I am also facing this issue even after commenting out the suggested codes.
Has anyone got this issue resolved. Please share your perl file or suggest the steps taken by you. Thanks

Posted on 2007-12-11 12:06:14-08 by hubbard in response to 6665

Bad news from here. I could not get it to work and so redid everything with Expect.
That is working fine for me.

Posted on 2007-12-11 17:53:57-08 by udk in response to 6666

oh ok :) did you use Perl's expect or TCL ??
And also would like to know if you were connecting to Cisco Router by any chance...
Because I see Cisco Boxes typically allow only one Channel to
be open and that seems to be the problem I am facing..

Posted on 2007-12-11 18:04:57-08 by hubbard in response to 6667

I used Perl's expect and yes - Cisco Routers are my trouble makers.
Net-SSH-Perl worked fine on the Cisco unless the Cisco had to use ssh-v2.

Posted on 2007-12-11 18:19:46-08 by udk in response to 6668

Hi, Thank you so much for replying. Can you please explain me how you used Perl's Expect ?
If you have some sample script, is it possible for you to share that with me @ udk@cisco.com
Yes the box which I am trying to talk uses SSHv2 but then only one connection can
be opened at a time but from the library implementation I could see multiple channel opens are done,
so I assumed that could be the reason why I am getting errored out.
If possible share your email id so that I can get the further assistance from you.
Thanks In Advance for any kind of help provided.

Posted on 2008-01-10 15:22:11-08 by challman in response to 6669

I've had similar problems with Python. I opened a case with Cisco's TAC.
They created a Perl script for me. I was able to get it working. Here it is:

```perl
#!/usr/bin/perl
use Net::Appliance::Session;
my $s = Net::Appliance::Session->new( Host => '10.100.3.254', Transport => 'SSH', );
$s->connect( Name => 'cworks', Password => 'Activ8' );
print $s->cmd('show dialer | i :');
print "*********************\n**********************\n";
print $s->cmd('show ISDN stat | i ACTIV');
print "*********************\n**********************\n";
print $s->cmd('show ip eigrp nei');
$s->close;
```

Maybe it will help you.

Posted on 2008-04-23 17:39:17-07 by yjlandr in response to 2678

Greeting,

were you ever able to send multiple commands to the router?
Let me know.

Posted on 2008-04-23 17:48:38-07 by hubbard in response to 7735

No - sorry to say. I bailed and went with Expect.

Posted on 2009-08-31 11:39:51-07 by 1wax in response to 2515

Hello,

I am having exactly the same issue you've described here.
Even after commenting out the relevant parts of the SSH.pm module, the code hangs after the following text:

```
channel 0: open confirm rwindow 1024 rmax 4096.
```

Did you ever resolve this issue?
thanks.

Posted on 2009-11-02 07:35:00-08 by flatline in response to 11384

Hello, I'm also having this problem. Did you ever get it working? Thank you.

Posted on 2010-03-01 17:17:22.147164-08 by wzqstudio in response to 1407

would you pls show the details ,how to modify the ssh2.pm

Posted on 2010-03-11 06:07:21.175262-08 by nonozi in response to 12496

install Net::Appliance::Session try this code it works fine

```perl
#!/usr/bin/perl
use strict; use Net::Appliance::Session;
my $host = "nxxxxx";
my $user = "xxxxx";
my $pw = "xxxxx";
my $s = Net::Appliance::Session->new( Host => $host, Transport => 'SSH', );
$s->connect( Name => $user, Password => $pw );
print $s->cmd('show version');
print "*******************************************\n";
#$s->do_configure_mode;
$s->begin_configure;
print $s->cmd('no access-list 50 permit x.x.x.x');
$s->end_configure;
print $s->cmd('show running-config');
print "*******************************************\n";
$s->close;
```


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/851 -->

