use Moo;
use 5.010;

has verbose => (is => 'ro');
has file    => (is => 'ro', required => 1);

sub run {
    my ($self) = @_;
    if ($self->verbose) {
        say 'Processing ' . $self->file;
    }
}

my ($file, $verbose) = @ARGV;
die "Usage: $0 FILE [1]\n" if not $file;

main->new(file => $file, verbose => $verbose)->run;
