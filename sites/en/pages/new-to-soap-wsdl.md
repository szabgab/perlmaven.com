---
title: "New to SOAP::WSDL"
timestamp: 2009-12-09T15:20:40
tags:
  - SOAP::WSDL
published: true
archive: true
---



Posted on 2009-12-09 15:20:40-08 by dklein06

Hi All

wsdl2perl.pl worked well for me under Ubuntu karmic
I also succeed nicely in placing a request over https

The place where I am a bit at a loss is how:
1) use the response of the server (aka how to access various
fields in header and body of the soap response

2) how to influence the header of the request, I need to insert a SessionToken
Any pointer to documentation or sample code would be greatly appreciated

Kind Regards

Posted on 2009-12-09 16:52:00-08 by dklein06 in response to 11901

Hey, I did progress!

In this forum there is the [magic thread](/soap-wsdl-retrieving-output)

That is enough hints for me to get started getting values out of my responses
Leaving me with the problem of inserting a value into my request header
So I do not close question completely yet Thanks

Posted on 2009-12-10 16:00:06-08 by dklein06 in response to 11902

Hi I did progress again, and solved my issues/questions so far
I will post here a little example based on the Betfair public API,
hopping it will help the next ones wanting to try SOAP::WSDL

follow instruction and have SOAP::WSDL installed on your box.
also install the Crypt::SSLeay package as API is using HTTPS.

then from command line of your box:

```
perl wsdl2perl.pl -b ./w2p https://api.betfair.com/global/v3/BFGlobalService.wsdl
```

then go into the subdir w2p and run following script

```perl
#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use MyInterfaces::BFGlobalService::BFGlobalService;

my $bfs = MyInterfaces::BFGlobalService::BFGlobalService->new(
     );


print "\n ... going to log in now!\n";
#$bfs->no_dispatch( 1 );
my $sres = $bfs->login( {
     request => {
       username => 'your_betfair_id',
       password => 'your_betfair_pwd',
       productId=> 82
       }
     }
     );
die $sres if not $sres;
print $sres;
print Dumper $sres->as_hash_ref();
print "\n\n\n";

my $obj = $sres->get_Result()->get_errorCode();
print "$obj \n";

my $validUntil = $sres->get_Result()->get_validUntil();
print "$validUntil \n";

my $sesstoken = $sres->get_Result()->get_header()->get_sessionToken();
print "$sesstoken \n";



print "\n ... going to send a keepAlive\n";
# $bfs->no_dispatch( 1 );
my $resp = $bfs->keepAlive (
    { request => { header => { sessionToken => $sesstoken } } }
);

die $resp if not $resp;
print $resp;
print Dumper $resp->as_hash_ref();
print "\n\n\n";

print $resp->get_FOO();
```

this will give you following output:


```
dom@dom-inspiron:~/Soap-Wsdl-Betfair/sources/w2p$ perl ../test3.pl

 ... going to log in now!
<loginResponse xmlns="http://www.betfair.com/publicapi/v3/BFGlobalService/"><Result><header xmlns="
"><errorCode>OK</errorCode><minorErrorCode xmlns=""></minorErrorCode><sessionToken xmlns="">tiZEmQ
AidIWYbdWe9JLWjptwRH8hLzmpRuARujm1M=</sessionToken><timestamp xmlns="">2009-12-10T16:40:50.081Z</t
imestamp></header><currency xmlns="">EUR</currency><errorCode xmlns="">OK</errorCode><minorErrorCo
de xmlns=""></minorErrorCode><validUntil xmlns="">0001-01-01T00:00:00.000Z</validUntil></Result></
loginResponse>$VAR1 = {

          'Result' => {                                                                           
                        'currency' => 'EUR',                                                      
                        'validUntil' => '0001-01-01T00:00:00.000Z',                               
                        'errorCode' => 'OK',                                                      
                        'minorErrorCode' => undef,                                                
                        'header' => {                                                             
                                      'sessionToken' => 'tiZEmQAidIWYbdWe9JLWjptwRH8hLzmpRuARujm1M=
                                      'errorCode' => 'OK',                                        
                                      'timestamp' => '2009-12-10T16:40:50.081Z',                  
                                      'minorErrorCode' => undef                                   
                                    }                                                             
                      }                                                                           
        };                                                                                        

OK
0001-01-01T00:00:00.000Z
tiZEmQAidIWYplbdWe9JLWjptwRH8hLzmpRuARujm1M=

 ... going to send a keepAlive
<keepAliveResponse xmlns="http://www.betfair.com/publicapi/v3/BFGlobalService/"><Result><header xml
ns=""><errorCode>OK</errorCode><minorErrorCode xmlns=""></minorErrorCode><sessionToken xmlns="">ti
ZEmQAidIWYbdWe9JLWjptwRH8hLzmpRuARujm1M=</sessionToken><timestamp xmlns="">2009-12-10T16:40:51.225
Z</timestamp></header><apiVersion xmlns=""></apiVersion><minorErrorCode xmlns=""></minorErrorCode>
</Result></keepAliveResponse>$VAR1 = {                                     
          'Result' => {                                                                           
                        'minorErrorCode' => undef,                                                
                        'apiVersion' => undef,                                                    
                        'header' => {                                                             
                                      'sessionToken' => 'tiZEmQAidIWYbdWe9JLWjptwRH8hLzmpRuARujm1M=
                                      'errorCode' => 'OK',                                        
                                      'timestamp' => '2009-12-10T16:40:51.225Z',                  
                                      'minorErrorCode' => undef                                   
                                    }                                                             
                      }                                                                           
        };                                                                                        


Can't locate object method "get_FOO" via package "MyElements::keepAliveResponse".
Valid methods are: get_Result, set_Result                                        
 at /usr/local/share/perl/5.10.0/SOAP/WSDL/XSD/Typelib/ComplexType.pm line 68    
        SOAP::WSDL::XSD::Typelib::ComplexType::AUTOMETHOD('MyElements::keepAliveResponse=SCALAR(0x9
b01d00)', 162536704) called at /usr/local/share/perl/5.10.0/Class/Std.pm line 546                
                                                                                                 
                  
Class::Std::AUTOLOAD('MyElements::keepAliveResponse=SCALAR(0x9b01d00)') called at ../test3.  pl line 49    
```

This small example should give you some hints about getting return values,
about putting a value in the body or header segment of a soap request.

I did not make the complete use of the power of SOAP::WSDL yet,
but have to say: ... THANK YOU MARTIN! Nice clean job all around.

Hoping this post may help others to find the first leads into this module
Tchao!

Posted on 2009-12-21 01:28:57-08 by denman in response to 11909

Thanks for this example though I tried to retrieve the WSDL file for the Betdaq API also at:

https://api.betdaq.com/v2.0/API.wsdl
using the command:

```
wsdl2perl.pl -b ./w2p https://api.betdaq.com/v2.0/API.wsdl
```

And it complains horribly with lots of the following:

```
Deep recursion on anonymous subroutine at /usr/lib/perl5/Template/Document.pm line 155.
```

Failing to build the necessary directory structure. Any ideas?

Posted on 2009-12-21 07:48:13-08 by dklein06 in response to 11996

Hi
As I said in previous email I am a newcomer to Soap::Wsdl
But to get my example working I had to read through the whole forum
And there you find:

That <a href="/soap-wsdl-deep-recursion-warning-while-using-wsdl2perl">looks</a to me as
applying to your case

Good Luck

Posted on 2009-12-21 21:27:38-08 by denman in response to 11997

Thanks for the good pointer - this indeed avoided the recursion issue.
However another issue has become apparent in that not all subdirectories and functions
are created - so only MyTypes and MyInterfaces, not MyElements.
It looks like [someone else has had](/soap-wsdl-deep-recursion-warning-while-using-wsdl2perl) this problem though I can't see a reply to it.

Any idea how to get all directories? I'll also cross post to their thread.
Nb: If you are interested in betting exchange APIs, the Betdaq one is also free so you can see the issues for yourself:
https://api.betdaq.com/v2.0/API.wsdl

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/11901 -->

