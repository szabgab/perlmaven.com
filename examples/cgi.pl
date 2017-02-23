#!/usr/bin/perl
use strict;
use warnings;

use CGI;

my $q = CGI->new;
print $q->header;

print qq{<html><head></head><body>\n};
print qq{<table>\n};
printf qq{<tr><td>request_method</td><td>%s</td></tr>\n}, $q->request_method;
for my $p ($q->param()) {
    printf qq{<tr><td>%s</td><td>%s</td></tr>\n}, $p, scalar $q->param($p);
}
print qq{</table></html>\n};


