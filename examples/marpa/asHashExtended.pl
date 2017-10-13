use strict;
use warnings;
use Marpa::R2;
use Data::Dump;

# http://perlmonks.org/?node_id=574311

my $syntax = <<'SYNTAX';
lexeme default = latm => 1

declaration ::= assignment* action => doResult
    
assignment ::= name '=' number action => doAssignNum
    | name '=' string action => doAssignStr

string ::= ['] chars1 ['] action => [values]
    | '"' chars2 '"' action => [values]
    
chars1 ~ [^']*
chars2 ~ [^"]*

name ~ [\w]+
number ~ [\d]+

:discard ~ spaces
spaces ~ [\s]+
SYNTAX

my $grammar = Marpa::R2::Scanless::G->new({source => \$syntax});
my $input = <<INPUT;
x = 1
y = 2
z = 3
wibble = 42
wobble = "twenty three"
INPUT
my $result = $grammar->parse(\$input, 'main');

print Data::Dump::dump($$result);


sub doAssignNum     {
    my (@params) = @_;
    
    return {$params[1] => $params[3]};
    }


sub doAssignStr     {
    my (@params) = @_;
    
    return {$params[1] => $params[3][1]};
    }


sub doResult     {
    my (@params) = @_;
    
    return {map {%$_} grep {'HASH' eq ref $_} @params};
    }
