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
    my $path = path($filename);
    my $dir = $path->parent->stringify;
    my @entries;
    my @errors;
    my $cnt = 0;

    $self->{text} = '';

    for my $line ($path->lines_utf8) {
        $cnt++;
        if ($line =~ /^(#{1,6}) (\S.*)/) {
            push @entries, {
                tag => 'h' . length($1),
                text => $2,
            };
            next;
        }

# I should remember to always use \A instead of ^ even thoygh here we are really parsing lines so those two are the same
        if ($line =~ /\A ! \[([^\]]*)\]    \(([^\)]+)\)  \s* \Z/x) {
            my $title = $1;
            my $file_to_include = $2;
            eval {
                my $text = path("$dir/$file_to_include")->slurp_utf8;
                push @entries, {
                    tag   => 'code',
                    title => $title,
                    text  => $text,
                };
            };
            if ($@) {
                push @errors, {
                    row => $cnt,
                    line => $line,
                    error => "Could not read included file '$file_to_include'",
                };
            }
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

