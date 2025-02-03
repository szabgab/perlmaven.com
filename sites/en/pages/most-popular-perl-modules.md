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

<ol>
  <li>[DBI](https://metacpan.org/pod/DBI)</li>
  <li>[JSON](https://metacpan.org/pod/JSON)</li>
  <li>[LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)</li>
  <li>[DateTime](https://metacpan.org/pod/DateTime)</li>
  <li>[XML::Simple](https://metacpan.org/pod/XML::Simple)</li>
  <li>[Text::CSV](https://metacpan.org/pod/Text::CSV)</li>
  <li>[Spreadsheet::WriteExcel](https://metacpan.org/pod/Spreadsheet::WriteExcel)</li>
  <li>[DBD::mysql](https://metacpan.org/pod/DBD::mysql)</li>
  <li>[XML::Parser](https://metacpan.org/pod/XML::Parser)</li>
  <li>[WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize)</li>
  <li>[Excel::Writer::XLSX](https://metacpan.org/pod/Excel::Writer::XLSX)</li>
  <li>[Net::SSH::Perl](https://metacpan.org/pod/Net::SSH::Perl)</li>
  <li>[Net::SMTP](https://metacpan.org/pod/Net::SMTP)</li>
  <li>[Net::Telnet](https://metacpan.org/pod/Net::Telnet)</li>
  <li>[DBD::Oracle](https://metacpan.org/pod/DBD::Oracle)</li>
  <li>[Spreadsheet::ParseExcel](https://metacpan.org/pod/Spreadsheet::ParseExcel)</li>
  <li>[IO::Socket::SSL](https://metacpan.org/pod/IO::Socket::SSL)</li>
  <li>[HTTP::Response](https://metacpan.org/pod/HTTP::Response)</li>
  <li>[DBIx::Class::ResultSet](https://metacpan.org/pod/DBIx::Class::ResultSet)</li>
  <li>[Log::Log4perl](https://metacpan.org/pod/Log::Log4perl)</li>
</ol>


## Top 20 modules on [MetaCPAN](https://metacpan.org/)

<ol>
  <li>[App::Netdisco](https://metacpan.org/pod/App::Netdisco)</li>
  <li>[DBI](https://metacpan.org/pod/DBI)</li>
  <li>[WWW::YouTube::Download](https://metacpan.org/pod/WWW::YouTube::Download)</li>
  <li>[Mojolicious](https://metacpan.org/pod/Mojolicious)</li>
  <li>[DateTime](https://metacpan.org/pod/DateTime)</li>
  <li>[Task::Kensho](https://metacpan.org/pod/Task::Kensho)</li>
  <li>[LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)</li>
  <li>[Test::More](https://metacpan.org/pod/Test::More)</li>
  <li>[JSON](https://metacpan.org/pod/JSON)</li>
  <li>[Spreadsheet::ParseExcel](https://metacpan.org/pod/Spreadsheet::ParseExcel)</li>
  <li>[Search::Elasticsearch](https://metacpan.org/pod/Search::Elasticsearch)</li>
  <li>[Catalyst::Manual::Tutorial](https://metacpan.org/pod/Catalyst::Manual::Tutorial)</li>
  <li>[App::cpanminus](https://metacpan.org/pod/App::cpanminus)</li>
  <li>[DBIx::Class::ResultSet](https://metacpan.org/pod/DBIx::Class::ResultSet)</li>
  <li>[Acme::DRM](https://metacpan.org/pod/Acme::DRM)</li>
  <li>[Selenium::Remote::Driver](https://metacpan.org/pod/Selenium::Remote::Driver)</li>
  <li>[App::perlbrew](https://metacpan.org/pod/App::perlbrew)</li>
  <li>[Getopt::Long](https://metacpan.org/pod/Getopt::Long)</li>
  <li>[DBD::mysql](https://metacpan.org/pod/DBD::mysql)</li>
  <li>[Moo](https://metacpan.org/pod/Moo)</li>
  <li>[WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize)</li>
</ol>
 
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

