---
title: "RSA authentication with Net-SFTP"
timestamp: 2009-07-24T10:26:17
tags:
  - Net::SFTP
published: true
archive: true
---



Posted on 2009-07-24 10:26:17-07 by cccc

hi

I've generated RSA key on my Debian Lenny using:

# ssh-keygen -t rsa

and I'd like to use RSA authentication in this perl script:

```perl
#!/usr/bin/perl -w

use strict;
use warnings;

use Net::SFTP;
use Net::SSH::Perl::Auth;

my $server="X.X.X.X";
my $user="user";
my $password="";
my %args = (
     user => "$user",
     ssh_args => {
         identity_files => [ "/home/ssh/id_rsa"],
         protocol=>'2,1'
     }
);
$args{debug} = 1;
$args{user} = "user";
my $file="TEST";
my $sftp=Net::SFTP->new($server, %args) or die "could not open connection to $server\n";
$sftp->put($file, $file) or die "could not upload a file\n";
exit;
```

but I'm getting the following error:


```
srv:# perl sftp.cgi

srv: Reading configuration data /root/.ssh/config
srv: Reading configuration data /etc/ssh_config
srv: Allocated local port 1023.
srv: Connecting to X.X.X.X, port 22.
srv: Remote protocol version 2.0, remote software version 4.0.7.1 SSH Secure Shell Windows NT Server
Math::BigInt: couldn't load specified math lib(s), fallback to Math::BigInt::FastCalc at /usr/local/share/perl/5.10.0/Crypt/DH.pm line 6
srv: Net::SSH::Perl Version 1.34, protocol version 2.0.
.inux.ch.bluee.net: No compat match: 4.0.7.1 SSH Secure Shell Windows NT Server
srv: Connection established.
srv: Sent key-exchange init (KEXINIT), wait response.
srv: Algorithms, c->s: 3des-cbc hmac-sha1 none
srv: Algorithms, s->c: 3des-cbc hmac-sha1 none
srv: Entering Diffie-Hellman Group 1 key exchange.
srv: Sent DH public key, waiting for reply.
Math::BigInt: couldn't load specified math lib(s), fallback to Math::BigInt::FastCalc at /usr/local/share/perl/5.10.0/Crypt/DSA/KeyChain.pm line 6
Math::BigInt: couldn't load specified math lib(s), fallback to Math::BigInt::FastCalc at /usr/local/share/perl/5.10.0/Crypt/DSA/Key.pm line 6
Math::BigInt: couldn't load specified math lib(s), fallback to Math::BigInt::FastCalc at /usr/local/share/perl/5.10.0/Crypt/DSA/Util.pm line 6
srv: Received host key, type 'ssh-dss'.
srv: Host 'X.X.X.X' is known and matches the host key.
srv: Computing shared secret key.
srv: Verifying server signature.
srv: Waiting for NEWKEYS message.
srv: Send NEWKEYS.
srv: Enabling encryption/MAC/compression.
srv: Sending request for user-authentication service.
srv: Service accepted: ssh-userauth.
srv: Trying empty user-authentication request.
srv: Authentication methods that can continue: gssapi,publickey,password.
srv: Next method to try is publickey.
srv: Trying pubkey authentication with key file '/home/ssh/id_rsa'
Key class 'Net::SSH::Perl::Key::RSA' is unsupported: Can't locate Crypt/RSA.pm in @INC (@INC contains: /etc/perl /usr/local/lib/perl/5.10.0 /usr/local/share/perl/5.10.0 /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.10 /usr/share/perl/5.10 /usr/local/lib/site_perl .) at /usr/local/share/perl/5.10.0/Net/SSH/Perl/Key/RSA.pm line 14.
BEGIN failed--compilation aborted at /usr/local/share/perl/5.10.0/Net/SSH/Perl/Key/RSA.pm line 14.
Compilation failed in require at (eval 68) line 1.
BEGIN failed--compilation aborted at (eval 68) line 1.
```

public key id_rsa.pub from the client machine was installed on the sftp server.
The user name is absolutely correct and I can login from the command line to this server and transfer a file without problems.

what's wrong?

Posted on 2009-09-10 19:28:18-07 by darxus in response to 11198

Key class 'Net::SSH::Perl::Key::RSA' is unsupported:

```
Can't locate Crypt/RSA.pm in @INC (@INC contains: /etc/perl
/usr/local/lib/perl/5.10.0 /usr/local/share/perl/5.10.0 /usr/lib/perl5 /usr/share/perl5
/usr/lib/perl/5.10 /usr/share/perl/5.10 /usr/local/lib/site_perl .)
at /usr/local/share/perl/5.10.0/Net/SSH/Perl/Key/RSA.pm line 14.
```

You need to install Crypt::RSA.

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/11198 -->



