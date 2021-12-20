use strict;
use warnings;

main();

sub main {
    my $child_pid = fork;
    die "Failed to fork. $!" if not defined $child_pid;

    if (not $child_pid) {
        child_process();
    } else {
        parent_process();
    }

    sub child_process {
        print "This is the child process.\n";
        print "PID of the child  process itself: $$\n";
        print "PID received in child:  $child_pid\n";
        print "This is the child process.\n";
        print "....................................\n";
    }

    sub parent_process {
        my $finished = wait();
        print "\$finished is now $finished\n";
        print "This is in the parent process.\n";
        print "PID of the parent process that spawned the child: $$\n";
        print "PID of child seen from parent: $child_pid\n";
        print "....................................\n";
    }
}

