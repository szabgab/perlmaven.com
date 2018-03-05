package Markua::Parser;
use strict;
use warnings;
use Path::Tiny qw(path);

sub new {
    my ($class) = @_;
    my $self = bless {}, $class;
    return $self;
}

sub parse_file {
    my ($self, $filename) = @_;
    my @entries;
    for my $line (path($filename)->lines_utf8) {
        if ($line =~ /^# (\S.*)/) {
            push @entries, {
                tag => 'h1',
                text => $1,
            };
        }
    }
    return \@entries;
}


1;

