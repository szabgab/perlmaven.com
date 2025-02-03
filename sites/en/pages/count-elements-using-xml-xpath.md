---
title: "Count elements using XML::XPath"
timestamp: 2015-03-18T21:30:01
tags:
  - XML
  - XML::XPath
published: true
author: szabgab
archive: true
---


The central website of the [Perl Mongers](http://www.pm.org/) is based on a huge XML file listing all the
Perl Monger groups. In order to preserve history, the groups are never really removed from the XML file,
but when the group shuts down it is marked in the "status" field. What if you are interested to know how
many groups are there and what is their distribution based on the "status" field?


## Source code of Perl Mongers

The source code of the [Perl Mongers](http://www.pm.org/) website can be found
in [GitHub](https://github.com/perlorg/www.pm.org) and a similar script called `status.pl`
can be found in the `bin/` directory of that repository. If you are interested how the site
is being maintained you can even watch the [interview with Jay Hannah](/jay-hannah),
who has been maintaining it for ages. If you want to make some changes, you can send a pull request for that
repository.

You can also find the `perl_mongers.xml` file in the root of the repository. It looks like this:

```xml
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<!DOCTYPE perl_mongers PUBLIC "-//Perl Mongers//DTD for Perl user groups//EN" "http://www.pm.org/groups/perl_mongers.dtd">
<!-- This file is maintained by <support@pm.org>
     https://github.com/perlorg/www.pm.org/blob/master/perl_mongers.xml
--><perl_mongers>
  <group id="0" status="active">
    <!-- new york was the first group -->
    <name>NY.pm</name>
    <location>
      <city>New York City</city>
      <state>New York</state>
      <region>Center of the Universe</region>
      <country>United States of America</country>
      <continent>North America</continent>
      <longitude>-73.98771000</longitude>
      <latitude>40.72426868</latitude>
    </location>
    <email type="group">
      <user>nypm-organizers</user>
      <domain>googlegroups.com</domain>
    </email>
    <tsar>
      <name>NY.pm Organizers Committee</name>
      <email type="personal">
        <user>nypm-organizers</user>
        <domain>googlegroups.com</domain>
      </email>
    </tsar>
    <web>http://www.meetup.com/The-New-York-Perl-Meetup-Group/</web>
    <meetup>http://www.meetup.com/The-New-York-Perl-Meetup-Group/</meetup>
    <mailing_list>
      <name>General NY.pm discussion</name>
      <email type="list">
        <user>ny</user>
        <domain>lists.panix.com</domain>
      </email>
      <email type="list_admin">
        <user>majordomo</user>
        <domain>lists.pm.org</domain>
      </email>
      <subscribe>subscribe ny email_address</subscribe>
      <unsubscribe>unsubscribe ny email_address</unsubscribe>
    </mailing_list>
    <mailing_list>
      <name>NYC Perl Jobs</name>
      <email type="list">
        <user>nyc-perl-jobs</user>
        <domain>perl.org</domain>
      </email>
      <email type="list_admin">
        <user>majordomo</user>
        <domain>perl.org</domain>
      </email>
      <subscribe>subscribe nyc-perl-jobs email_address</subscribe>
      <unsubscribe>unsubscribe nyc-perl-jobs
      email_address</unsubscribe>
    </mailing_list>
    <date type="inception">19970827</date>
  </group>

  ....
```

and there are many more such `group` entries.

## Counting the groups by status

{% include file="examples/xml_group_status.pl" %}

This script is based on the `bin/status.pl` script found in the GitHub repository of the site,

The first thing is that we call the constructor of [XML::XPath](https://metacpan.org/pod/XML::XPath),
I am not sure why is there an `|| die` part. The constructor will throw an exception if the given file
cannot be opened (`Cannot open file 'perl_mongers.xml' at`)  or if the XML isn't well formed (`mismatched tag at ...`).
Anyway, this part of the code will load the XML file in memory.
This file we are dealing with isn't huge, but it isn't tiny either. It will take a few milliseconds to load and process the file,
and it will take up quite some memory. (I have not measured either of them.)

The next line will select all the `group` elements (nodes) that are inside the `perl_mongers` element at the root
of the XML file.

```perl
my @nodes = $xp->findnodes('/perl_mongers/group');
```

Each element in the `@nodes` array is an [XML::XPath::Node::Element](https://metacpan.org/pod/XML::XPath::Node::Element) object.

Then we go over each node, and using the `findvalue` method we look for the attribute `status`. (the `@` in-front of the word 'status'
tells XPath to look for an attribute instead of an element. Then we just increment the value of the appropriate key in our `%counts` hash. 

```perl
my %counts;

foreach my $node (@nodes) {
  my $status = $node->findvalue('@status');
  $counts{$status}++;
}
```

Then there is the display of the results which is a bit funky. In a single [map](/transforming-a-perl-array-using-map) statement
we both aggregate the numbers into a variable called `$total`, and also create a little strings that include the value of the "status"
field and the number of occurrence of that value. Then, once the `map` finished we we print all the strings at once.

```perl
my $total;
print map { $total += $counts{$_}; "$_ : $counts{$_}\n" } keys %counts;
```


This could be rewritten to some longer, but probably cleaner code:

```perl
my $total;
foreach my $status (keys %counts) {
    $total += $counts{$status};
    print "$status : $counts{$status}\n";
}
```


## Checking location

In the real status.pl script there is some extra code checking if every active group has longitude and latitude values.
Actually there are a few so called non-geographical groups that are supposed to unite Perl developers around a certain
subject regardless of their location. Such groups are not expected to have latitude and longitude values.

So the following code fetches the content of a number of elements with the current `group` element
and, if the continent is given, then checks if the coordinates also exist.


```perl
  if ($status eq 'active') {
    my $longitude = $node->findvalue('location/longitude/text()');
    my $latitude  = $node->findvalue('location/latitude/text()');
    my $name      = $node->findvalue('name/text()');
    my $continent = $node->findvalue('location/continent/text()');
    if ($continent) {
      if (not $longitude) {
        print "Longitude missing for $name\n";
      } elsif (not $latitude) {
        print "Latitude missing for $name\n";
      }
    }
  }
```

## The full script


{% include file="examples/xml_group_status_full.pl" %}

I am sure this script could be further extended to check other aspects of the XML file. If you have ideas,
don't hesitate to fork the [repository](https://github.com/perlorg/www.pm.org) and send a pull request.

