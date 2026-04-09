package App;
use Dancer2;
use DateTime;

get '/' => sub {
    my $dt = DateTime->now;
    return $dt->strftime( 'The time is %Y-%m-%d %H:%M:%S' );
};

App->to_app;
