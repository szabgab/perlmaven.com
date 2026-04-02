use strict;
use warnings;

# Plan: test all the examples in the books
# For the perl-testing course we run tests, many will fail as we are demonstrating failures.
# So we need to expect that.

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
      "t/cmp_ok.t" => "skip", # flaky
      "t/compute_test_plan.t" => "success",
      "t/copyright.t" => "fail",
      "t/done_testing.t" => "success",
      "t/exit.t" => "fail",
      "t/explain.t" => "success",
      "t/is_deeply.t" => "fail",
      "t/is_deeply_bugs.t" => "fail",
      "t/isnt_undef.t" => "fail",
      "t/last_update.t" => "skip", # flaky test
      "t/like.t" => "fail",
      "t/locale.t" => "success",
      "t/messages.t" => "success",
      "t/other.t" => "skip", # flaky test?
      "t/plan_tests.t" => "fail",
      "t/planned_subtest.t" => "fail",
      "t/skip.t" => "fail",
      "t/skip_all.t" => "success",
      "t/subtest.t" => "fail",
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
