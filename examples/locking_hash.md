use strict;
use warnings;
use feature 'say';

use Hash::Util qw(lock_hash unlock_hash);
use Data::Dumper qw(Dumper);


my %person = (
    fname => "Foo",
    lname => "Bar",
);
lock_hash(%person);

print Dumper \%person;
print "$person{fname} $person{lname}\n";
say "fname exists ", exists $person{fname};
say "language exists ", exists $person{language};

# $person{fname} = "Peti";     # Modification of a read-only value attempted
# delete $person{lname};       # Attempt to delete readonly key 'lname' from a restricted hash
# $person{language} = "Perl";  # Attempt to access disallowed key 'language' in a restricted hash

unlock_hash(%person);

$person{fname} = "Peti";     # Modification of a read-only value attempted
delete $person{lname};       # Attempt to delete readonly key 'lname' from a restricted hash
$person{language} = "Perl";  # Attempt to access disallowed key 'language' in a restricted hash

print Dumper \%person;
