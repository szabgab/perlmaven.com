use strict;
use warnings;

use YAML::XS;
use Test::More;
use Path::Iterator::Rule;
use Encode::Guess;
use Path::Tiny qw(path);
use File::Basename qw(basename);
use Carp::Always;
use Try::Tiny qw(try catch);

#plan tests => 2;

my $sites = 'sites.yml';

ok -e $sites;
eval {
	YAML::XS::LoadFile($sites);
};
ok !$@, "Loading $sites" or diag $@;

my $rule = Path::Iterator::Rule->new;
$rule->name('*.txt');
my $it = $rule->iter('.');
while ( my $file = $it->() ) {
    try {
	    is basename($file), lc(basename($file)), 'filename is lower-case';
	    # is this a reasonable test, or will this be always true?
	    my @warns;
	    local $SIG{__WARN__} = sub { push @warns, @_ };
        my $content = path($file)->slurp_utf8;
	    my $enc_utf8 = guess_encoding($content);
	    is ref $enc_utf8, 'Encode::utf8', "slurp_utf8 $file";
	    is scalar @warns, 0, "no warnings for slurp_utf8 $file" or diag explain @warns;
        if ($content =~ /\t/) {
            fail("there are tabs in $file");
        }
        if ($content =~ /herf/) {
            fail("there is an herf in $file");
        }
        #if ($content =~ /^(.*\s)\n$/m) {
        #    fail("there trailing spaces in line '$1' in $file");
        #}

	    undef @warns;
	    my $enc = guess_encoding(path($file)->slurp);
	    like ref $enc, qr/^Encode::(utf8|XS)$/, "slurp $file";
	    is scalar @warns, 0, "no warnings for slurp $file" or diag explain @warns;
    } catch {
        my $exception = $_;
        fail("Exception '$exception' while processing file '$file'");
    };
}

my @resources = glob 'sites/*/resources.yml';
for my $file (@resources) {
	eval { YAML::XS::LoadFile($file) };
	is $@, '', $file;
}

done_testing;

