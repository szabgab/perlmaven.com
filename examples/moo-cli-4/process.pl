use Moo;
use MooX::Options;
use 5.010;

option verbose => (is => 'ro');
option file    => (is => 'ro', required => 1);

sub run {
    my ($self) = @_;
    if ($self->verbose) {
        say 'Processing ' . $self->file;
    }
}

main->new_with_options->run;
