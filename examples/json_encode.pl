use strict;
use warnings;
use 5.010;

use Cpanel::JSON::XS qw(encode_json decode_json);

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

my $student_json = encode_json $student;
say $student_json;

