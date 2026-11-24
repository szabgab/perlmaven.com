use v5.44;

sub area($width, $height = 10) {
    return $width * $height;
}


my $area = area(2, 3);
say $area;

my $few = area(2);
say $few;

my $too_many = area(2, 5, 11);
say $too_many;

