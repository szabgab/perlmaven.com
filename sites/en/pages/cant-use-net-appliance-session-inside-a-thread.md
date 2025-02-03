---
title: "Can't use Net::Appliance::Session inside a thread"
timestamp: 2008-01-22T12:41:21
tags:
  - Net::Appliance::Session
  - threads
published: true
archive: true
---



Posted on 2008-01-22 12:41:21-08 by miky

Hello, I'm not sure it's a Net::Appliance::Session related problem but I just wanted to have your opinion.
So far I'm using Net::Telnet and Net::Telnet::Cisco and threads, everything is working fine.
When I use Net::Appliance::Session launched by a thread it segfaults.
I wrote this little script that reflects my problem and which is more simple that the script I use.

```perl
#!/usr/bin/perl

use Net::Appliance::Session;
use threads;
use threads::shared;

$ip='10.1.1.1';
$host='ROUTER1';
$pf='MyPTF';
$device='cisco_router';
$connexion='ssh';
$login='miky';
$pass='mypass';
$enable='';
my $num_threads : shared = 0;
my $max_thread = 1;

while ($num_threads >= $max_thread)
{
  print "$num_threads thread(s) actifs: nombre de threads maximal autorise atteint\n";
  sleep 2;
}
$num_threads++;

my $thr = threads->new('net_ssh_cisco', $ip, $host, $pf, $device, $login, $pass, $enable);
$thr->detach();
sleep 2;

sub net_ssh_cisco
{
  my ($ip, $host, $pf, $device, $login, $pass, $enable) = @_;
  my $session;

  eval { $session = Net::Appliance::Session->new( Host => $ip, Transport => 'SSH' ); };
  if ($@)
  {
    print "$@\n";
    print "$host injoignable\n";
    $num_threads--;
    return;
  }
  print "Connexion effective\n";

  eval { $session->connect(Name=>$login, Password=>$pass); }; # <<< Problem is here
  if ($@)
  {
    print "$@\n"; # <<< Debug message
    print "$host probleme de password\n"; # <<< Debug message
    return;
  }
  print "Logged on ";
  print "$host\n";
  $session->close;

  $num_threads--;
}
```

When I execute the script

```
$ ./debugthread.pl

Connexion effective
Failed to get first prompt at ./debugthread.pl line 58
ROUTER1 probleme de password
Segmentation fault
```

It seems that this message comes from Net/Appliance/Session/Transport/SSH.pm


```perl
my $match;
(undef, $match) = $self->waitfor($self->pb->fetch('userpass_prompt'))
            or $self->error('Failed to get first prompt');
```

When I don't use threads it works, with threads it doesn't.
Do you have an idea of what happens or could you point out a direction that could help ? Thanx

Posted on 2008-01-31 22:33:06-08 by oliver in response to 6909

Hi Miky,

I don't have a lot of experience with threads, but I did run your sample program
(thanks for that!) and made a little investigation.

My best guess is that this is a problem with the Net::Telnet module.
My reason for reaching this conclusion is that the error message returned,
"Failed to get first prompt", is returned *immediately* after the connect() method is called.
There should be a 10 second timeout on this, waiting for the prompt.
The timeout actually happens within the waitfor() method of Net::Telnet,
so I think it's this which is not thread safe. For some reason it does not wait 10 seconds
but instead returns immediately with a failure. Perhaps it is some problem with signal handling?

Unfortunately, the loop which has the "broken" timeout in Net::Telnet is generated code,
so it's hard to debug, and also because I am not an experienced threads programmer
I wouldn't know where to start anyway.

For now, I think we are going to have to say that Net::Appliance::Session is not thread safe,
because of this problem. I'm very sorry about that.

regards,
oliver.

Posted on 2008-02-01 00:37:14-08 by onishin in response to 6985

I have same pb for mode Telnet . My solution is run another process perl for just one connexions.
1 Have 1 script ( Main ) run Many another for processe Net:Telnet Main:

```perl
foreach my $id (@routeur) { exec child.pl $id ; }
```


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/6909 -->


