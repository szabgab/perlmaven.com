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

        # bulleted list
        if ($line =~ m{\A(\*)( {1,4}|\t)(\S.*)}) {
            my ($bullet, $space, $text) = ($1, $2, $3);
            if (not $self->{tag}) {
                $self->{tag} = 'list';
                $self->{list}{type} = 'bulleted';
                $self->{list}{bullet} = $bullet;
                $self->{list}{space} = $space;
                $self->{list}{ok} = 1;
                $self->{list}{items} = [$text];
                next;
            }

            if ($self->{tag} eq 'list') {
                if ($self->{list}{type} ne 'bulleted' or
                    $self->{list}{bullet} ne $bullet  or
                    $self->{list}{space} ne $space) {
                    $self->{list}{ok} = 0;
                }
                push @{ $self->{list}{items} }, $text;
                next;
            }

            die "What to do if a bulleted list starts in the middle of another element?";
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


    if ($self->{tag} and $self->{tag} eq 'list') {
        if ($self->{list}{ok}) {
            push @$entries, {
                tag => $self->{tag},
                list => $self->{list},
            };
            $self->{tag} = undef;
            delete $self->{list};
            return;
        }

        # If it is a failed list, convert if to paragraph
        $self->{tag} = 'p';
        $self->{text} = join '', @{ $self->{list}{items} };
        delete $self->{list};
    }

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

