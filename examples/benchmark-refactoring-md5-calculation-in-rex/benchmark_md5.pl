use strict;
use warnings;
use 5.010;

use Benchmark qw(cmpthese);
use lib 'lib';
use Rex::Commands::MD5;

my $small_file = '/etc/localtime';
my $large_file = '/tmp/1g';

say 'small files';

cmpthese(
    1000,
    {
        'current' => qq(Rex::Commands::MD5::md5_current('$small_file')),
        'current no script' =>
          qq(Rex::Commands::MD5::md5_current_no_script('$small_file')),
        'new' => qq(Rex::Commands::MD5::md5_new('$small_file')),
        'new binmode method' =>
          qq(Rex::Commands::MD5::md5_new_binmode_method('$small_file')),
        'md5sum' => qq(Rex::Commands::MD5::md5sum('$small_file')),
    }
);

say 'large files';
cmpthese(
    10,
    {
        'current' => qq(Rex::Commands::MD5::md5_current('$large_file')),
        'current no script' =>
          qq(Rex::Commands::MD5::md5_current_no_script('$large_file')),
        'new' => qq(Rex::Commands::MD5::md5_new('$large_file')),
        'new binmode method' =>
          qq(Rex::Commands::MD5::md5_new_binmode_method('$large_file')),
        'md5sum' => qq(Rex::Commands::MD5::md5sum('$large_file')),
    }
);
