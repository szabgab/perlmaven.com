use strict;
use warnings;
use FindBin;
use File::Spec;
use Capture::Tiny qw(capture);

my $command = File::Spec->catfile($FindBin::Bin, 'some_app.pl');

my ($out, $err, $exit) = capture { system $command };

print "\n---- STDERR: --------------\n";
print $err;
print "\n---- STDOUT: --------------\n";
print $out;
print "\n---- EXIT CODE: -----------\n";
print $exit / 256;
print "\n---------------------------\n";

