use strict;
use warnings;
use 5.010;

use JSON::MaybeXS qw(encode_json decode_json);

my $student_json = '{"classes":["Chemistry","Math","Litreture"],"gender":null,"name":"Foo Bar","email":"foo@bar.com","address":{"city":"Fooville","planet":"Earth"}}';

my $student = decode_json $student_json;

use Data::Dumper;
print Dumper $student;

