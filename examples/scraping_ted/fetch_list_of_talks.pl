#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Web::Query qw(wq);

my $talks = 'http://www.ted.com/talks';
my $page = 0;

my %talks;
while (1) {
	$page++;
	my $url = "$talks?page=$page";
	my $res = wq($url);

	last if index($res->text, "Sorry. We couldn't find a talk quite like that.") > -1;

	$res->find('a')->each(sub {
    	my ($i, $elem) = @_;
		if ($elem->attr('href') =~ m{^/talks/} and $elem->attr('href') !~ m{^/talks\?page}) {
			if (not $talks{ $elem->attr('href') }++) {
				say $elem->attr('href');
			}
		}
	});
	last if $page > 3;
}

