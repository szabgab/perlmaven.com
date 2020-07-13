use Moo;
use 5.010;

has file => (is => 'ro', required => 1);

sub run {
    my ($self) = @_;
    say 'Processing ' . $self->file;
}

my $file = shift or die "Usage: $0 FILE\n";

main->new(file => $file)->run;
