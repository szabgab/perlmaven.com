use strict;
use warnings;
use Marpa::R2;
use Data::Dump;

my $syntax = <<'SYNTAX';
lexeme default = latm => 1

declaration ::= assignment* action => doResult
assignment ::= name '=' number action => doAssignNum
name ~ [\w]+
number ~ [\d]+

:discard ~ spaces
spaces ~ [\s]+
SYNTAX

my $grammar = Marpa::R2::Scanless::G->new({source => \$syntax});
my $input = <<INPUT;
x=1
y1 = 2 z = 3
wibble = 42
1 = 1 42=3
INPUT
my $result = $grammar->parse(\$input, 'main');

print Data::Dump::dump($$result);


sub doAssignNum     {
    my (@params) = @_;
    
    return {$params[1] => $params[3]};
    }


sub doResult     {
    my (@params) = @_;
    
    return {map {%$_} @params};
    }
