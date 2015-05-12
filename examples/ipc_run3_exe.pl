use strict;
use warnings;
use 5.010;

my @in = ('a', 'd');

use IPC::Run3 qw(run3);

my $in = '';
$in .= "$_\n" for @in;
my ($out, $err);

run3 ['perl', 'exe.pl'], \$in, \$out, \$err;

say '-----------';
say $out;

