use 5.010;
use strict;
use warnings;

use Plack::App::CGIBin;
use Plack::Builder;
use FindBin;
use File::Spec;

my $path = File::Spec->catdir($FindBin::Bin, 'cgi-bin');

my $app = Plack::App::CGIBin->new(root => $path)->to_app;
builder {
    mount "/cgi" => $app;
};
