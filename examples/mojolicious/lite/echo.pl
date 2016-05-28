use Mojolicious::Lite;

get '/' => { text => 'Hello World' };

get '/echo' => { text => q{
       <form method="POST"><input name="q"><input type="submit" value="Echo"></form>
}};

post '/echo' => sub {
    my $self = shift;
    $self->render( text => $self->param('q') );
};

app->secrets(['My very secret passphrase.']);
app->start;



