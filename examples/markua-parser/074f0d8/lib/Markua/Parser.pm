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
    my @errors;
    my $cnt = 0;

    $self->{text} = '';

    for my $line (path($filename)->lines_utf8) {
        $cnt++;
        if ($line =~ /^(#{1,6}) (\S.*)/) {
            push @entries, {
                tag => 'h' . length($1),
                text => $2,
            };
            next;
        }

        # anything else defaults to paragraph
        if ($line =~ /\S/) {
            $self->{tag} = 'p';
            $self->{text} .= $line;
            next;
        }

        if ($line =~ /^\s*$/) {
            $self->save_tag(\@entries);
            next;
        }

        push @errors, {
            row => $cnt,
            line => $line,
        }
    }
    $self->save_tag(\@entries);
    return \@entries, \@errors;
}

sub save_tag {
    my ($self, $entries) = @_;

    if ($self->{tag}) {
        $self->{text} =~ s/\n+\Z//;
        push @$entries, {
            tag => $self->{tag},
            text => $self->{text},
        };
        $self->{tag} = undef;
        $self->{text} = '';
    }
    return;
}


1;

