#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

# Plan: collect "number of uploaded distributions per day", save them locally and create a graph out of the data


use LWP::UserAgent;
#my $url = 'http://api.metacpan.org/v0/release/_search?q=date:2014-09-06&fields=author,date&sort=date:desc&size=3';
#my $json = get $url;
#say $json;

use DateTime;

my $s = DateTime->new(year => 2014, month => 05, day => 3);
my $e = $s->clone->add( days => 1);
say "$s";
say "$e";



__END__
my $cmd = qq{
curl -XPOST api.metacpan.org/v0/release/_search?size=100 -d '{
  "query": {
    "match_all": {},
    "range" : {
        "release.date" : {
            "from" : "$s",
            "to" : "$e"
        }
    }
  },
  "fields": ["author", "release.name", "release.distribution", "release.date", "release.version_numified"]
}'
};

say $cmd;
system $cmd;

