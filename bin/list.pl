#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use Cwd            qw(abs_path);
use Data::Dumper   qw(Dumper);
use File::Basename qw(basename dirname);

# list drafts  TODO: list them  sorted by =timstamp
# TODO: check the =status of the pages
# TODO: check how many pages have been translated in each language
# TODO: list the translated pages without =original or without =translator entry

my $root = dirname dirname abs_path $0;

my @languages = map { basename $_ } glob "$root/sites/*";
#say Dumper \@languages;

foreach my $lang (@languages) {
	my @drafts = map { basename $_ } glob "$root/sites/$lang/drafts/*.tt";
	next if not @drafts;
	say "Language $lang";
	say "   $_" for @drafts;
}

