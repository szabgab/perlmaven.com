use 5.010;
use strict;
use warnings;

my $filename = 'data.txt';

open my $fh, '>', $filename or die;
print $fh "Hello World\n";
$fh->flush;
say -s $filename; # 12

print $fh "Hello Back\n";
$fh->flush;
say -s $filename; # 23

