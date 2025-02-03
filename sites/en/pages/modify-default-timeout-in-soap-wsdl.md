---
title: "Modify default timeout in SOAP::WSDL"
timestamp: 2008-04-30T15:25:54
tags:
  - SOAP::WSDL
published: true
archive: true
---




Posted on 2008-04-30 15:25:54-07 by oly

Hi,

I could not find documentation on how to set a given timeout in a client. I was using

```perl
$soap->proxy($proxy, timeout => 1000);
```

previously. But this relied on SOAP::Lite, isn't it? Is it still possible with SOAP::WSDL 2 ?

Olivier

Posted on 2008-05-03 00:01:44-07 by noah in response to 7799

A proxy() method is provided for backwards compatibility; running this:

```perl
my $soap = MyInterfaces::MyService::ServicePort->new();
$soap->proxy($proxy, timeout => 1);
```

...against simple server which sleeps for 5 seconds when processing
a request results in a timeout after ~1s. If you wish to bypass the
backward compatibility, you can do retrieve the transport object and
set the timeout on it, like this:

```perl
my $soap = MyInterfaces::MyService::ServicePort->new();
$soap->get_transport()->timeout(1);
```

Noah

Posted on 2008-05-20 13:23:56-07 by oly in response to 7808

Great, it works. Thanks!

Posted on 2008-05-25 19:32:27-07 by drfrog in response to 7808

i too would like to set the timeout. im not using the full interface though.
if im making a call like this:

```perl
my $service = SOAP::WSDL->new( wsdl => $wsdl );
```

how would i get/set the timeout off of that? ive looked around and cant seem to find anything relevant. thanks

Posted on 2008-05-25 20:32:41-07 by mkutter in response to 7928

I actually missed this - you need a fixed version of SOAP/WSDL.pm
from http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL.pm
With this version, you can set the timeout by passing additional arguments to the
proxy() or set_proxy() methods like

```perl
my $soap = SOAP::WSDL->new( wsdl => 'WSDL.wsdl');
$soap->proxy('http://example.org', timeout => 512);
```

Martin

Posted on 2008-05-25 22:16:00-07 by drfrog in response to 7930

hmm i wasnt setting the proxy. this is an extra step is there anyway to get this to by like

```perl
my $soap = SOAP::WSDL->new( wsdl => 'WSDL.wsdl' , timeout=> 120);
```

ps: since i need to set the proxy.. is the proxy always the root of the wsdl?
for instance the wsdl
https://im.a.website.com/servicedir/wsdl/wsdl.wsdl
would be https://im.a.website.com/servicedir

Posted on 2008-05-26 18:54:09-07 by mkutter in response to 7934

Ah, no, the proxy is actually the soap:address location attribute
from the port definition like this:

```
<wsdl:port name="NewPort" binding="tns:NewBinding">
<soap:address location="http://www.example.org/"></soap:address> </wsdl:port>
```

You can set the timeout like this, too (only with the updated SOAP::WSDL):

```perl
$soap->wsdlinit(); $soap->get_client()->get_transport()->timeout(360);
```

Posted on 2008-05-27 17:54:28-07 by drfrog in response to 7940

when are those changes going to hit cpan? also can one do this
(with your updated WSDL.pm):

```perl
my $soap=SOAP::WSDL->new(wsdl=>$wsdl);
$soap->wsdlinit();
$soap->get_client()->get_transport()->timeout(360);
```

Posted on 2008-05-27 19:08:20-07 by mkutter in response to 7948

... usually within a week or two - it just depends on how much spare time I have,
and how boring the rest of my life is (should I note that there *is* a life ? ;-)


(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/7799 -->

