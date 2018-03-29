#!/usr/bin/perl 
use strict;
use warnings;

my %phones;
$phones{Foo} = '111';
$phones{Qux} = undef;

print exists $phones{Foo}  ? "Foo exists\n"   : "Foo does not exist\n";
print defined $phones{Foo} ? "Foo: defined\n" : "Foo not defined\n";

print exists $phones{Qux}  ? "Qux exists\n"   : "Qux does not exist\n";
print defined $phones{Qux} ? "Qux: defined\n" : "Qux not defined\n";

print exists $phones{Bar}  ? "Bar exists\n"   : "Bar does not exist\n";
print defined $phones{Bar} ? "Bar: defined\n" : "Bar not defined\n";
