use strict;
use warnings;

use Test::More;
use JSON::MaybeXS qw(decode_json);
use Path::Tiny qw(path);
use Markua::Parser;

my @cases = ('heading1', 'headers', 'paragraphs');

plan tests => 1 + 2 * scalar @cases;

my $m = Markua::Parser->new;
isa_ok $m, 'Markua::Parser';

for my $case (@cases) {
    my ($result, $errors) = $m->parse_file("t/input/$case.md");
    is_deeply $result, decode_json( path("t/dom/$case.json")->slurp_utf8 );
    is_deeply $errors, [], "Errors of $case" or diag explain $errors;
}

