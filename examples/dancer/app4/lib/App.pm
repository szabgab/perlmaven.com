package App;
use strict;
use warnings;
use Dancer ':syntax';

get '/' => sub {
    return q{
    <h1>Echo with POST</h1>
    <form action="/echo" method="POST">
    <input type="text" name="txt">
    <input type="submit" value="Send">
    </form>
    };
};

post '/echo' => sub {
    return 'You sent: ' . param('txt');
};

true;

