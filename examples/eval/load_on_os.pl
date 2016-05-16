use strict;
use warnings;

my %module = (
    'darwin' => 'App::OSX',
    'linux'  => 'App::Linux',
    'Win32'  => 'App::Win32',
);

if ($module{ $^O }) {
    eval $module{ $^O };
}
