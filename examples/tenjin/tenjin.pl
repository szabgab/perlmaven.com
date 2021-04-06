use strict;
use warnings;
use Tenjin;
$Tenjin::USE_STRICT = 1;

my $tenjin = Tenjin->new({ path => ['templates'] });
print $tenjin->render('simple.html', {
    title => 'This is the title',
    planets => ['Earth', 'Mars', 'Jupiter'],
})


