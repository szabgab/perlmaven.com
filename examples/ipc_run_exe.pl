use strict;
use warnings;
use 5.010;

my @in = ('a', 'd');

use IPC::Run qw(run);

my $in = '';
$in .= "$_\n" for @in;
my ($out, $err);

run ['perl', 'exe.pl'], \$in, \$out, \$err;

say '-----------';
say $out;


