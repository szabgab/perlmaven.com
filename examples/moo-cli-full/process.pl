use Moo;
use MooX::Options;
use 5.010;
use Data::Dumper qw(Dumper);

option verbose => (is => 'ro', doc => 'Print details');
option file    => (is => 'ro', required => 1, format => 's',
    doc => 'File name to be processed');

has counter => (is => 'rw', default => 0);
option ips => (is => 'ro', doc => 'IP addresses', format => 's@', default => sub { [] } );

sub run {
    my ($self) = @_;
    if ($self->verbose) {
        say 'Processing ' . $self->file;
        say Dumper $self->ips;
        foreach my $ip (@{ $self->ips }) {
            say $ip;
        }
    }
}

main->new_with_options->run;
