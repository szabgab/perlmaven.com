use strict;
use warnings;
use 5.010;

sub xy_1 {
    return 11;
}
sub ab_2 {
    return 22;
}

my $text = 'some xy_1 ab_2';

$text =~ s{(\w+_\d+)}{ "$1()"}eeg;
say $text;    #  some 11 22

