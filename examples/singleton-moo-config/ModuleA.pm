package ModuleA;
use 5.010;
use Moo;

sub do_something {
    my ($self) = @_;

    my $c = MyConf->instance();
    my $a_name = $c->conf->{'section A'}{name};
    say $a_name;
}

1;
