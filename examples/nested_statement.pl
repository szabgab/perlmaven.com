use strict;
use warnings;

print "What is your age? ";
my $age = <STDIN>;
if ($age >= 18) {
    print "In most countries you can vote.\n";
    if ($age >= 23) {
        print "You can drink alcohol in the USA\n";
    }
} else {
    print "You are too young to vote\n";
    if ($age > 6) {
        print "You must go to school...\n";
    }
}

