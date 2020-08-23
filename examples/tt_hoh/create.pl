use strict;
use warnings;
use Template;

my %payload = (
    'TylerMontgomery(2022)' => {
                             'so' => 1,
                             'bb' => 1,
                             'rbis' => 0,
                             'atbats' => 117,
                             'runs' => 2,
                             'hits' => 2
                           },
    'ChaseLangan(2022)' => {
                               'runs' => 4,
                               'hits' => 24,
                               'atbats' => 5,
                               'bb' => 0,
                               'rbis' => 2,
                               'so' => 1
                             },
    'BryceJones(2021)' => {
                      'hits' => 2,
                      'runs' => 2,
                      'atbats' => 4,
                      'bb' => 2,
                      'rbis' => 4,
                      'so' => 1
                    },
);


my $tt = Template->new({
    INCLUDE_PATH => './templates',
    INTERPOLATE  => 1,
}) or die "$Template::ERROR\n";

my %data = (
    payload     => \%payload,
);

my $report;
$tt->process('report.tt', \%data, \$report) or die $tt->error(), "\n";
print $report;
