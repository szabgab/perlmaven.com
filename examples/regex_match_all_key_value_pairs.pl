use strict;
use warnings;
use feature 'say';
use Data::Dumper qw(Dumper);

my $text = 'name="foo" anwser=42';
my @matches = $text =~ /(\w+)=(?:"([^"]+)"|(\d+))/g;

say Dumper \@matches;

my $hits = scalar(@matches) / 3;
for my $i (0..$hits-1) {
    say "key: $matches[3*$i]";
    say "value ", $matches[3*$i+1] // $matches[3*$i+2] ;
    say "-----------------";
}



