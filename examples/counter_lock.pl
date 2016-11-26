use strict;
use warnings;
use Fcntl qw(:flock SEEK_END);

my $file = 'counter.txt';
my $count = 0;


if (open my $fh, '+<', $file) {
    flock($fh, LOCK_EX) or die "Cannot lock mailbox - $!\n";
    $count = <$fh>;
    $count++;
    print "$count\n";
    seek $fh, 0, 0;
    truncate $fh, 0;
    print $fh $count;
    close $fh;
}

