use strict;
use warnings;
use FindBin;
use File::Spec;
use Capture::Tiny qw(capture_merged);

my $command = File::Spec->catfile($FindBin::Bin, 'some_app.pl');

my ($outerr, $exit) = capture_merged { system $command };

print "\n---- STDOUT and STDERR: ---\n";
print $outerr;
print "\n---- EXIT CODE: -----------\n";
print $exit / 256;
print "\n---------------------------\n";

