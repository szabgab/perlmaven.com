---
title: "Geolocation of IP addresses using IP2Location"
timestamp: 2014-01-15T07:30:02
tags:
  - Geo::IP2Location
published: false
author: szabgab
---


There are a number of companies providing mapping of IP address to physical location on the globe.
This time we are going to look at [IP2Location](/ip2location), a company
in Malaysia.


Their web-site has a link for [developers](http://www.ip2location.com/developers) where they 
link to the client libraries in various languages, including [Perl](http://www.ip2location.com/developers/perl).


## Install

They have a set of instructions on [their Perl page](http://www.ip2location.com/developers/perl),
but if you are a regular Perl developer you'd probably only need to type:

```
$ cpanm Geo::IP2Location
```

to get the module installed from CPAN.


In addition to the Perl module, we also need to get one of their database files.
There are 24 different files for IPv4, and 24 for IPv6. Each file contains 
a different set of data, but in the end you'll only need one of these files for IPv4 and on for IPv6.
The database are numbered DB1..DB24, the most simple one being DB1 that only contains the name of the country
where the IP is located.

They provide a sample set of data for each database, and if you'd like to have the whole data set you can
buy that with an annual subscription service. They will provide monthly updates for the data.
Alternatively, you can also query their [on-line database](http://www.ip2location.com/web-service)
In that case you pay per query.


[Geo::IP2Location](https://metacpan.org/pod/Geo::IP2Location)


```
$ wget http://www.ip2location.com/downloads/sample.bin.db1.zip
$ unzip sample.bin.db1.zip

Archive:  sample.bin.db1.zip
  inflating: IP-COUNTRY-SAMPLE.BIN   
  inflating: README.TXT              
  inflating: IP2LOCATION_LICENSE_AGREEMENT.PDF  
  inflating: IP2LOCATION-COUNTRY.CSV 
```


```perl
```


