use strict;
use warnings;
use Marpa::R2;
use Data::Dump;

my $syntax = <<'SYNTAX';
lexeme default = latm => 1

quotedString ::= (dQuote) quotedCharStr (dQuote newLine) action => doValue

quotedCharStr ::= quotedCharacter action => doValue
    | quotedCharacter quotedCharStr action => doValues
    
quotedCharacter ::= nonQuote action => doValue
    | (slash) dQuote action => doValue

dQuote ~ ["]
slash ~ [\\]
nonQuote ~ [^"\\]+
newLine ~ [\n]
SYNTAX

my $grammar = Marpa::R2::Scanless::G->new({source => \$syntax});
my $input = <<TESTDATA;
"Quoted value with a \" in the value"
TESTDATA
my $result = $grammar->parse(\$input, 'main');

print Data::Dump::dump($$result);


sub doValue {
    my ($scratch, @params) = @_;

    return $params[0];
}


sub doValues {
    my ($scratch, @params) = @_;

    return join '', @params;
}


