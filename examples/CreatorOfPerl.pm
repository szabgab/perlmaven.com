package CreatorOfPerl;
use strict;
use warnings;
use 5.010;

sub show {
    our $fname;
    say $fname;        # Larry
    say $main::lname;  # Wall

    say $main::only_in_script;
    # Use of uninitialized value $only_in_script in say at examples/CreatorOfPerl.pm line 11.
}

1;

