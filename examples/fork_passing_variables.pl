use strict;
use warnings;

main();

sub main {
    my $child_pid = fork;
    die "Failed to fork. $!" if not defined $child_pid;

    if (not $child_pid) {
        child_process($child_pid);
    } else {
        parent_process($child_pid);
    }
}

sub child_process {
    my ($child_pid) = @_;

    print "This is the child process.\n";
    print "PID of the child  process itself: $$\n";
    print "PID received in child:  $child_pid\n";
    print "This is the child process.\n";
    print "....................................\n";
    exit();
}

sub parent_process {
    my ($child_pid) = @_;

    my $finished = wait();
    print "\$finished is now $finished\n";
    print "This is in the parent process.\n";
    print "PID of the parent process that spawned the child: $$\n";
    print "PID of child seen from parent: $child_pid\n";
    print "....................................\n";
}

