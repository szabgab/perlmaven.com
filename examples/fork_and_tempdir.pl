use strict;
use warnings;
use File::Temp qw(tempdir);
use File::Path qw(rmtree);

rand();    # implicitly call srand()

my $f = 5;
my $n = 1000;
my $dir = "/tmp/" . time;
mkdir $dir;
print "$dir\n";

for (1 .. $f) {
    my $pid = fork();
    if (not $pid) { # in the child process
        # srand();  # explicitely set srand in the child process
        for (1 .. $n) {
	        tempdir( CLEANUP => 1, DIR => $dir );
        }
		exit;
    }
}

for (1 .. $f ) {
	wait;
}
rmtree $dir;
