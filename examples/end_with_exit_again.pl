use strict;
use warnings;

END {
   print "in the END block\n";
}


print "hello world\n";

do_something();

print "Goodbye\n";


sub do_something {
    print "in do_something\n";
    exit;
    print "still in do_something\n";
}
