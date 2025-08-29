---
title: "Migrating (the Perl Maven site) from Dancer 1 to Dancer2"
timestamp: 2014-12-11T12:30:01
tags:
  - Dancer
  - Dancer2
published: true
books:
  - dancer2
author: szabgab
archive: true
---


The [Perl Maven](https://github.com/szabgab/Perl-Maven) site was based
on the [Perl Dancer web framework](/dancer), more specifically
on [Dancer](https://metacpan.org/pod/Dancer), the first major version of the framework.

Dancer has a couple of issues I encountered that caused a lot of headache. I had several choices

<ol>
  <li>Leave Dancer and Write it based on plain [PSGI/Plack](/psgi).</li>
  <li>Abandon Dancer and write in it some other framework such as [Mojolicious](/mojolicious) or [Catalyst](/catalyst).</li>
  <li>Fix the issues in Dancer</li>
  <li>Migrate to Dancer2</li>
</ol>

I decided to try to migrate to Dancer 2. This article is (going to be) both a diary of the process,
and hopefully a helping guide to others who would like to make similar migration.


Before we go on, let's first see why leave Dancer 1, and why try to migrate to Dancer 2 instead of any of the other options outlined above?

## Why Migrate to Dancer 2 ?

In the last couple of days I have spent an enormous time trying to get Dancer do something that it probably cannot do.
Specifically I wanted to create sessions and set cookies conditionally so I can avoid creating thousands of sessions for each request
of each bot visiting the site. (If sessions are enabled, Dancer will create a session just because the `template()` function is called to render
a page. I [asked about this](http://lists.preshweb.co.uk/pipermail/dancer-users/2014-December/004199.html) and the answer was that
it probably will not be changed in Dancer 1. (Which is OK, they don't want to break backward compatibility and they don't want to spend a lot of time
on the maintenance version of Dancer.) I tried to enable/disable sessions on the fly, but apparently it does not work with the Plack::Builder
deployment example explained [here](https://metacpan.org/pod/Dancer::Deployment#In-case-you-have-issues-with-Template::Toolkit-on-Dotcloud).
I have not even reported this issue because I assume they won't want to work much on the now maintenance version of Dancer.

Another thing I wanted to do is to configure the session_domain based on the current request and some configuration option.
Dancer, by default, sets the cookie for the exact hostname of the request so visiting [ru.perlmaven.com](https://ru.perlmaven.com/)
and [br.perlmaven.com](https://br.perlmaven.com/) would (and used to) yield two cookies. I could change this by setting the
`session_domain` option in the configuration file, but as I want to make the application available to host other sites as well,
I wanted this to be configured on-the-fly. I could not do this either.

I could try to delve into the source code of Dancer 1 to try to fix these, but do I really want to invest my time and energy in that?
Would they even accept fixes for these issues? I have not seen a lot of Development on Dancer 1 recently, it seems that most of the
effort goes into Dancer 2.

So I arrived at the conclusion that I need to abandon Dancer 1 and find an alternative.

### PSGI/Plack

I could rewrite the application in [raw PSGI/Plack](/psgi). I have been using it for the
[search.cpan.org cloning project](/search-cpan-org) and in another project. It is fun, but as I could see from
these projects I have been reinventing certain parts of Dancer. Specifically, I already had a `template()` function and
a route dispatcher which also acted as both a "before" and "after" hook.

This is all fine, but why reinvent the wheel? Will my solution be better? Well, maybe it won't have the same bugs as Dancer has,
but I am sure I'll have plenty of other bugs. After all, Dancer has been developed by many people each one of them being a better
programmer than I am. Even if that was not true, the fact that it has been used by a lot of people means it has been field-tested
by many people. So using raw PSGI/Plack might be a small step forward, but it will also be a big step backward.

### Mojolicious or Catalyst

Switching to either [Mojolicious](/mojolicious) or [Catalyst](/catalyst) would required a major rewrite,
and neither of those seem to be more appealing to me than Dancer. In my perception, Catalyst is too big for this application,
and Mojolicious feels like a moving target. It might be fun, but I want to spend my time on serving my customers and not running
after the changes in the framework I use.

### Fix the issues in Dancer 1

This would certainly be a very good option. Maybe this would require the smallest additional work from me, but because Dancer 1
is in maintenance mode it will be probably harder to get changes in the code-base, and there will be fewer people willing to
improve it. Most importantly, it feels like a waste of time. Eventually the core Dancer developers will all move to Dancer 2
and I will either use an abandoned version of the framework, or will have to migrate to Dancer 2 anyway.

### Migrating to Dancer 2

While I hear encouraging words from Sawyer and the [2014 Perl Dancer Advent calendar](http://advent.perldancer.org/2014)
is full of optimism with Dancer 2, I have not actually seen any application written in Dancer 2 yet, and I have not heard
about any company that have migrated to Dancer 2 either.

I am sure there will be issues. Probably a lot more issues than Dancer has currently, but it is being developed.
So probably, if I report the bugs, they will be fixed much sooner than bugs in Dancer 1.
Even if others don't fix it, it will feel much better to invest time in improving the next version of Dancer,
than the previous one.

So that's it. I am going to start the migration to [Dancer 2](https://metacpan.org/pod/Dancer2),
and I'll record my process here.

I am not sure if this is the best process to do it, and if you follow it you might fall in the same pitfalls I did,
or you might avoid them because you see my mistakes. In any case, I'd also recommend looking at
[Dancer2::Manual::Migration](https://metacpan.org/pod/Dancer2::Manual::Migration),
the migration document that comes with Dancer 2. It has some good advice and if it is missing some information,
you can always as on the Dancer mailing list.

## Create a branch for the Dancer 2 migration

The very first thing was to create a branch called
[dancer2](https://github.com/szabgab/Perl-Maven/tree/dancer2) in the
[GitHub repository](https://github.com/szabgab/Perl-Maven) of the project.
I'll use that branch for the migration, and I can still make progress with the application
while the migration stabilizes.

I'll keep rebasing it to master as I make progress.

## Update Makefile.PL with the new prerequisites

The next thing I did was replacing the Dancer requirements by Dancer2 requirements in the `Makefile.PL`
of the project and installing the modules. Besides [Dancer](https://metacpan.org/pod/Dancer),
the only Dancer-related plug I have been using was the [Dancer::Plugin::Passphrase](https://metacpan.org/pod/Dancer::Plugin::Passphrase).

So I changed Dancer to Dancer2 in both of these names and tried to install the respective modules.

I managed to install [Dancer2](https://metacpan.org/pod/Dancer2) without any problems, but
installing [Dancer2::Plugin::Passphrase](https://metacpan.org/pod/Dancer2::Plugin::Passphrase) failed.
I have [reported it here](http://lists.preshweb.co.uk/pipermail/dancer-users/2014-December/004212.html),
but the response was basically to wait.

Not a good start, but this does not need to totally stop me. I might be able to migrate other parts of the system,
faking that module while I wait for it to be fixed.

**Update:** within two days the module was fixed, I could install it on both OSX and Linux.

Because of this failure, I have commented out the requirement for Dancer2::Plugin::Passphrase.

As I have been using [Travis-CI](https://travis-ci.org/) to provide continuous integration for
the [Perl-Maven](https://github.com/szabgab/Perl-Maven) code-base, I could use that as place
to see which parts of the code-base need to be updated.

So I pushed out the first change and got the
[first failure report](https://travis-ci.org/szabgab/Perl-Maven/builds/43599657) from Travis-CI.

Not so surprisingly, the main (or even the only?) complaint was the missing of the Dancer module, when trying
to load the application in various tests scripts.

## use Dancer ':syntax';    to Dancer2

As the failure reported by travis was the lack of the Dancer module, the next step seemed to be natural to
replace the

```perl
use Dancer ':syntax';
```

statement with

```perl
use Dancer2;
```

statement in the `Perl::Maven` module, and with

```perl
use Dancer2 appname => 'Perl::Maven';
```

in the `Perl::Maven::Admin`, `Perl::Maven::PayPal`, and `Perl::Maven::WebTools` modules.

In addition, there was a use of the [Dancer::Template::TemplateToolkit](https://metacpan.org/pod/Dancer::Template::TemplateToolkit)
module. the actual use might not be necessary any more, but for now, I've replaced it with the used of the Dancer2 version of the same module.

As I can understand from the [migration guide](https://metacpan.org/pod/Dancer2::Manual::Migration), there is no more need
for the `':syntax'` part.

In addition, because the [Dancer2::Plugin::Passphrase](https://metacpan.org/pod/Dancer2::Plugin::Passphrase) could not be installed yet,
I've created a module called **Fake**, that will mock the behavior of the `passphrase` function. Luckily the API of that function
was very simple. Having this fake version of it will allow me to continue with the migration process and see if I encounter other problems,
even before the Passphrase issue is fixed.

This is `Fake.pm`

```perl
package Fake;
use strict;
use warnings;

our $VERSION = '0.11';

use Exporter qw(import);
our @EXPORT_OK = qw(passphrase);

sub passphrase {
    my ($password) = @_;
    return bless { password => $password}, 'Fake';
}

sub generate {
    my ($self) = @_;
    return $self->{password};
}

sub matches {
    my ($self, $password) = @_;
    return $self->{password} eq $password;
}


1;
```

then I ran the tests and also committed the changes to see what Travis-CI will tell us.

**Update:** the Dancer2::Plugin::Passphrase module was fixed and I could get rid of the Fake.pm.
Nevertheless I left it here in case you encounter a similar situation with another module.

Even before I got back the results from Travis-CI I ran the tests myself and got the following error message:

`Engine 'template_toolkit' is not supported.`

## Template::Toolkit

In order to understand what's going on, I created two applications using the
`dancer -a` and the `dancer2 -a` commands and compared the configuration files.

The result of my research is the following:

The "Dancer 1 way" to enable the use of <a href="">Template::Toolkit</a> was to add
the following line to `config.yml`:

```
template: "template_toolkit"
```

That was enough to get started. The start_tag and end_tag it used were the same as in
the simple template &lt;% and %&gt; respectively.

In the Perl::Maven application we had this:

```
template: "template_toolkit"
engines:
  template_toolkit:
    encoding:  'utf8'
    INCLUDE_PATH: 'views'
```

(I think that INCLUDE_PATH thing is just a left-over from one of my experiments.)

In Dancer 2 you can also enable Template::Toolkit with the same configuration option:

```
template: "template_toolkit"
```

that wasn't the issue.

The issue was that in the `engine` configuration option an extra level called
`template` was added.
Now, instead of the above, we need to write:

```
template: "template_toolkit"
engines:
  template:
    template_toolkit:
      encoding:  'utf8'
      INCLUDE_PATH: 'views'
```

That still does not seem to be enough. As my experiments showed, the default start_tag and end_tag are now [% and %],
(these are the same that Template::Toolkit really uses as defaults), but we have &lt;% and %&gt;
so we need to change the start_tag and end_tag values.

So we got the following section in the configuration file:

```
template: "template_toolkit"
engines:
  template:
    template_toolkit:
      encoding:  'utf8'
      INCLUDE_PATH: 'views'
      start_tag: '<%'
      end_tag:   '%>'
```

I committed the changes here, but by that time I got  [the report from Travis-CI](https://travis-ci.org/szabgab/Perl-Maven/builds/43621897)
and it showed the problem there is still the missing `Dancer.pm` module. Now I started to wonder where else is it loaded that the tests
fail.

It wasn't difficult to find them using `ack 'use Dancer'`. Three of the tests scripts load it directly using
`use Dancer qw(:tests);`.


## Perl::Critic - Dancer2 also implies use strict

In addition, I noticed that a lot of the tests fail on my system with reports from <a href="https://metacpan.org/pod/Perl::Critic">Perl::Critic.
Specifically they complain about `Code before strictures are enabled`

The Perl::Maven project has a [.perlcriticrc](https://github.com/szabgab/Perl-Maven/blob/master/.perlcriticrc) file in which
we have an entry:

```
[TestingAndDebugging::RequireUseStrict]
equivalent_modules = Moo Dancer

[TestingAndDebugging::RequireUseWarnings]
severity = 5
equivalent_modules = Moo Dancer
```

This tells Perl::Critic, to accept having `use Moo`, or `use Dancer` instead of having
`use strict;` and `use warnings;`. That's correct, because `use Dancer;` indeed
loads both the `strict` and `warnings` pragma.

The same is true for `use Dancer2` so we also need to tell Perl::Critic to stop complaining.
I added `Dancer2` in the list of `equivalent_modules` for both entries.

With that noise out of the way it is much easier to focus on the real issues.

Which is still having `use Dancer` in some places as the
[Travis report](https://travis-ci.org/szabgab/Perl-Maven/builds/43621897) shows.

## use Dancer ':test';

The next issue I encountered were in some of the test files where I had code like this: (showing only the relevant part)

```perl
use Dancer qw(:tests);

Dancer::set( appdir => getcwd() );

is Dancer::config->{'appdir'}, getcwd(), 'appdir';
is Dancer::config->{'mymaven_yml'}, 'config/mymaven.yml', 'mymaven';

use Perl::Maven;

my $app = Dancer::Handler->psgi_app;
```

Here Dancer was loaded for testing and the `appdir` was set manually using the `Dancer::set` function.
In the next line I checked if the this setting really worked (apparently the result of some failed experiments during the development),
and then checking if the `mymaven_yml` key was found in `config.yml` and loaded properly. Probably these tests are not
important for the application itself, they only check if the testing environment was set up correctly. Then I used the
`Dancer::Handler->psgi_app` to fetch the PSGI application created by Dancer.
In Dancer2 this code will be replaced by the following:

```perl
use Dancer2;    # importing: set, config

set( appdir => getcwd() );

is config->{'appdir'}, getcwd(), 'appdir';
is config->{'mymaven_yml'}, 'config/mymaven.yml', 'mymaven';

use Perl::Maven;

my $app = Dancer2->psgi_app;
```

There is no need to add `:tests` to the use-statement of Dancer2 and it imports both the `set` and the `config` keywords
so I don't need to prefix them any more. (I listed them after the use-statement of Dancer2 in comments just to make it easier for a reader
to locate the source of these keywords.)
Finally, the PSGI application created by Dancer 2 is not returned directly from Dancer2, instead of Dancer::Handler.

## referer and user_agent in list context

Then I encountered an exception related to logging code inserting data into MongoDB. It complained about `.` not being valid part of
a key in MongoDB. It boiled down to this piece of code:

```perl
my %details = (
    sid        => setting('sid'),
    time       => $time,
    host       => request->host,
    page       => request->uri,
    referrer   => request->referer,
    ip         => $ip,
    user_agent => request->user_agent,
    status     => $response->status,
);
log_to_mongodb( \%details );
```

This is actually a well known and painful issue with Perl. The problem was that the behavior of
`request->referer` and `request->user_agent` has changed. If they did not have a proper value,
in Dancer 1 they always returned `undef`.
Both in <a
href="/scalar-and-list-context-in-perl">scalar context and in list context</a>.

In Dancer 2 the behavior changed. In scalar context they still return [undef](/undef-and-defined-in-perl),
but in list context they return an empty list. In the above code, the right-hand-side of the fat-comma operator (`=>`) creates list context.
This means that the empty lists were squashed, and the value of the 'referer' key became the string 'ip'.
Which had a cascading effect and the content of `$ip` became the next key which contains the `.` characters the exception was about.

I have submitted a [bug report](https://github.com/PerlDancer/Dancer2/issues/809), or you might call in request for clarification,
but I also wanted to fix this issue in the Perl Maven codebase. (The response to my report was that the change was intentional.)

This can be done by forcing scalar context, using the `scalar` function:

```perl
my %details = (
    sid        => setting('sid'),
    time       => $time,
    host       => request->host,
    page       => request->uri,
    referrer   => scalar( request->referer ),
    ip         => $ip,
    user_agent => scalar( request->user_agent ),
    status     => response->status,
);
```

Depending on the response to that bug report I might have to update the code later and maybe I'll need to check my whole
application. I can say that it was actually lucky this happened during the migration process and not only in the
production code.

## public/ files

In the `public/` directory of the project there were 4 files that I think are not used by the Perl Maven application:
`404.html, 500.html, dispatch.cgi and dispatch.fcgi`. I don't need to migrate them, but because the scripts load Dancer,
I thought it would be better to get rid of them. So I temporarily switched back to the master branch of the Git repository.
Removed these 4 files there. Ran the tests of the Dancer 1 version of the application and committed the changes.

Then I switched back to the dancer2 branch of the repository and rebased the branch to the new master using  `git rebase master`.

## bin/app.pl

The `bin/appl.pl file is mostly used during development. In the Perl::Maven application it used to look like this:

```perl
#!/usr/bin/env perl
use Dancer;
use Perl::Maven;
dance;
```

Now it looks like this:

```perl
#!/usr/bin/env perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Perl::Maven;
Perl::Maven->dance;
```

It does not load Dancer (nor Dancer2) and so it should have `use strict; use warnings;`.
Not only to satisfy Perl::Critic, but also to save us from some stupid mistake down the road when
we might add some code to this script.

It is also now recommended to [change @INC to a relative directory](/how-to-add-a-relative-directory-to-inc),
and finally, instead of calling the exported `dance` function, now we call the `dance` method.

This still left us with [some errors reported on Travis](https://travis-ci.org/szabgab/Perl-Maven/builds/43686362)
that were not clear to me. None of those seemed provided any clue what changed between Dancer 1 and Dancer 2 that caused them.
Luckily now I could launch the application using `perl bin/app.pl` and visit the development web page.
It gave me the following error:

```
Error 500 - Internal Server Error

Hook error: Can't use an undefined value as a HASH reference at /Users/gabor/work/Perl-Maven/bin/../lib/Perl/Maven.pm line 202. at /Users/gabor/perl5/perlbrew/perls/perl-5.20.1_WITH_THREADS/lib/site_perl/5.20.1/Dancer2/Core/Role/Hookable.pm line 141.
Powered by Dancer2 0.156001
```

It seems the source of this problem is a change how `from_yaml` behaves, but I am not sure if the change in the behavior was intentional and I need to update
my code, or if is a bug in Dancer. I asked it both on the [mailing list](http://lists.preshweb.co.uk/pipermail/dancer-users/2014-December/004219.html)
and as a [bug report](https://github.com/PerlDancer/Dancer2/issues/812).
This was an intentional change so instead of using `from_yaml`, I changed my code to use the `YAML::Load` function.

So instead of this code:

```perl
return from_yaml $p->slurp_utf8;
```

I have this code:

```perl
return YAML::Load $p->slurp_utf8;
```


## Converting a stand-alone script

The Perl Maven site has a stand-alone script called `bin/sendmail.pl` that launches the application and uses it to generate the HTML e-mail
sent out to the subscribers. It used a set of call very similar to what I had in the deployment app.psgi file:

This is what I used to have:

```perl
use Dancer ':syntax';
my $dancer = sub {
    my $env = shift;

    my $name = 'Perl::Maven';
    my $root = dirname( dirname( abs_path($0) ) );
    local $ENV{DANCER_APPDIR} = $root;
    setting appdir => $root;
    load_app $name;
    Dancer::App->set_running_app($name);
    Dancer::Handler->init_request_headers($env);
    my $request = Dancer::Request->new( env => $env );
    Dancer->dance($request);
};
```

Now this could have been greatly simplified to this code:

```perl
use Dancer2;
use Perl::Maven;

my $dancer = Dancer2->psgi_app;
```


## Absolute path for send_file

This issue took the longest time to fix. I think I wasted on it more than 2 days and to be honest I still don't understand
the problem.

When I want to return a file (e.g. to let the user download a pdf file, but even in the development environment I am using Dancer
to server images) I use the `send_file` function provided by Dancer. Because the files are not located under the public
directory of Dancer, I also need to add `system_path => 1`.

Thing that drove me crazy that this featured worked in the Dancer 1 version and also all the tests passed.
It also worked in the Dancer 2 version when I launched the application using `perl bin/app.pl` but it failed
when I run the unit tests!!!!

For days I was experimenting trying to find out the source of this problem. I think the issue was that the path
to the file that I wanted to server was relative to the root of the application. In the tests of Dancer 1 this still
worked but for some reason in Dancer 2 it did not server these files.

Finally, after tearing out some of my remaining hear, the solution was to convert all the path-es to be absolute path-es.
I made this [change](https://github.com/szabgab/Perl-Maven/commit/cc435bb1911f699f2da24c466993f78d76b6c584) on the 'mater'
branch that was still using Dancer 1, in order to make sure that version works properly with this new code, and then
rebased the 'dancer2' branch to include this change.

## Fixing the code using Dancer2::Plugin::Passphrase

After [Dancer2::Plugin::Passphrase](https://metacpan.org/pod/Dancer2::Plugin::Passphrase) has been
fixed and I could install it, the system still did not work. At first I did not know what the issue was, but
after trying to print the result of the `passphrase($password)->generate` slowly I understood.

Earlier, the `generate` method of [Dancer::Plugin::Passphrase](https://metacpan.org/pod/Dancer::Plugin::Passphrase)
returned an object that when printed would stringify to the value I had to save in the database.
The documentation recommended I should store the string returned by `passphrase($password)->generate->rfc2307`,
but it also provided the convenience of stringification.

The Dancer2 version of this module does not stringify (which might, or might not be a bug), but I have no choice, but to work with the
explicit call to `rfc2307`. I think this make the code clearer, so I don't mind.

In a nutshell, I had a bug in my code that did not manifest earlier because of a convenience feature of the module I was using.
With the upgrade I had to fix my bug so instead of

```perl
passphrase($password)->generate
```

now I have this code:

```perl
passphrase($password)->generate->rfc2307;
```

First I implemented this [change](https://github.com/szabgab/Perl-Maven/commit/ecc42e4763408288fe2af64d02633244434baad3)
too on the master branch using Dancer 1 and rebased the dancer2 branch.


## Deployment

With the above change I've finished migrating from Dancer 1 to Dancer 2. All the tests are passing on my development machine  and Travis-CI has also confirmed it.
When I launch the application using `perl bin/app.pl` it seems to work properly.

The only thing remains is to deploy the new version and to hope I have not overlooked something critical.

This change is quite similar to what we already saw earlier in the sendmail example. The old code in `app.psgi` looked like this:

```perl
use Dancer ':syntax';
sub create_dancer {
       my ($dir, $name) = @_;

       return sub {
               my $env = shift;
               my $root = '/home/foobar/' . $dir;
               local $ENV{DANCER_APPDIR} = $root;

               setting appdir => $root;
               load_app $name;
               Dancer::App->set_running_app($name);
               Dancer::Handler->init_request_headers($env);
               #Dancer::Config->load;
               my $request = Dancer::Request->new( env => $env );
               #die Dumper $env;
               Dancer->dance($request);
       };
}


my $perlmaven = create_dancer('Perl-Maven', 'Perl::Maven');

mount 'https://perlmaven.com/'       => builder { $perlmaven };
foreach my $cc (qw(br cn cs de eo es fr he id it ko ne te ro ru tr tw meta)) {
    mount "http://$cc.perlmaven.com/"       => builder { $perlmaven };
}
```

The new code is much more simple:

```perl
sub create_dancer {
    my ($dir, $name) = @_;

    eval "use $name";
    die $@ if $@;
    chdir "/home/foobar/$dir";
    $name->dance;
}

my $perlmaven = create_dancer('Perl-Maven', 'Perl::Maven');

mount 'https://perlmaven.com/'       => builder { $perlmaven };
foreach my $cc (qw(br cn cs de eo es fr he id it ko ne te ro ru tr tw meta)) {
    mount "http://$cc.perlmaven.com/"       => builder { $perlmaven };
}
```


## Regex route is not anchored any more

This one I encountered only after employment. (Bad thing I did not have a test for this)
The Perl Maven site has paths such as `/pro/...` and also `/media/pro/...`.

I had a route catching the former requests that looked like this:

```perl
get qr{/pro/(.*)} => sub {
    ...
};
```

This worked well in Dancer 1 as this regex only matched the beginning of the path.

In Dancer 2 this has changed. The above regex started to also match the second type of URL
and started to handle them incorrectly...

My solution was to anchor the regex to the beginning of the path using a `^`:

```perl
get qr{^/pro/(.*)} => sub {
    ...
};
```

This fixed the issue.

See [my post](http://lists.preshweb.co.uk/pipermail/dancer-users/2014-December/004247.html) to the Dancer mailing list.

## Performance

Finally let me show you the graph I get from [Munin](http://munin-monitoring.org/) showing the
average request processing time on the Perl Maven site. I switched the site over to use Dancer 2 on the 13th in the evening hours.
The green line, showing the average time for the previous 5 minutes, immediately fell from about 285 ms to 192 and the blue line,
that shows the average of the last 24 hours, joined it after 24 hours.

In a nutshell: a performance increase of (285-192)/285 = 32%.

(The hole the 11th was when I broke my logging. You can disregard it.)

<img src="/img/average_request_processing_time_switch_to_dancer2.png" title="Average request processing time after switching to Dancer2" />

## Cookies

Unfortunately I found out this only 2 days after deployment of the Dancer 2 tree:

When creating a session, by default both Dancer 1 and Dancer 2, set the cookie to be used for the exact hostname being served.
This means when someone visits [br.perlmaven.com](https://br.perlmaven.com/) that person will get a cookie for br.perlmaven.com
and when that same person visits [perlmaven.com](https://perlmaven.com/), the system will set another cookie and thus
a separate session.

In order to have a single cookie and a single session, one needs to make sure the cookie is for `.perlmaven.com` (note the leading dot).

In Dancer 1 this was done by setting the `session_domain` configuration variable in config.yml:

```
session_doamin: .perlmaven.com
```

In Dancer 2, apparently this key is gone and now I have to set

```
engines:
  session:
    YAML:
      cookie_domain: ".perlmaven.com"
```

(YAML, because the PerlMaven site still uses YAML-file based sessions)


