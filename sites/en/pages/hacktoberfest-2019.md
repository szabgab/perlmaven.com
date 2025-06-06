---
title: "Hacktoberfest 2019 and Perl"
timestamp: 2019-09-30T08:00:01
tags:
  - MetaCPAN
published: true
books:
  - dancer
author: szabgab
archive: true
---


[Digital Ocean](/digitalocean), one of my favorite VPS providers is running its
[Hacktoberfest](https://hacktoberfest.digitalocean.com/) again. The goal is to encourage more people
to contribute to Open Source projects.

In a nutshell: After you register on their website you need to send 4 pull-requests to any GitHub hosted project
in October. The first 50,000 people get a cool T-shirt.


## How?

The Hacktoberfest page has some explanation on how to contribute, but if you'd like a deeper explanation,
you can pick up my eBook on [Collaborative Development using Git and GitHub](https://leanpub.com/collab-dev-git)

## What?

So what can you do if you care about Perl?

* You can read the [Hacktoberfest article](https://www.perl.com/article/hacktoberfest-2019/) on perl.com and follow those suggestions.
* You can fix some stuff in the [code running the Perl Maven site](https://github.com/szabgab/Perl-Maven).
* You can fix issues in the [content of the Perl Maven site](https://github.com/szabgab/perlmaven.com).
* You can help improve the [Perl Weekly](https://github.com/szabgab/perlweekly).
* You can join the [Perl Weekly Challenge](https://perlweeklychallenge.org/) (see [Hacktoberfest with Perl Weekly Challenge](http://blogs.perl.org/users/mohammad_s_anwar/2019/09/hacktoberfest-with-perl-weekly-challenge.html))
* Improve [MetaCPAN](/metacpan) itself.
* You can find some low-hanging fruits on CPAN:

[MetaCPAN](https://metacpan.org/) provides a lot of information about CPAN modules, but not all the modules
provide this information. I have written a small script using
[MetaCPAN::Client](https://metacpan.org/pod/MetaCPAN::Client) to fetch the N most recently uploaded modules
and check some of these meta data.

The script is here:

{% include file="examples/recent_cpan_modules.pl" %}


You can download it and run it yourself to see the most up to date information. You can also improve the script
and send a PR with the improvement. The source of the script is
[here](https://github.com/szabgab/perlmaven.com/blob/main/examples/recent_cpan_modules.pl).

Currently it checks if the META files contains a link to the source repository of the module and if it has a license in
the META files.

<h3>Link to repository</h3>

If the META file does not contain information about the source code repository then you'll have to do a little research
to find out if the modules is on GitHub at all.

One way is to look at the name of the author. Look at other modules of the same author. If none of them have links to a
"Repository" (on the left side of the MetaCPAN page) then that person probably does not have a version control or not on
Git. You can send an e-mail to the person asking about it or you can move on to something else.

If you found that some other modules have the "Repository" link then using that link you can find the module authors
username on GitHub. It is likely that the source of the module in question is under the same user.

If still cannot find the repository, then send the author an e-mail. S/he might reply quickly and then you can make
progress with it.

Once you know the repository of the module you can follow this article on
<a href="/how-to-add-link-to-version-control-system-of-a-cpan-distributions">adding repository link
to a CPAN distribution</a>.


<h3>License</h3>

If the report generated by the script shows that the META file of the module does not contain a license, or if the license is "unknown",
then check out this article that explains <a href="/how-to-add-the-license-field-to-meta-files-on-cpan">how to add the license field to the META.yml and META.json
files on CPAN</a>. This assumes that you already know where is the source repository of the module.

<h3>Travis-CI</h3>

I have not implemented this yet, but this is the next thing on my agenda.
For the modules that use GitHub and that have links to their GitHub repository, check if they have a <b>.travis.yml</b>
file. If not, then for sure they don't use [Travis-CI](https://travis-ci.org/) for Continuous Integration.
In such case first you need to make sure there are tests in the module and that you can run them on your computer.
If there are no tests, add any simple test-case.
Once there is at least one test, you can create a <b>.travis.yml</b>, enable Travis-CI for your clone and once the tests
are passing on Travis-CI as well you can send a pull-request with that file and the information needed to enable
Travis-CI.



On 30 September 2019 I ran the script on the 1,000 most recently uploaded modules and this is what I got.


[Business-CreditCard-0.38](https://metacpan.org/release/PSRSBSNS/Business-CreditCard-0.38)<br>
Missing resources from META files<br>

<p>

[Audio-Nama-1.216](https://metacpan.org/release/GANGLION/Audio-Nama-1.216)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[DateTime-Ordinal-0.01](https://metacpan.org/release/LNATION/DateTime-Ordinal-0.01)<br>
Missing resources from META files<br>

<p>

[devtools-0.02](https://metacpan.org/release/AFUERST/devtools-0.02)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[IO-Pager-0.43](https://metacpan.org/release/JPIERCE/IO-Pager-0.43)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Net-DRI-0.96_13](https://metacpan.org/release/PMEVZEK/Net-DRI-0.96_13)<br>
Missing repository from META files<br>

<p>

[Bundle-Maintainer-MHASCH-0.002](https://metacpan.org/release/MHASCH/Bundle-Maintainer-MHASCH-0.002)<br>
Missing resources from META files<br>

<p>

[Mojolicious-Command-scaffold-0.0.2](https://metacpan.org/release/CRLCU/Mojolicious-Command-scaffold-0.0.2)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Tangle-0.01](https://metacpan.org/release/PEASWORTH/Tangle-0.01)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[AnyEvent-WebDriver-1.01](https://metacpan.org/release/MLEHMANN/AnyEvent-WebDriver-1.01)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Text-Capitalize-1.5](https://metacpan.org/release/DOOM/Text-Capitalize-1.5)<br>
Missing repository from META files<br>

<p>

[Google-Ads-AdWords-Client-5.8.2](https://metacpan.org/release/SUNDQUIST/Google-Ads-AdWords-Client-5.8.2)<br>
Missing repository from META files<br>

<p>

[SUNAT-0.01](https://metacpan.org/release/GPAREDES/SUNAT-0.01)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[IO-Async-Loop-Mojo-0.06](https://metacpan.org/release/PEVANS/IO-Async-Loop-Mojo-0.06)<br>
Missing repository from META files<br>

<p>

[AsposeCellsCloud-CellsApi-19.9](https://metacpan.org/release/ASPOSEAPI/AsposeCellsCloud-CellsApi-19.9)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Date-Time2fmtstr-1.03](https://metacpan.org/release/TURNERJW/Date-Time2fmtstr-1.03)<br>
Missing resources from META files<br>

<p>

[MooX-Role-CliOptions-0.05](https://metacpan.org/release/BOFTX/MooX-Role-CliOptions-0.05)<br>
Missing resources from META files<br>

<p>

[Lemonldap-NG-Portal-2.0.6](https://metacpan.org/release/COUDOT/Lemonldap-NG-Portal-2.0.6)<br>
Missing repository from META files<br>

<p>

[Lemonldap-NG-Manager-2.0.6](https://metacpan.org/release/COUDOT/Lemonldap-NG-Manager-2.0.6)<br>
Missing repository from META files<br>

<p>

[Lemonldap-NG-Handler-2.0.6](https://metacpan.org/release/COUDOT/Lemonldap-NG-Handler-2.0.6)<br>
Missing repository from META files<br>

<p>

[Bioinfo-0.1.15](https://metacpan.org/release/PEKINGSAM/Bioinfo-0.1.15)<br>
Missing resources from META files<br>

<p>

[XAO-Indexer-1.05](https://metacpan.org/release/AMALTSEV/XAO-Indexer-1.05)<br>
License in META files is unknown<br>

<p>

[XAO-ImageCache-1.22](https://metacpan.org/release/AMALTSEV/XAO-ImageCache-1.22)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[XAO-Catalogs-1.04](https://metacpan.org/release/AMALTSEV/XAO-Catalogs-1.04)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[XAO-Content-1.06](https://metacpan.org/release/AMALTSEV/XAO-Content-1.06)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[API-INSEE-Sirene-3.504](https://metacpan.org/release/CPANLNCSA/API-INSEE-Sirene-3.504)<br>
Missing resources from META files<br>

<p>

[Dancer2-Plugin-WebService-4.1.8](https://metacpan.org/release/MPOURASG/Dancer2-Plugin-WebService-4.1.8)<br>
Missing resources from META files<br>

<p>

[POE-Component-FunctionBus-0.02](https://metacpan.org/release/DAEMON/POE-Component-FunctionBus-0.02)<br>
Missing resources from META files<br>

<p>

[Net-Graphite-0.18](https://metacpan.org/release/SLANNING/Net-Graphite-0.18)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Tie-TZ-10](https://metacpan.org/release/KRYDE/Tie-TZ-10)<br>
Missing repository from META files<br>

<p>

[Gtk2-Ex-MenuView-5](https://metacpan.org/release/KRYDE/Gtk2-Ex-MenuView-5)<br>
Missing repository from META files<br>

<p>

[Math-OEIS-13](https://metacpan.org/release/KRYDE/Math-OEIS-13)<br>
Missing repository from META files<br>

<p>

[Getopt-O2-v1.1.0](https://metacpan.org/release/SCHIECHEO/Getopt-O2-v1.1.0)<br>
Missing repository from META files<br>

<p>

[Sim-OPT-0.463](https://metacpan.org/release/GLBRUNE/Sim-OPT-0.463)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[WebService-Hexonet-Connector-v2.2.4](https://metacpan.org/release/HEXONET/WebService-Hexonet-Connector-v2.2.4)<br>
Missing resources from META files<br>

<p>

[PGObject-Util-DBMethod-1.00.003](https://metacpan.org/release/EHUELS/PGObject-Util-DBMethod-1.00.003)<br>
Missing resources from META files<br>

<p>

[PGObject-Util-DBChange-0.050.3](https://metacpan.org/release/EHUELS/PGObject-Util-DBChange-0.050.3)<br>
Missing resources from META files<br>

<p>

[Telugu-Itrans-0.03](https://metacpan.org/release/RAJ/Telugu-Itrans-0.03)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Fsdb-2.68](https://metacpan.org/release/JOHNH/Fsdb-2.68)<br>
Missing resources from META files<br>

<p>

[mojo-console-0.0.7](https://metacpan.org/release/CRLCU/mojo-console-0.0.7)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Job-Async-Redis-0.004](https://metacpan.org/release/TEAM/Job-Async-Redis-0.004)<br>
Missing resources from META files<br>

<p>

[StreamFinder-1.21](https://metacpan.org/release/TURNERJW/StreamFinder-1.21)<br>
Missing resources from META files<br>

<p>

[Net-Clacks-6.1](https://metacpan.org/release/CAVAC/Net-Clacks-6.1)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[AnyEvent-7.17](https://metacpan.org/release/MLEHMANN/AnyEvent-7.17)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[App-perlsh-0.02](https://metacpan.org/release/PEVANS/App-perlsh-0.02)<br>
Missing repository from META files<br>

<p>

[Data-SeaBASS-0.192600](https://metacpan.org/release/JLEFLER/Data-SeaBASS-0.192600)<br>
Missing resources from META files<br>

<p>

[Parallel-Forker-1.250](https://metacpan.org/release/WSNYDER/Parallel-Forker-1.250)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[IO-HyCon-0.2](https://metacpan.org/release/VAXMAN/IO-HyCon-0.2)<br>
Missing resources from META files<br>

<p>

[Locale-Maketext-Gettext-1.30](https://metacpan.org/release/IMACAT/Locale-Maketext-Gettext-1.30)<br>
Missing resources from META files<br>

<p>

[Crypt-IDA-0.03](https://metacpan.org/release/DMALONE/Crypt-IDA-0.03)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Date-Holidays-DE-2.03](https://metacpan.org/release/FROGGS/Date-Holidays-DE-2.03)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[WWW-Search-Ebay-3.054](https://metacpan.org/release/MTHURN/WWW-Search-Ebay-3.054)<br>
Missing repository from META files<br>

<p>

[AnyEvent-Fork-RPC-2.0](https://metacpan.org/release/MLEHMANN/AnyEvent-Fork-RPC-2.0)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Siffra-Tools-0.15](https://metacpan.org/release/LUIZBENE/Siffra-Tools-0.15)<br>
Missing resources from META files<br>

<p>

[WARC-v0.0.0_6](https://metacpan.org/release/JCB/WARC-v0.0.0_6)<br>
Missing resources from META files<br>

<p>

[Text-Starfish-1.29](https://metacpan.org/release/VLADO/Text-Starfish-1.29)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[AnyEvent-ZabbixSender-1.1](https://metacpan.org/release/MLEHMANN/AnyEvent-ZabbixSender-1.1)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[DateTime-Format-Flexible-0.32](https://metacpan.org/release/THINC/DateTime-Format-Flexible-0.32)<br>
Missing resources from META files<br>

<p>

[Finance-Bank-LaPoste-9.02](https://metacpan.org/release/PIXEL/Finance-Bank-LaPoste-9.02)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Bio-Palantir-0.192560](https://metacpan.org/release/LMEUNIER/Bio-Palantir-0.192560)<br>
Missing resources from META files<br>

<p>

[Math-FastGF2-0.07](https://metacpan.org/release/DMALONE/Math-FastGF2-0.07)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[XS-Install-1.2.11](https://metacpan.org/release/SYBER/XS-Install-1.2.11)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Net-SNMP-Mixin-InetCidrRouteTable-0.03](https://metacpan.org/release/GAISSMAI/Net-SNMP-Mixin-InetCidrRouteTable-0.03)<br>
Missing repository from META files<br>

<p>

[Verilog-Perl-3.468](https://metacpan.org/release/WSNYDER/Verilog-Perl-3.468)<br>
Missing repository from META files<br>

<p>

[mojo-debugbar-0.0.3](https://metacpan.org/release/CRLCU/mojo-debugbar-0.0.3)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[mojo-events-0.0.2](https://metacpan.org/release/CRLCU/mojo-events-0.0.2)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Mojolicious-Plugin-Events-0.3.3](https://metacpan.org/release/CRLCU/Mojolicious-Plugin-Events-0.3.3)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Image-Sane-4](https://metacpan.org/release/RATCLIFFE/Image-Sane-4)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Math-Polynomial-1.015](https://metacpan.org/release/MHASCH/Math-Polynomial-1.015)<br>
Missing resources from META files<br>

<p>

[Time-OlsonTZ-Data-0.201903](https://metacpan.org/release/ZEFRAM/Time-OlsonTZ-Data-0.201903)<br>
Missing repository from META files<br>

<p>

[HC-HyCon-0.1](https://metacpan.org/release/VAXMAN/HC-HyCon-0.1)<br>
Missing resources from META files<br>

<p>

[AnyEvent-YACurl-0.13](https://metacpan.org/release/TVDW/AnyEvent-YACurl-0.13)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[AWS-CDK-0.001_01](https://metacpan.org/release/JWRIGHT/AWS-CDK-0.001_01)<br>
Missing resources from META files<br>

<p>

[JSII-0.001_01](https://metacpan.org/release/JWRIGHT/JSII-0.001_01)<br>
Missing resources from META files<br>

<p>

[Device-Chip-CC1101-0.02](https://metacpan.org/release/PEVANS/Device-Chip-CC1101-0.02)<br>
Missing repository from META files<br>

<p>

[Dita-GB-Standard-20190911](https://metacpan.org/release/PRBRENAN/Dita-GB-Standard-20190911)<br>
Missing repository from META files<br>

<p>

[MARC-File-JSON-0.005](https://metacpan.org/release/CFOUTS/MARC-File-JSON-0.005)<br>
Missing resources from META files<br>

<p>

[Win32-SqlServer-2.012](https://metacpan.org/release/SOMMAR/Win32-SqlServer-2.012)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Dita-GB-Standard-Types-20190911](https://metacpan.org/release/PRBRENAN/Dita-GB-Standard-Types-20190911)<br>
Missing repository from META files<br>

<p>

[Code-Quality-0.002](https://metacpan.org/release/MGV/Code-Quality-0.002)<br>
Missing repository from META files<br>

<p>

[WebService-HIBP-0.15](https://metacpan.org/release/DDICK/WebService-HIBP-0.15)<br>
Missing resources from META files<br>

<p>

[Graphics-Framebuffer-6.35](https://metacpan.org/release/RKELSCH/Graphics-Framebuffer-6.35)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[IO-Termios-0.08](https://metacpan.org/release/PEVANS/IO-Termios-0.08)<br>
Missing repository from META files<br>

<p>

[Telugu-Utils-0.03](https://metacpan.org/release/RAJ/Telugu-Utils-0.03)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Mojolicious-Plugin-Debugbar-0.0.2](https://metacpan.org/release/CRLCU/Mojolicious-Plugin-Debugbar-0.0.2)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Test-Module-Runnable-0.4.2](https://metacpan.org/release/DDRP/Test-Module-Runnable-0.4.2)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Future-AsyncAwait-0.33](https://metacpan.org/release/PEVANS/Future-AsyncAwait-0.33)<br>
Missing repository from META files<br>

<p>

[Data-Bitfield-0.04](https://metacpan.org/release/PEVANS/Data-Bitfield-0.04)<br>
Missing repository from META files<br>

<p>

[Device-Chip-HTU21D-0.04](https://metacpan.org/release/PEVANS/Device-Chip-HTU21D-0.04)<br>
Missing repository from META files<br>

<p>

[Device-Chip-AnalogConverters-0.08](https://metacpan.org/release/PEVANS/Device-Chip-AnalogConverters-0.08)<br>
Missing repository from META files<br>

<p>

[Data-Douglas_Peucker-0.01](https://metacpan.org/release/MIKEFLAN/Data-Douglas_Peucker-0.01)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Syntax-Keyword-Try-0.11](https://metacpan.org/release/PEVANS/Syntax-Keyword-Try-0.11)<br>
Missing repository from META files<br>

<p>

[Data-Edit-Xml-20190906](https://metacpan.org/release/PRBRENAN/Data-Edit-Xml-20190906)<br>
Missing repository from META files<br>

<p>

[GrabzItClient.3.3.6](https://metacpan.org/release/GRABZIT/GrabzItClient.3.3.6)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Test-Expr-0.000009](https://metacpan.org/release/DCONWAY/Test-Expr-0.000009)<br>
Missing resources from META files<br>

<p>

[Dist-Banshee-0.002](https://metacpan.org/release/LEONT/Dist-Banshee-0.002)<br>
Missing resources from META files<br>

<p>

[Firefox-Marionette-0.82](https://metacpan.org/release/DDICK/Firefox-Marionette-0.82)<br>
Missing resources from META files<br>

<p>

[Proc-ProcessTable-piddler-0.2.0](https://metacpan.org/release/VVELOX/Proc-ProcessTable-piddler-0.2.0)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Forks-Queue-0.12](https://metacpan.org/release/MOB/Forks-Queue-0.12)<br>
Missing resources from META files<br>

<p>

[IO-IPFinder-1.0](https://metacpan.org/release/IPFINDER/IO-IPFinder-1.0)<br>
Missing resources from META files<br>

<p>

[Net-Connection-ncnetstat-0.5.0](https://metacpan.org/release/VVELOX/Net-Connection-ncnetstat-0.5.0)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Task-Biodiverse-NoGUI-3.001](https://metacpan.org/release/SLAFFAN/Task-Biodiverse-NoGUI-3.001)<br>
License in META files is unknown<br>

<p>

[Task-Biodiverse-3.00](https://metacpan.org/release/SLAFFAN/Task-Biodiverse-3.00)<br>
License in META files is unknown<br>

<p>

[App-ccdiff-0.28](https://metacpan.org/release/HMBRAND/App-ccdiff-0.28)<br>
Missing repository from META files<br>

<p>

[Geoffrey-Changelog-Database-0.000202](https://metacpan.org/release/MZIESCHA/Geoffrey-Changelog-Database-0.000202)<br>
License in META files is unknown<br>

<p>

[Unicode-EastAsianWidth-12.0](https://metacpan.org/release/AUDREYT/Unicode-EastAsianWidth-12.0)<br>
License in META files is unknown<br>

<p>

[Pod-PseudoPod-0.19](https://metacpan.org/release/CHROMATIC/Pod-PseudoPod-0.19)<br>
Missing repository from META files<br>

<p>

[grpc-xs-0.32](https://metacpan.org/release/JOYREX/grpc-xs-0.32)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Getopt-OO-v1.0.19](https://metacpan.org/release/SCHIECHEO/Getopt-OO-v1.0.19)<br>
Missing resources from META files<br>

<p>

[libgetopt-oo-perl-v1.0.19](https://metacpan.org/release/SCHIECHEO/libgetopt-oo-perl-v1.0.19)<br>
Missing resources from META files<br>

<p>

[AI-ML-0.001](https://metacpan.org/release/RUISTEVE/AI-ML-0.001)<br>
Missing resources from META files<br>

<p>

[Math-Polynomial-Horner-4](https://metacpan.org/release/KRYDE/Math-Polynomial-Horner-4)<br>
Missing repository from META files<br>

<p>

[math-image-113](https://metacpan.org/release/KRYDE/math-image-113)<br>
Missing repository from META files<br>

<p>

[Glib-Ex-ConnectProperties-20](https://metacpan.org/release/KRYDE/Glib-Ex-ConnectProperties-20)<br>
Missing repository from META files<br>

<p>

[HTML-T5-0.006](https://metacpan.org/release/SHLOMIF/HTML-T5-0.006)<br>
Missing repository from META files<br>

<p>

[Syntax-Keyword-Dynamically-0.01_001](https://metacpan.org/release/PEVANS/Syntax-Keyword-Dynamically-0.01_001)<br>
Missing repository from META files<br>

<p>

[Algorithm-Cluster-1.59](https://metacpan.org/release/MDEHOON/Algorithm-Cluster-1.59)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Mojo-UserAgent-Cached-1.07](https://metacpan.org/release/NICOMEN/Mojo-UserAgent-Cached-1.07)<br>
Missing repository from META files<br>

<p>

[Script-Toolbox-0.63](https://metacpan.org/release/ECKARDT/Script-Toolbox-0.63)<br>
License in META files is unknown<br>

Missing resources from META files<br>

<p>

[Number-ZipCode-JP-0.20190830](https://metacpan.org/release/TANIGUCHI/Number-ZipCode-JP-0.20190830)<br>
Missing repository from META files<br>

<p>

[Net-DNS-1.21](https://metacpan.org/release/NLNETLABS/Net-DNS-1.21)<br>
Missing resources from META files<br>

<p>

[Devel-PerlySense-0.0221](https://metacpan.org/release/JOHANL/Devel-PerlySense-0.0221)<br>
Missing resources from META files<br>

<p>

[Mojolicious-Command-static-0.02](https://metacpan.org/release/SADAMS/Mojolicious-Command-static-0.02)<br>
License in META files is unknown<br>

<p>

