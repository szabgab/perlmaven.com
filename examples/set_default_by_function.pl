use strict;
#use warnings;

my $code = get_code() or default_code();
# Using the code ...
print $code;

sub get_code {
    # returning some code which in rare ocassions might be undef
}

sub default_code {
    print "running default_code\n";
    return 42;
}

