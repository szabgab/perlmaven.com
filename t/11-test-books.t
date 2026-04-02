use strict;
use warnings;

use Cwd qw(cwd);
use Path::Iterator::Rule;
use IPC::Run qw(run timeout);

use Test::More;

my $root = cwd();
diag "root: $root";

my %cases = (
  "books/perl-testing/src/examples/test-more/" => {
      "t/30.t" => "fail",
      "t/31.t" => "fail",
      "t/32.t" => "fail",
      "t/34.t" => "success",
      "t/35.t" => "success",
      "t/bail_out.t" => "skip", # exit code is 65280
      "t/cmp_ok.t" => "fail",
      "t/compute_test_plan.t" => "success",
      "t/copyright.t" => "fail",
      "t/done_testing.t" => "success",
  }
);

for my $dir (keys %cases) {
    chdir $dir;
    diag cwd();
    my $rule = Path::Iterator::Rule->new;
    $rule->name('*.t');
    my $it = $rule->iter('t');
    while ( my $file = $it->() ) {
	    next if not exists $cases{$dir}{$file};
	die "Unhandled file $file" if not exists $cases{$dir}{$file};
	next if $cases{$dir}{$file} eq 'skip';

        my @cmd = ('prove', $file);
        my ($in, $out, $err);
        my $exit = run \@cmd, \$in, \$out, \$err, timeout( 10 );
        my $exit_code = $?;
	if ($cases{$dir}{$file} eq 'fail') {
            is $exit, '', "return $file";
	    #is $out, "", "out $file";
	    like $out, qr/Test Summary Report/, "out $file";
	    like $out, qr/Result: FAIL/, "out $file";
	    #is $err, "", "err $file";
	    like $err, qr/Failed test/, "err $file";
	    is $exit_code, 256, "exit_code $file";
	} elsif ($cases{$dir}{$file} eq 'success') {
            is $exit, 1, "return $file";
	    #is $out, "", "out $file";
	    like $out, qr/All tests successful./, "out $file";
	    like $out, qr/Result: PASS/, "out $file";
	    #is $err, "", "err $file";
	    is $exit_code, 0, "exit_code $file";
	} else {
	    die;
	}
    }
    chdir $root;
}

done_testing;
