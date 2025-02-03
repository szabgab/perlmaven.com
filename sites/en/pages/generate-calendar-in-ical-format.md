---
title: "Generate Calendar in ICal format"
timestamp: 2021-04-04T07:50:01
tags:
  - ICal
  - calendar
  - Data::ICal
  - Data::ICal::Entry::Event
  - DateTime
  - DateTime::Format::ICal
  - DateTime::Duration
published: true
author: szabgab
archive: true
description: "Generate a calendar in ICal format using Perl."
show_related: true
---


You can serve calendars in ICal format from your web application on-the fly or you can save it to the disk as an *.ical file and serve the static file.
Then people can add it to their calendar application and see the events you list.


The modules in use:

* [Data::ICal](https://metacpan.org/pod/Data::ICal)
* [Data::ICal::Entry::Event](https://metacpan.org/pod/Data::ICal::Entry::Event)
* [DateTime](https://metacpan.org/pod/DateTime)
* [DateTime::Duration](https://metacpan.org/pod/DateTime::Duration)
* [DateTime::Format::ICal](https://metacpan.org/pod/DateTime::Format::ICal)

This code generates two events. The first one has a beginning and ending date. The second one has a beginninng and a duration. It also includes a link to Zoom as the "location".

{% include file="examples/generate_ical.pl" %}

The output is this:

{% include file="examples/example.ical" %}

## Real world examples

For example the [Perl Weekly newsletter](https://perlweekly.com/) has a [calendar of Perl events](https://perlweekly.com/perlweekly.ical)
based on the [list of Perl events](https://perlweekly.com/events.html).
