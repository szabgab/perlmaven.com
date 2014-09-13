use strict;
use warnings;

use YAML;
use Test::More;
use Path::Iterator::Rule;
use Encode::Guess;
use Path::Tiny qw(path);

#plan tests => 2;

my $sites = 'sites.yml';

ok -e $sites;
eval {
	YAML::LoadFile($sites);
};
ok !$@, "Loading $sites" or diag $@;

my $rule = Path::Iterator::Rule->new;
$rule->name('*.tt');
my $it = $rule->iter('.');
while ( my $file = $it->() ) {
	#diag $file;
	# is this a reasonable test, or will this be always true?
	my @warns;
	local $SIG{__WARN__} = sub { push @warns, @_ };
	my $enc_utf8 = guess_encoding(path($file)->slurp_utf8);
	is ref $enc_utf8, 'Encode::utf8', "slurp_utf8 $file";
	is scalar @warns, 0, "no warnings for slurp_utf8 $file" or diag explain @warns;

	undef @warns;
	my $enc = guess_encoding(path($file)->slurp);
	like ref $enc, qr/^Encode::(utf8|XS)$/, "slurp $file";
	is scalar @warns, 0, "no warnings for slurp $file" or diag explain @warns;
}

done_testing;

