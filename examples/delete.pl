#!/usr/bin/perl 
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my %phones = (
    Foo => '111',
    Bar => '222',
    Moo => undef,
);

print exists $phones{Foo}  ? "Foo exists\n"        : "Foo does not exist\n";
print Dumper \%phones;


delete $phones{Foo};

print exists $phones{Foo}  ? "Foo exists\n"        : "Foo does not exist\n";
print Dumper \%phones;


