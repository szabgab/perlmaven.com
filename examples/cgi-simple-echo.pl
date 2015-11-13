#!/usr/bin/perl
use strict;
use warnings;

use CGI::Simple;
my $q = CGI::Simple->new;
print $q->header;

my $name = $q->param('name') || '';

print "Hello $name\n";
