package App;
use strict;
use warnings;
use Dancer ':syntax';

set session => 'Simple';

get '/' => sub {
    my $text = session('txt') // '';
    return qq{
    <h1>Session</h1>
    Currently saved: <b>$text</b><p>
    <form action="/save" method="POST">
    <input type="text" name="txt">
    <input type="submit" value="Send">
    </form>
    <p>
    <a href="/delete">delete text</a>
    };
};

post '/save' => sub {
    my $text = param('txt');
    session txt => $text;
    return qq{
        You sent: <b>$text</b><p>
        Check it on the <a href="/">home page</a>
    };

};

get '/delete' => sub {
    session txt => undef;
    return 'DONE <a href="/">home</a>';
};

true;

