use Test2::V0;
use Test2::Plugin::NoWarnings echo => 1;
use App;

ok( App::add(2), 2 );

done_testing();

