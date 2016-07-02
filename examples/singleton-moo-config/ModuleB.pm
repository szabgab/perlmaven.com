package ModuleB;
use 5.010;
use Moo;

sub do_something_else {
    my ($self) = @_;

    my $c = MyConf->instance(file => 'other.ini');
    my $a_name = $c->conf->{'section A'}{name};
    say $a_name;
}

1;
