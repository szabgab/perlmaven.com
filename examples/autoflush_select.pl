use 5.010;
use strict;
use warnings;

my $filename = 'data.txt';
my $autoflush = shift;

open my $fh, '>', $filename or die;
say -s $filename; # 0

if ($autoflush) {
    my $old = select $fh;
    $| = 1;
    select $old;
}

print $fh "Hello World\n";
say -s $filename; # 12

print $fh "Hello Back\n";
say -s $filename; # 23

close $fh;
say -s $filename; # 23

