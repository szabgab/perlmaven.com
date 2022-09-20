use strict;
use warnings;
use feature 'say';
use Fcntl qw(SEEK_SET);

my ($file, $start, $length) = @ARGV;
die "Usage: $0 FILE START LENGTH\n" if not $length;

open my $fh, '<', $file or die;
seek $fh, $start, SEEK_SET;
my $buffer;
read $fh, $buffer, $length;
say "'$buffer'";
