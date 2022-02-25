#!/usr/bin/env perl

use CGI;

my $q = CGI->new;
my $x = $q->param('x');
my $y = $q->param('y');

print $q->header(-charset    => 'utf-8');
print "<h1>Hello World</h1>\n";
print "$x / $y = ", $x / $y, "\n";
