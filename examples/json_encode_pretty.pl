use strict;
use warnings;
use 5.010;

use JSON::MaybeXS ();

my $student = {
    name => 'Foo Bar',
    email => 'foo@bar.com',
    gender => undef,
    classes => [
        'Chemistry',
        'Math',
        'Litreture',
    ],
    address => {
        city => 'Fooville',
        planet => 'Earth',
    },
};

my $json = JSON::MaybeXS->new(utf8 => 1, pretty => 1);
my $student_json = $json->encode($student);
say $student_json;


