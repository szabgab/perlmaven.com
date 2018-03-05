package Markua::Parser;
use strict;
use warnings;
use Path::Tiny qw(path);

our $VERSION = 0.01;

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;
    return $self;
}

sub parse_file {
    my ($self, $filename) = @_;
    my @entries;
    for my $line (path($filename)->lines_utf8) {
        if ($line =~ /^(#{1,6}) (\S.*)/) {
            push @entries, {
                tag => 'h' . length($1),
                text => $2,
            };
        }
    }
    return \@entries;
}


1;

