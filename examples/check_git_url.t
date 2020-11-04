use strict;
use warnings;

use Test::More;
use LWP::UserAgent;

is check('https://github.com/szabgab/CPAN-Digger'), '200 OK';
is check('https://github.com/szabgab/no-such-repo'), '404 Not Found'; # same for private repositories
is check('https://github.com/szabgab/cpan-digger-new'), '200 OK';

is check_no_redirect('https://github.com/szabgab/CPAN-Digger'), '200 OK';
is check_no_redirect('https://github.com/szabgab/no-such-repo'), '404 Not Found'; # same for private repositories
is check_no_redirect('https://github.com/szabgab/cpan-digger-new'), '301 Moved Permanently';

done_testing;

sub check {
    my ($url) = @_;
    my $ua = LWP::UserAgent->new(timeout => 5);
    my $response = $ua->get($url);
    return $response->status_line;
}


sub check_no_redirect {
    my ($url) = @_;
    my $ua = LWP::UserAgent->new(timeout => 5, max_redirect => 0);
    my $response = $ua->get($url);
    return $response->status_line;
}


