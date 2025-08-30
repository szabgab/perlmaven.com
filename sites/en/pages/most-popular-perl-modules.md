---
title: "20 most popular Perl modules"
timestamp: 2015-11-27T16:30:01
tags:
  - CPAN
  - MetaCPAN
published: true
author: szabgab
archive: true
---


Neither [search.cpan.org](http://search.cpan.org/) nor [Meta CPAN](https://metacpan.org/) provide download statistic.
They cannot provide that data because most of the people will download the CPAN distributions from the CPAN mirrors.

On the other hand both web sites use Google Analytics and we can use that see which pages were visited most of the times.

I think we can assume that the number of people reading the documentation probably has a good correlation to actual usage of the modules.


## Caveat

The fact that a module is "popular" or that its documentation is read the most does not mean that it is recommended. For example
XML::Simple is the top hit among the XML-related modules even though it is not recommended to any new code. Its popularity is probably
due its name and hat's probably it is used in a lot of old code and people who need to maintain that code need to read the documentation.


## Top 20 modules on [search.cpan.org](http://search.cpan.org/)


1. [DBI](https://metacpan.org/pod/DBI)
1. [JSON](https://metacpan.org/pod/JSON)
1. [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)
1. [DateTime](https://metacpan.org/pod/DateTime)
1. [XML::Simple](https://metacpan.org/pod/XML::Simple)
1. [Text::CSV](https://metacpan.org/pod/Text::CSV)
1. [Spreadsheet::WriteExcel](https://metacpan.org/pod/Spreadsheet::WriteExcel)
1. [DBD::mysql](https://metacpan.org/pod/DBD::mysql)
1. [XML::Parser](https://metacpan.org/pod/XML::Parser)
1. [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize)
1. [Excel::Writer::XLSX](https://metacpan.org/pod/Excel::Writer::XLSX)
1. [Net::SSH::Perl](https://metacpan.org/pod/Net::SSH::Perl)
1. [Net::SMTP](https://metacpan.org/pod/Net::SMTP)
1. [Net::Telnet](https://metacpan.org/pod/Net::Telnet)
1. [DBD::Oracle](https://metacpan.org/pod/DBD::Oracle)
1. [Spreadsheet::ParseExcel](https://metacpan.org/pod/Spreadsheet::ParseExcel)
1. [IO::Socket::SSL](https://metacpan.org/pod/IO::Socket::SSL)
1. [HTTP::Response](https://metacpan.org/pod/HTTP::Response)
1. [DBIx::Class::ResultSet](https://metacpan.org/pod/DBIx::Class::ResultSet)
1. [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl)



## Top 20 modules on [MetaCPAN](https://metacpan.org/)


1. [App::Netdisco](https://metacpan.org/pod/App::Netdisco)
1. [DBI](https://metacpan.org/pod/DBI)
1. [WWW::YouTube::Download](https://metacpan.org/pod/WWW::YouTube::Download)
1. [Mojolicious](https://metacpan.org/pod/Mojolicious)
1. [DateTime](https://metacpan.org/pod/DateTime)
1. [Task::Kensho](https://metacpan.org/pod/Task::Kensho)
1. [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)
1. [Test::More](https://metacpan.org/pod/Test::More)
1. [JSON](https://metacpan.org/pod/JSON)
1. [Spreadsheet::ParseExcel](https://metacpan.org/pod/Spreadsheet::ParseExcel)
1. [Search::Elasticsearch](https://metacpan.org/pod/Search::Elasticsearch)
1. [Catalyst::Manual::Tutorial](https://metacpan.org/pod/Catalyst::Manual::Tutorial)
1. [App::cpanminus](https://metacpan.org/pod/App::cpanminus)
1. [DBIx::Class::ResultSet](https://metacpan.org/pod/DBIx::Class::ResultSet)
1. [Acme::DRM](https://metacpan.org/pod/Acme::DRM)
1. [Selenium::Remote::Driver](https://metacpan.org/pod/Selenium::Remote::Driver)
1. [App::perlbrew](https://metacpan.org/pod/App::perlbrew)
1. [Getopt::Long](https://metacpan.org/pod/Getopt::Long)
1. [DBD::mysql](https://metacpan.org/pod/DBD::mysql)
1. [Moo](https://metacpan.org/pod/Moo)
1. [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize)

 
## Caveat - round 2

Of course looking at these list without the corresponding number of visits is misleading. Especially because
[search.cpan.org still has 3-4 times more visitors than MetaCPAN.org](https://szabgab.com/cpan-number-of-visits.html).

One has to take in account that XML::Simple, which is at the 5th place on search.cpan.org gets more readers than DBI which is
at the 2nd place on MetaCPAN.

App::Netdisco looks like a bit of an anomaly, but the URL netdisco.org redirects to the MetaCPAN page and that brings in quite
a few visitors.

There are only 3 modules on MetaCPAN that get more visitors than Log::Logperl which is 20th place on search.cpan.org.
Probably the best would be to go over the lists, combine the numbers from the top 20 or 30 modules on both sides
and create a list of modules like that, but I am not sure it is really worth the energy.

