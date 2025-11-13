use strict;
use warnings;
use feature 'say';
use Data::Dumper qw(Dumper);

my $text = "There are 3 sheep, 24 cats, and 1 dog here";

if ($text =~ /\d+/) {
    say "matched '$&'";
}

my @matched = $text =~ /\d+/;
say Dumper \@matched;

@matched = $text =~ /\d+/g;
say Dumper \@matched;

@matched = $text =~ /(\d+)/g;
say Dumper \@matched;


say "----------------------";

if ($text =~ /\d+\s+[a-z]+/) {
    say "matched '$&'";
}

@matched = $text =~ /(\d+)\s+([a-z]+)/;
say Dumper \@matched;

@matched = $text =~ /(\d+)\s+([a-z]+)/g;
say Dumper \@matched;
