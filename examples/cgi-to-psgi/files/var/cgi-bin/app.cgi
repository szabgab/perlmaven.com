#!/usr/bin/env perl
use strict;
use warnings;

use CGI qw(-utf8);
my $q = CGI->new;
print $q->header(-charset => 'utf8');

my $html;
if ($q->param('pid')) {
    $html = $$;
} else {
    my $name = $q->param('name') || '';
    $html = "Hello $name\n";
}

print $html;
