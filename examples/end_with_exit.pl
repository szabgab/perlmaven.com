use strict;
use warnings;

print "hello world\n";

do_something();

print "Goodbye\n";

END {
   print "in the END block\n";
}


sub do_something {
    print "in do_something\n";
    exit;
    print "still in do_something\n";
}
