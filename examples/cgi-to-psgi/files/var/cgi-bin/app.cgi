#!/usr/bin/env perl
use strict;
use warnings;

use CGI qw(-utf8);
my $q = CGI->new;
print $q->header(-charset => 'utf8');

my $name = $q->param('name') || '';

print "Hello $name\n";

