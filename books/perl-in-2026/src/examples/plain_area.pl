use v5.44;

sub area {
    my ($width, $height) = @_;
    return $width * $height;
}

my $area = area(2, 3);
say $area;


