use strict;
use warnings;
use Cwd qw(abs_path);

my $dir = shift or die "Usage: $0 DIR\n";

opendir my $dh, $dir or die;
for my $thing (readdir $dh) {
    next if $thing eq '.' or $thing eq '..';
    print $thing;
    my $target = readlink "$dir/$thing";
    if ($target) {
        print " -> " . abs_path($target);
    }
    print "\n";
}
