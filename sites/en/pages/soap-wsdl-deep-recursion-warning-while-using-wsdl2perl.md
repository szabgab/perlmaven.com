---
title: ""Deep recursion" warning while using wsdl2perl.pl"
timestamp: 2008-12-09T22:54:39
tags:
  - SOAP::WSDL
published: true
archive: true
---



Posted on 2008-12-09 22:54:39-08 by bobbyburgess

when i run wsdl2perl.pl on a Salesforce Enterprise WSDL file (link below),
it gets stuck in an infinite loop while creating Account.pm. here's the output:

```
wsdl2perl.pl -b ./ent_dir/ file:enterprise.wsdl.xml
cannot import document for namespace >urn:enterprise.soap.sforce.com< without location
    at /usr/lib/perl5/site_perl/5.8.8/SOAP/WSDL/Expat/WSDLParser.pm line 81.
cannot import document for namespace >urn:sobject.enterprise.soap.sforce.com< without location
    at /usr/lib/perl5/site_perl/5.8.8/SOAP/WSDL/Expat/WSDLParser.pm line 81.
Creating complexType class MyTypes/sObject.pm
Creating complexType class MyTypes/Account.pm
Deep recursion on subroutine "Template::Context::process"
    at /usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/Template/Context.pm line 403.
Deep recursion on subroutine "Template::Document::process"
    at /usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/Template/Context.pm line 345.
Deep recursion on subroutine "Template::Context::process"
    at /usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/Template/Context.pm line 403.
Deep recursion on subroutine "Template::Document::process"
    at /usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/Template/Context.pm line 345.
Deep recursion on subroutine "Template::Context::include"
    at /usr/lib/perl5/site_perl/5.8.8/SOAP/WSDL/Generator/Template/XSD/element/POD/structure.tt line 5.
Deep recursion on subroutine "Template::Context::process"
    at /usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/Template/Context.pm line 403.
Deep recursion on subroutine "Template::Document::process"
    at /usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/Template/Context.pm line 345.
Deep recursion on subroutine "Template::Context::process"
    at /usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/Template/Context.pm line 403.
Deep recursion on subroutine "Template::Document::process"
    at /usr/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/Template/Context.pm line 345.
Deep recursion on subroutine "Template::Context::include"
    at /usr/lib/perl5/site_perl/5.8.8/SOAP/WSDL/Generator/Template/XSD/element/POD/structure.tt line 5.
(and on and on...)
```

can someone point me in the right direction here? here's the WSDL file i'm using:

http://bobbyburgess.com/enterprise.wsdl.xml

it sounds like something within the WSDL file is leading to some kind of
self-referential loop, but i don't know where to begin. nothing jumps out at me immediately
when i look at the &lt;complexType name="Account"> section of that document. any ideas?
once i figure this out i'd like to post a Salesforce/SOAP::WSDL how-to for the community.

thanks, bobby

Posted on 2008-12-14 17:40:42-08 by mkutter in response to 9527

Hi bobby,

this is a limitation of the current SOAP-WSDL distribution: It does not handle recuresive data structures.
You may want to try the "Typemap" branch from SOAP::WSDL's svn (which will eventually become the 2.1 release):
http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/branches/Typemap/
This branch removes the use of Typemaps (e.g. lookup tables for the XML Element to Perl Class mapping), which do not allow recursive structures.
Note, however, that some bug fixes already included in trunk/ or even a CPAN release might not yet be ported to that branch.

Martin

Posted on 2008-12-15 00:18:26-08 by bobbyburgess in response to 9544

thank you, martin! that was it. the Typemap branch did generate the classes correctly.
afterward, however, i ran into some issues with the Salesforce WSDL file not defining
all types. wasn't sure how to fix that myself (still learning web services and SOAP),
but of course that's not related to SOAP::WSDL. thanks again for the advice.
looking forward to the 2.1 release. - bobby

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/9527 -->

