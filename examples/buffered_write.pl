use 5.010;
use strict;
use warnings;

my $filename = 'data.txt';

open my $fh, '>', $filename or die;
print $fh "hello world\n";
sleep(1);

say -s $filename;  # 0

close $fh;
say -s $filename;  # 12
