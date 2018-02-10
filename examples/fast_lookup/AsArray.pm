package AsArray;
use strict;
use warnings;

use Time::HiRes qw(time);
use List::Util qw(first);

sub new {
    my ($class) = @_;

    my $self = bless {}, $class;
    $self->{data} = [];

    return $self;
}

sub add {
    my ($self, $name, $payload) = @_;

    push @{ $self->{data} }, {
       name    => $name,
       payload => $payload,
       date    => time,
    };
    return;
}

sub remove_oldest {
    my ($self) = @_;
    return shift @{ $self->{data} }
}

sub remove_by_name {
    my ($self, $name) = @_;
    
    my $index = first { $name eq $self->{data}[$_]{name} } 0 .. @{ $self->{data} } - 1;
    my ($elem) = splice @{ $self->{data} }, $index, 1; 
    return $elem;
}

sub count {
    my ($self) = @_;
    return scalar @{ $self->{data} };
}


1;
