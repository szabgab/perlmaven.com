package MyConf;
use Moo;
with 'MooX::Singleton';
 
use Config::Tiny;
 
has file => (is => 'ro', required => 1);
has conf => (is => 'rw');
 
sub BUILD {
    my ($self) = @_;
 
    print "BUILD called\n";
    my $conf = Config::Tiny->read($self->file, 'utf8')
	    or die sprintf "Could not get configuration from '%s'", $self->file;
    $self->conf($conf);
}
 
1;
