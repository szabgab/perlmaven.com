use strict;
use warnings;
use 5.010;
use Encode;

my $hi = 'HeLlo';
my $hebrew = 'שלום';
my $arabic = 'سلام';
my $smiley = '😃';
say $hi;
say $hebrew;
say $arabic;
say $smiley;

say length $hi;                               # 5
say length(Encode::decode('UTF-8', $hi));     # 5

say length $hebrew;                           # 8
say length(Encode::decode('UTF-8', $hebrew)); # 4

say length $arabic;                           # 8
say length(Encode::decode('UTF-8', $arabic)); # 4

say length $smiley;                           # 4
say length(Encode::decode('UTF-8', $smiley)); # 1


