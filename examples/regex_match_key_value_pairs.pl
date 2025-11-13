use strict;
use warnings;
use feature 'say';
use Data::Dumper qw(Dumper);

my @examples = ('name="foo"', 'anwser=42');


for my $text (@examples) {
    say $text;
    if ($text =~ /(\w+)="([^"]+)"/) {
        say "'$1'";
        say "'$2'";
    }
    say '---';
}

say "====================";
for my $text (@examples) {
    say $text;
    if ($text =~ /(\w+)=(:?"([^"]+)"|(\d+))/) {
        say "'$1'";
        say "'$2'";
    }
    say '---';
}

