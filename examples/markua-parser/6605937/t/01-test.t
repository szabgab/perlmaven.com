use strict;
use warnings;

use Test::More;
use JSON::MaybeXS qw(decode_json);
use Path::Tiny qw(path);
use Markua::Parser;

my @cases = ('heading1', 'headers', 'paragraphs', 'include');

plan tests => 1 + 2 * scalar @cases;

my $m = Markua::Parser->new;
isa_ok $m, 'Markua::Parser';

for my $case (@cases) {
    my ($result, $errors) = $m->parse_file("t/input/$case.md");
    is_deeply $result, decode_json( path("t/dom/$case.json")->slurp_utf8 ) or diag explain $result;
    my $expected_errors = [];
    my $error_path = path("t/errors/$case.json");
    if ($error_path->exists) {
        $expected_errors = decode_json( $error_path->slurp_utf8 );
    }
    is_deeply $errors, $expected_errors, "Errors of $case" or diag explain $errors;
}

