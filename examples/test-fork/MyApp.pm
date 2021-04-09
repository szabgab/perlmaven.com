package MyApp;
use strict;
use warnings;
use File::Temp qw(tempdir);

sub logger {
    my ($msg) = @_;
    print "$msg\n" if $ENV{DEBUG};
}

sub work {
    my ($n) = @_;

    logger("work: $$");
    my $dir = tempdir(CLEANUP => 0);
    my $path = File::Spec->catfile($dir, 'result');

    my $pid = fork();
    die "Could not fork $!" if not defined $pid;
    if ($pid) {
        parent($pid, $dir, $path);
    } else {
        child($n, $path);
    }
}

sub parent {
    my ($child_pid, $dir, $path) = @_;
    logger("parent: $$ waiting for child $child_pid");
    my $finished = wait;
    logger("done: in $$ (finished child $finished)");
    open my $fh, '<:encoding(utf8)', $path or die;
    my $result = <$fh>;
    return $result;
}

sub child {
    my ($n, $path) = @_;
    logger("child($n): $$");

    my $result = 2 * $n;
    if (open my $fh, '>:encoding(utf8)', $path) {
        print $fh $result;
    }
    exit;
}


1;

