#use v5.44;
use feature 'say';
#use strict;
#use warnings;

sub area {
    my ($width, $height) = @_;
    return $width * $height;
}

my $area = area(2, 3);
say $area;

my $too_few = area(2);
say $too_few;

my $too_many = area(2, 5, 21);
say $too_many;

