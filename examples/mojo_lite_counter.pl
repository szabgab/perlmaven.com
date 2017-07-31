use Mojolicious::Lite;

my $counter = 0;

get '/' => sub {
    my $c = shift;

    $counter++;
    $c->render(text => "$counter\n");
};

app->start;
