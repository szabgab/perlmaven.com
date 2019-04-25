package App;
use strict;
use warnings;
use Dancer ':syntax';

get '/' => sub {
    return q{
    <h1>Echo with GET</h1>
    <form action="/echo" method="GET">
    <input type="text" name="txt">
    <input type="submit" value="Send">
    </form>
    };
};

get '/echo' => sub {
    return 'You sent: ' . param('txt');
};

true;

