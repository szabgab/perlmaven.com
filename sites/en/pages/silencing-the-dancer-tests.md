---
title: "Silencing the noisy Dancer tests"
timestamp: 2016-05-05T23:30:01
tags:
  - Dancer2
  - Test::NoWarnings
published: true
books:
  - dancer2
author: szabgab
archive: true
---


If you have followed the development and ran the tests, you might have noticed that running the tests is very noisy.


The result of `make test` looks like this:

```
PERL_DL_NONLAZY=1 "/Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/001_base.t ......... ok
t/002_index_route.t .. 1/2 [D2::Ajax:97653] core @2015-05-28 13:18:51> looking for get / in /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm l. 1171
[D2::Ajax:97653] core @2015-05-28 13:18:51> Entering hook core.app.before_request in (eval 52) l. 1
[D2::Ajax:97653] core @2015-05-28 13:18:51> Entering hook core.app.after_request in (eval 52) l. 1
t/002_index_route.t .. ok
t/v1.t ............... [D2::Ajax:97654] core @2015-05-28 13:18:51> looking for get /api/v1/greeting in /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm l. 1171
[D2::Ajax:97654] core @2015-05-28 13:18:51> Entering hook core.app.before_request in (eval 52) l. 1
[D2::Ajax:97654] core @2015-05-28 13:18:51> Entering hook core.app.after_request in (eval 52) l. 1
t/v1.t ............... ok
t/v2.t ............... [D2::Ajax:97655] core @2015-05-28 13:18:52> looking for get /api/v2/greeting in /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm l. 1171
[D2::Ajax:97655] core @2015-05-28 13:18:52> Entering hook core.app.before_request in (eval 52) l. 1
[D2::Ajax:97655] core @2015-05-28 13:18:52> Entering hook core.app.after_request in (eval 52) l. 1
t/v2.t ............... 1/2 [D2::Ajax:97655] core @2015-05-28 13:18:52> looking for get /api/v2/reverse in /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm l. 1171
[D2::Ajax:97655] core @2015-05-28 13:18:52> Entering hook core.app.before_request in (eval 52) l. 1
[D2::Ajax:97655] core @2015-05-28 13:18:52> Entering hook core.app.after_request in (eval 52) l. 1
[D2::Ajax:97655] core @2015-05-28 13:18:52> looking for get /api/v2/reverse in /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm l. 1171
[D2::Ajax:97655] core @2015-05-28 13:18:52> Entering hook core.app.before_request in (eval 52) l. 1
[D2::Ajax:97655] core @2015-05-28 13:18:52> Entering hook core.app.after_request in (eval 52) l. 1
[D2::Ajax:97655] core @2015-05-28 13:18:52> looking for get /api/v2/reverse in /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm l. 1171
[D2::Ajax:97655] core @2015-05-28 13:18:52> Entering hook core.app.before_request in (eval 52) l. 1
Use of uninitialized value $text in reverse at /Users/gabor/work/D2-Ajax/blib/lib/D2/Ajax.pm line 33.
[D2::Ajax:97655] core @2015-05-28 13:18:52> Entering hook core.app.after_request in (eval 52) l. 1
t/v2.t ............... ok
All tests successful.
Files=4, Tests=6,  2 wallclock secs ( 0.04 usr  0.02 sys +  1.87 cusr  0.24 csys =  2.17 CPU)
Result: PASS
```

A lot of that noise comes from the logging facilities of Dancer that in the development environment
which uses the `environments/development.yml` configuration file is set to at level `core`.
It might be useful during development, but I find that distracting during testing.

The solution I found was to use a separate environment for testing. I think this can be useful later
on if we want to set other special values during testing. For now I've just set the Dancer envrionment
to be "test" and to create `environments/test.yml` where I can set `log: "warning"`.

In order to tell the tests to use this environment variable we can add

```perl
BEGIN {
    $ENV{DANCER_ENVIRONMENT} = 'test';
}
```

to the beginning of every test script.
It has to be in a [BEGIN block](/begin) and it has to be before the `use D2::Ajax;` statement,
loading the main module of our application, in order for Dancer to use it.

If we run `make tests` now the output looks like this:

```
PERL_DL_NONLAZY=1 "/Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/001_base.t ......... ok
t/002_index_route.t .. ok
t/v1.t ............... ok
t/v2.t ............... 1/2 Use of uninitialized value $text in reverse at /Users/gabor/work/D2-Ajax/blib/lib/D2/Ajax.pm line 33.
t/v2.t ............... ok
All tests successful.
Files=4, Tests=6,  2 wallclock secs ( 0.04 usr  0.02 sys +  1.72 cusr  0.15 csys =  1.93 CPU)
Result: PASS
```

Not only is that much nicer to see and clearer to read, it also reveals a warning that I have not noticed earlier.

Let's [commit](https://github.com/szabgab/D2-Ajax/commit/8f631d2386b3a8a5064a3bef426db759499e6bf0) this now and then look at the warning.


## Make sure no more warnings will go unnoticed

Before fixing this warning, let's make sure no new warnings will go unnoticed. We can add
an extra test that will check if there was any warning during the test run and fail the test-script it there was any warning.

If we load the [Test::NoWarnings](http://metacpan.org/pod/Test::NoWarnings) module will capture all the warnings
during the test-run and report them as failure at the end. In order to use it we only need to load the module with a

```
use Test::NoWarnings;
```

statement, and increment the test counter by one.

After adding this the result of `make test` is a nasty error report:

```
cp lib/D2/Ajax.pm blib/lib/D2/Ajax.pm
PERL_DL_NONLAZY=1 "/Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/001_base.t ......... ok
t/002_index_route.t .. ok
t/v1.t ............... ok
t/v2.t ............... 1/3
#   Failed test 'no warnings'
#   at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Test/NoWarnings.pm line 45.
# There were 1 warning(s)
#   Previous test 5 ''
#   Use of uninitialized value $text in reverse at /Users/gabor/work/D2-Ajax/blib/lib/D2/Ajax.pm line 33.
#  at /Users/gabor/work/D2-Ajax/blib/lib/D2/Ajax.pm line 33.
#   D2::Ajax::__ANON__(Dancer2::Core::App=HASH(0x7fe4fbe4f1d8)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/Route.pm line 136
#   Dancer2::Core::Route::execute(Dancer2::Core::Route=HASH(0x7fe4fc825dd8), Dancer2::Core::App=HASH(0x7fe4fbe4f1d8)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm line 1362
#   eval {...} called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm line 1363
#   Dancer2::Core::App::_dispatch_route(Dancer2::Core::App=HASH(0x7fe4fbe4f1d8), Dancer2::Core::Route=HASH(0x7fe4fc825dd8)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm line 1251
#   Dancer2::Core::App::__ANON__(CODE(0x7fe4fd3e0f88)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Return/MultiLevel.pm line 36
#   Return::MultiLevel::with_return(CODE(0x7fe4fd3e1138)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm line 1252
#   Dancer2::Core::App::dispatch(Dancer2::Core::App=HASH(0x7fe4fbe4f1d8), HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm line 1169
#   eval {...} called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/App.pm line 1171
#   Dancer2::Core::App::__ANON__(HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Middleware/RemoveRedundantBody.pm line 14
#   Plack::Middleware::RemoveRedundantBody::call(Plack::Middleware::RemoveRedundantBody=HASH(0x7fe4fd3b4c80), HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Component.pm line 50
#   Plack::Component::__ANON__(HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Middleware/FixMissingBodyInRedirect.pm line 50
#   Plack::Middleware::FixMissingBodyInRedirect::call(Plack::Middleware::FixMissingBodyInRedirect=HASH(0x7fe4fd3b4d58), HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Component.pm line 50
#   Plack::Component::__ANON__(HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Middleware/ContentLength.pm line 10
#   Plack::Middleware::ContentLength::call(Plack::Middleware::ContentLength=HASH(0x7fe4fd3b4e30), HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Component.pm line 50
#   Plack::Component::__ANON__(HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Middleware/Static.pm line 18
#   Plack::Middleware::Static::call(Plack::Middleware::Static=HASH(0x7fe4fd3b5178), HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Component.pm line 50
#   Plack::Component::__ANON__(HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Middleware/Conditional.pm line 16
#   Plack::Middleware::Conditional::call(Plack::Middleware::Conditional=HASH(0x7fe4fd3b52c8), HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Component.pm line 50
#   Plack::Component::__ANON__(HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Middleware/Head.pm line 9
#   Plack::Middleware::Head::call(Plack::Middleware::Head=HASH(0x7fe4fd3b5160), HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Component.pm line 50
#   Plack::Component::__ANON__(HASH(0x7fe4fd3e1180)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Test/MockHTTP.pm line 24
#   Plack::Test::MockHTTP::try {...} () called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Try/Tiny.pm line 79
#   eval {...} called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Try/Tiny.pm line 72
#   Try::Tiny::try(CODE(0x7fe4fd3b53b8), Try::Tiny::Catch=REF(0x7fe4fd3e1870)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Plack/Test/MockHTTP.pm line 27
#   Plack::Test::MockHTTP::request(Plack::Test::MockHTTP=HASH(0x7fe4fd3b53e8), HTTP::Request=HASH(0x7fe4fd3d84b8)) called at t/v2.t line 44
#   main::__ANON__() called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Test/Stream/Block.pm line 72
#   Test::Stream::Block::run(Test::Stream::Block=ARRAY(0x7fe4fa02d6a0)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Test/Stream/Subtest.pm line 38
#   Test::Stream::Subtest::__ANON__() called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Test/Stream/Util.pm line 72
#   eval {...} called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Test/Stream/Util.pm line 72
#   Test::Stream::Util::_local_try(CODE(0x7fe4fc86d440)) called at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Test/Stream/Subtest.pm line 52
#   Test::Stream::Subtest::subtest("v2_reverse", CODE(0x7fe4fc8713a0)) called at t/v2.t line 46
#
# Looks like you failed 1 test of 3.
t/v2.t ............... Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/3 subtests

Test Summary Report
-------------------
t/v2.t             (Wstat: 256 Tests: 3 Failed: 1)
  Failed test:  3
  Non-zero exit status: 1
Files=4, Tests=8,  3 wallclock secs ( 0.04 usr  0.02 sys +  1.87 cusr  0.23 csys =  2.16 CPU)
Result: FAIL
Failed 1/4 test programs. 1/8 subtests failed.
make: *** [test_dynamic] Error 1
```

[commit](https://github.com/szabgab/D2-Ajax/commit/1b02b209cd1cc88306a8ad060f907ca5084bf96a)

## Fixing the uninitialized value warning

The area that generated the waning is this route, specifically line 33 is the line where we call `reverse`.

```perl
get '/api/v2/reverse' => sub {
    my $text = param('str');
    my $rev = reverse $text;
    return to_json { text => $rev };
};
```

The problem is that in some of the cases `$text` is not initialized. We can easily fix this by setting it to
the empty string if if was [>undef](/undef-and-defined-in-perl) using the
[defined-or operator](/what-is-new-in-perl-5.10--say-defined-or-state) that was introduced in perl 5.10.

The result is this:

```perl
get '/api/v2/reverse' => sub {
    my $text = param('str') // '';
    my $rev = reverse $text;
    return to_json { text => $rev };
};
```

If we run `make test` again we get that all the tests pass again.

[commit](https://github.com/szabgab/D2-Ajax/commit/d13335c8bb8e8fc6bdca5c8ecb98026cc6ac39e8)
