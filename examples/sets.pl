use strict;
use warnings;
use 5.010;

use Set::Scalar;
my $english = Set::Scalar->new('door', 'car', 'lunar', 'era');
my $spanish = Set::Scalar->new('era', 'lunar', 'hola');

say $english;              # (car door era lunar)
say $spanish;              # (era hola lunar)

my $in_both = $english->intersection($spanish);
say $in_both;              # (era lunar)
my $in_both_other_way = $spanish->intersection($english);
say $in_both_other_way;    # (era lunar)

my $in_either = $english->union($spanish);
say $in_either;            # (car door era hola lunar)

my $english_only = $english->difference($spanish);
say $english_only;         # (car door)

my $spanish_only = $spanish->difference($english);
say $spanish_only;         # (hola)

my $ears_of_the_elephant = $english->symmetric_difference($spanish);
say $ears_of_the_elephant; # (car door hola)

