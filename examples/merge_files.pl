use strict;
use warnings;

my $target = pop @ARGV;
my @sources = @ARGV;

die "Usage: $0 in in ... in  out\n" if not @sources;

open my $out, '>>', $target or die "Could not open '$target' for appending\n"; 
foreach my $file (@sources) {
    if (open my $in, '<', $file) {
        while (my $line = <$in>) {
            print $out $line;
        }
        close $in;
    } else {
        warn "Could not open '$file' for reading\n";
    }
}
close $out;

print "done\n";
