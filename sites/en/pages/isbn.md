---
title: "ISBN - International Standard Book Number - with Perl"
timestamp: 2015-06-06T10:10:01
tags:
  - ISBN
published: true
author: szabgab
archive: true
show_related: false
---


ISBN, International Standard Book Number is a 10-13 digit long number that can identify
books and other publications. There are two main groups of modules:
One is [Business::ISBN](https://metacpan.org/pod/Business::ISBN) that can
handle the ISBN number itself without any connection to central databases
and [WWW::Scraper::ISBN](https://metacpan.org/pod/WWW::Scraper::ISBN)
that, using individual drivers, can access ISBN database around the world.


## Distributions

<table>
   <tr><th>Distribution</th><th>Abstract</th><th>Author</th><th>Date</th></tr>
[% FOR d IN distributions %]
   <tr><td>[[% d.short_name %]](https://metacpan.org/release/[% d.name %])</td>
       <td>[% d.abstract %]</td>
       <td>[[% d.author %]](https://metacpan.org/author/[% d.author %])</td>
       <td>[% d.date %]</td>
   </tr>
[% END %]
</table>
