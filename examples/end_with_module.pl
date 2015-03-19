use strict;
use warnings;


END {
   print "in the END block before use\n";
}


use EndModule;

print "hello world\n";

EndModule::some_code();
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

