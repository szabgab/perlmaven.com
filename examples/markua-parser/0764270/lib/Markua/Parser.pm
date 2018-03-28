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

        # numbered list
        if ($line =~ m{\A(\d+)([.\)])( {1,4}|\t)(\S.*)}) {
            my ($number, $sep, $space, $text) = ($1, $2, $3, $4);
            if (not $self->{tag}) {
                $self->{tag} = 'numbered-list';
                $self->{list} = [];
            }

            if ($self->{tag} eq 'numbered-list') {
                push @{ $self->{list} }, {
                        number => $number,
                        sep    => $sep,
                        space  => $space,
                        text   => $text,
                        raw    => $line,
                };
                next;
            }

            die "What to do if a numbered list starts in the middle of another element?";
        }

        # bulleted list
        if ($line =~ m{\A([\*-])( {1,4}|\t)(\S.*)}) {
            my ($bullet, $space, $text) = ($1, $2, $3);
            if (not $self->{tag}) {
                $self->{tag} = 'list';
                $self->{list}{type} = 'bulleted';
                $self->{list}{bullet} = $bullet;
                $self->{list}{space} = $space;
                $self->{list}{ok} = 1;
                $self->{list}{items} = [$text];
                $self->{list}{raw} = [$line];
                next;
            }

            if ($self->{tag} eq 'list') {
                if ($self->{list}{type} ne 'bulleted' or
                    $self->{list}{bullet} ne $bullet  or
                    $self->{list}{space} ne $space) {
                    $self->{list}{ok} = 0;
                }
                push @{ $self->{list}{raw} }, $line;
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

    if ($self->{tag} and $self->{tag} eq 'numbered-list') {
        # TODO: verify that it is a proper list
        for my $row (@{ $self->{list} }) {
            delete $row->{raw};
            delete $row->{sep};
            delete $row->{space};
        }
        push @$entries, {
            tag => $self->{tag},
            list => $self->{list},
        };
        $self->{tag} = undef;
        delete $self->{list};
        return;
    }


    if ($self->{tag} and $self->{tag} eq 'list') {
        if ($self->{list}{ok}) {
            delete $self->{list}{raw};
            delete $self->{list}{ok};
            delete $self->{list}{space};
            delete $self->{list}{bullet};
            push @$entries, {
                tag => $self->{tag},
                list => $self->{list},
            };
            $self->{tag} = undef;
            delete $self->{list};
            return;
        }

        # If it is a failed list, convert it to paragraph
        $self->{tag} = 'p';
        $self->{text} = join '', @{ $self->{list}{raw} };
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

__END__

=head1 NAME

Markua::Parser - Parsing Markua files and for writing books, generating DOM

=head1 SYNOPSIS

    use Markua::Parser;
    my $m = Markua::Parser->new;
    my ($result, $errors) = $m->parse_file("path/to/file.md");

=head1 DESCRIPTION

L<Markua|https://leanpub.com/markua/read> is a Markdown inspired language to write books.
It was created by Peter Armstrong for L<LeanPub|https://leanpub.com/>
They have an in-house partial implementation in Ruby.

This is an Open Source partial implementation in Perl.

The development process is described in the L<Creating a Markua Parser in Perl 5|https://leanpub.com/markua-parser-in-perl5> eBook.

=head1 COPYRIGHT

Copyright 2018 Gabor Szabo L<https://szabgab.com/>

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl 5 itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.


=cut

# Copyright 2018 Gabor Szabo https://szabgab.com/
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

