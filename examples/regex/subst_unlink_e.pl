use 5.010;
use strict;
use warnings;

my $str = "file: abc.txt";

$str =~ s/file: (.*)/unlink $1/e;

say $str;  # 1  (or 0 if the file did not exist)

