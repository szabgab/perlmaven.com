#!/usr/bin/perl
use strict;
use warnings;

use XML::XPath;

my $xp = XML::XPath->new(filename => 'perl_mongers.xml')
  || die 'badness!!';

my @nodes = $xp->findnodes('/perl_mongers/group');

my %counts;

foreach my $node (@nodes) {
  my $status = $node->findvalue('@status');
  $counts{$status}++;
}

my $total;
print map { $total += $counts{$_}; "$_ : $counts{$_}\n" } keys %counts;

print "\nTotal: $total\n";

