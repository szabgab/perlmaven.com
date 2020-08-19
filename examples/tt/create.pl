use strict;
use warnings;
use Template;

my $tt = Template->new({
    INCLUDE_PATH => './templates',
    INTERPOLATE  => 1,
}) or die "$Template::ERROR\n";

my %data = (
    title      => 'This is your title',
    languages  => ['English', 'Spanish', 'Hungarian', 'Hebrew'],
    people     => [
        { name => 'Foo', email => 'foo@perlmaven.com' },
        { name => 'Zorg' },
        { name => 'Bar', email => 'Bar@perlmaven.com' },
    ],
);
$tt->process('report.tt', \%data) or die $tt->error(), "\n";

