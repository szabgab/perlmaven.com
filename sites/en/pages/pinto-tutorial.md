---
title: "Pinto -- A Custom CPAN In A Box"
timestamp: 2013-05-03T16:30:01
tags:
  - cpan
  - pinto
published: true
author: thalhammer
---


<i>
This is a guest post by [Jeffrey Ryan Thalhammer](http://twitter.com/thaljef), author of Pinto
and of Perl::Critic. Jeff operates a small consulting company in San Francisco and
has been active in the Perl community for many years.
Till May 7 Jeff is running a [fund-raiser](https://www.crowdtilt.com/campaigns/specify-module-version-ranges-in-pint)
to finance the development of the feature that will allow you to <b>specify module version ranges in Pinto</b>.
</i>

One of the best things about Perl are all the open source modules that
are available on CPAN.  But keeping up with all those modules is
difficult.  Every week there are hundreds of new releases and you
never know when a new version of a module will introduce a bug that
breaks your application.


This article was originally published on [Pragmatic Perl](http://pragmaticperl.com/)

One strategy for solving this problem is to construct your own custom
CPAN repository that contains only the versions of the modules that
you want.  Then you can use the CPAN tool chain to build your
application from the modules in your custom repository without being
exposed to all the churn in the public CPAN.

Over the years, I've built several custom CPAN repositories using
tools like [CPAN::Mini](https://metacpan.org/pod/CPAN::Mini)
and [CPAN::Site](https://metacpan.org/pod/CPAN::Site).
But they always seemed clunky
and I was never very happy with them.  A couple years ago, a
client hired me to build them another custom CPAN.  But this time, I
had an opportunity to start from scratch.  Pinto is the result of that
work.

[Pinto](https://metacpan.org/pod/Pinto) is a robust tool
for creating and managing a custom CPAN repository.
It has several powerful features that help you safely
manage all the Perl modules your application depends on.  This
tutorial will show you how to create a custom CPAN with Pinto and
demonstrate some of those features.

## Installing Pinto

Pinto is available on CPAN and can be installed like any other module
using the cpan or `cpanm` utilities.  But Pinto is more like an
application than a library.  It is a tool that you use to manage your
application code, but Pinto is not actually part of your application.
So I recommend installing Pinto as a stand-alone application with
these two commands:

```
curl -L http://getpinto.stratopan.com | bash
source ~/opt/local/pinto/etc/bashrc
```

That will install Pinto into `~/opt/local/pinto` and add the necessary
directories to your `PATH` and `MANPATH`.  Everything is self-contained,
so installing Pinto does not change the rest of your development
environment, nor will changes in your development environment affect
Pinto.

## Exploring Pinto

As with any new tool, the first thing you should know is how to get help:

```
pinto commands            # Show a list of available commands
pinto help <COMMAND>      # Show a summary of options and arguments for <COMMAND>
pinto manual <COMMAND>    # Show the complete manual for <COMMAND>
```

Pinto also ships with other documentation, including a tutorial and
quick-reference guide.  You can access those documents using these
commands:

```
man Pinto::Manual::Introduction  # Explains basic Pinto concepts
man Pinto::Manual::Installing    # Suggestions for installing Pinto
man Pinto::Manual::Tutorial      # A narrative guide to Pinto
man Pinto::Manual::QuickStart    # A summary of common commands
```

## Creating A Repository

The first step in using Pinto is to create a repository using the
`init` command:

```
pinto -r ~/repo init
```

This will create a new repository in the `~/repo` directory.  If that
directory does not exist, it will be created for you.  If it does
already exist, then it must be empty.

The -r (or --root) flag specifies where the repository is. This is
required for every pinto command.  But if you get tired of typing it,
you can set the `PINTO_REPOSITORY_ROOT` environment variable to point to
your repository and then omit the -r flag.


## Inspecting The Repository

Now that you have a repository, let's look inside it.  To see the
contents of a repository, use the "list" command:

```
pinto -r ~/repo list
```

At this point, the listing will be empty because there is nothing in
the repository.  But you'll use the "list" command quite often during
this tutorial.

## Adding CPAN Modules

Suppose you are working on an application called My-App that contains
a module called My::App, and it depends on the URI module.  You can
bring the URI module into your repository by using the `pull` command:

```
pinto -r ~/repo pull URI
```

You will be prompted to enter a log message that describes why this
change is happening.  The top of the message template will include a
simple generated message that you can edit.  The bottom of the message
template shows exactly which modules have been added.  Save the file
and close your editor when you are done.

Now you should have the URI module in your Pinto repository.  So lets
look and see what we really got.  Once again, use the `list` command
to see the contents of the repository:

```
pinto -r ~/repo list
```

This time, the listing will look something like this:

```
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```

You can see that the URI module has been added to the repository, as
well as all the prerequisites for URI, and all of their prerequisites,
and so on.

## Adding Private Modules

Now suppose that you've finished work on My-App and you are ready to
release the first version.  Using your preferred build tool (e.g
ExtUtils::MakeMaker, Module::Build, Module::Install etc.) you package
a release as My-App-1.0.tar.gz.  Now you place the distribution into
the Pinto repository with the `add` command:

```
$> pinto -r ~/repo add path/to/My-App-1.0.tar.gz
```

Again, you'll be prompted to enter a message to describe the change.
When you list the repository contents now, it will include the My::App
module and show you as the author of the distribution:

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```


## Installing Modules

Now that you have your modules inside the Pinto repository, the next
step is to actually build and install them somewhere.  Under the hood,
a Pinto repository is organized just like a CPAN repository, so it is
fully compatible with cpanm and any other Perl module installer.  All
you have to do is point the installer at your Pinto repository:

```
cpanm --mirror file://$HOME/repo --mirror-only My::App
```

That will build and install My::App using *only* the modules in your
Pinto repository.  So you'll get exactly the same versions of those
modules every time, even if the module is removed or upgraded on the
public CPAN.

With cpanm, the --mirror-only option is important because it prevents
cpanm from falling back to the public CPAN when it can't find a module
in your repository.  When that happens, it usually means that some
distribution in the repository doesn't have all the correct
dependencies declared in its META file.  To fix the problem, just use
the `pull` command to fetch any modules that are  missing.


## Upgrading Modules

Suppose that several weeks have passed since you first released My-App
and now URI version 1.62 is available on the CPAN.  It has some
critical bug fixes that you'd like to get.  Again, we can bring that
into the repository using the `pull` command.  But since your
repository already contains a version of URI, you must indicate that
you want a <b>newer</b> one by specifying the minimum version that you
want:

```
pinto -r ~/repo pull URI~1.62
```

If you look at the listing again, this time you'll see the newer
version of URI (and possibly other modules as well):

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.62  GAAS/URI-1.62.tar.gz
rf  URI::Escape                    3.38  GAAS/URI-1.62.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.62.tar.gz
...
```

If the new version of URI requires any upgraded or additional
dependencies, those will be in the repository too.  And when you
install My::App, now you'll get version 1.62 of URI.

## Working With Stacks

Thus far, we've treated the repository as a singular resource.  So
when we upgraded URI in the last section, it affected every person and
every application that might have been using the repository.  But this
kind of broad impact is undesirable.  You would prefer to make changes
in isolation and test them before forcing everyone else to upgrade.
This is what stacks are designed for.

All CPAN-like repositories have an index which maps the latest version
of each module to the archive that contains it.  Usually, there is
only one index per repository.  But in a Pinto repository, there can
be many indexes.  Each of these indexes is called a <b>"stack"</b>.  This
allows you to create different stacks of dependencies within a single
repository.  So you could have a "development" stack and a
"production" stack, or a "perl-5.8" stack and a "perl-5.16" stack.
Whenever you add or upgrade a module, it only affects one stack.

But before going further, you need to know about the default stack.
For most operations, the name of the stack is an optional parameter.
So if you do not specify a stack explicitly, then the command is
applied to whichever stack is marked as the default.

In any repository, there is never more than one default stack.  When
we created this repository, a stack called "master" was also created and
marked as the default.  You can change the default stack or change the
name of a stack, but we won't go into that here.  Just remember that
"master" is the name of the stack that was created when the repository
was first initialized.

<h3>Creating A Stack</h3>

Suppose your repository contains version 1.60 of URI but version 1.62
has been released to the CPAN, just like before.  You want to try
upgrading, but this time you're going to do it on a separate stack.

Thus far, everything you've added or pulled into the repository has
gone into the "master" stack.  So we're just going to make a clone
of that stack using the `copy` command:

```
pinto -r ~/repo copy master uri_upgrade
```

This creates a new stack called "uri_upgrade".  If you want to see the
contents of that stack, just use the `list` command with the "--stack"
option:

```
pinto -r ~/repo list --stack uri_upgrade
```

The listing should be identical to the "master" stack:

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
...
```

<h3>Upgrading A Stack</h3>

Now that you've got a separate stack, you can try upgrading URI.  Just
as before, you'll use the `pull` command.  But this time, you'll tell
Pinto to pull the modules into the "uri_upgrade" stack:

```
pinto -r ~/repo pull --stack uri_upgrade URI~1.62
```

We can compare the "master" and "uri_upgrade" stacks using the "diff"
command:

```
pinto -r ~/repo diff master uri_upgrade

+rf URI                                              1.62 GAAS/URI-1.62.tar.gz
+rf URI::Escape                                      3.31 GAAS/URI-1.62.tar.gz
+rf URI::Heuristic                                   4.20 GAAS/URI-1.62.tar.gz
...
-rf URI                                              1.60 GAAS/URI-1.60.tar.gz
-rf URI::Escape                                      3.31 GAAS/URI-1.60.tar.gz
-rf URI::Heuristic                                   4.20 GAAS/URI-1.60.tar.gz
```

The output is similar to the diff(1) command. Records starting with a
"+" were added and those starting with a "-" were removed.  You can
see that modules from the URI-1.60 distribution have been replaced
with modules from the URI-1.62 distribution.

<h3>Installing From A Stack</h3>

Once you have new modules on the "uri_upgrade" stack, you can try
building your application by pointing cpanm at the stack.  Each stack
is just a subdirectory inside the repository, so all you have to do
is add it to the URL:

```
cpanm --mirror file://$HOME/repo/stacks/uri_upgrade --mirror-only My::App
```

If all the tests pass, then you can confidently upgrade URI to version
1.62 in the "master" stack as well by using the `pull` command.  Since
"master" is the default stack, you can omit the "--stack" parameter:

```
pinto -r ~/repo pull URI~1.62
```

## Working With Pins

Stacks are a great way to test the effect of changing your application
dependencies.  But what if the tests didn't pass?  If the problem lies
within My-App and you can quickly correct it, you might just modify
your code, release version 2.0 of My-App, and then proceed to upgrade
URI on the "master" stack.

But if the issue is a bug in URI or it will take a long time to fix
My-App, then you have a problem.  You don't want someone else to
upgrade URI, nor do you want it to be upgraded inadvertently to
satisfy some other prerequisite that My-App may have.  Until you know
the problem is fixed, you need to prevent URI from being upgraded.
This is what pins are for.

<h3>Pinning A Module</h3>

When you pin a module, that version of the module is forced to stay in
a stack.  Any attempt to upgrade it (either directly or via another
prerequisite) will fail.  To pin a module, use the `pin` command:

```
pinto -r ~/repo pin URI
```

If you look at the listing for the "master" stack again, you'll see
something like this:

```
...
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf! URI                            1.60  GAAS/URI-1.60.tar.gz
rf! URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
...
```

The "!" near the beginning of a record indicates the module has been
pinned.  If anyone attempts to upgrade URI or a add distribution that
requires a newer version of URI, then Pinto will give a warning and
refuse to accept the new distributions.  Notice that every module in
the URI-1.60 distribution has been pinned, so it is impossible to
partially upgrade a distribution (this situation could happen when a
module moves into a different distribution).

<h3>Unpinning A Module</h3>

After a while, suppose you fix the problem in My-App or a new version
of URI is released that fixes the bug.  When that happens, you can
unpin URI from the stack using the `unpin` command:

```
pinto -r ~/repo unpin URI
```

At this point you're free to upgrade URI to the latest version
whenever you're ready.  Just as with pinning, when you unpin a module
it unpins every other module it the distribution as well.

## Using Pins And Stacks Together

Pins and stacks are often used together to help manage change during
the development cycle.  For example, you could create a stack called
"prod" that contains your known-good dependencies.  At the same time,
you could also create a stack called "dev" that contains experimental
dependencies for your next release.  Initially, the "dev" stack is
just a copy of the "prod" stack.

As development proceeds, you may upgrade or add several modules on the
"dev" stack.  If an upgraded module breaks your application, then
you'll place a pin in that module on the "prod" stack to signal that
it shouldn't be upgraded.

<h3>Pins and Patches</h3>

Sometimes you may find that a new version of a CPAN distribution has a
bug but the author is unable or unwilling to fix it (at least not
before your next release is due).  In that situation, you may decide
to make a local patch of the CPAN distribution.

So suppose that you forked the code for URI and made a local version
of the distribution called URI-1.60_PATCHED.tar.gz.  You can add it to
your repository using the `add` command:

```
pinto -r ~/repo add path/to/URI-1.60_PATCHED.tar.gz
```

In this situation, it is wise to pin the module as well, since you do
not want it to be upgraded until you are sure that the new version
from CPAN includes your patch or the author has fixed the bug by other
means.

```
pinto -r ~/repo pin URI
```

When the author of URI releases version 1.62, you'll want to test it
before deciding to unpin from your locally patched version.  Just as
before, this can be done by cloning the stack with the `copy` command.
Let's call it the "trial" stack this time:

```
pinto -r ~/repo copy master trial
```

But before you can upgrade URI on the "trial" stack, you'll have to
unpin it there:

```
pinto -r ~/repo unpin --stack trial URI
```

Now you can proceed to upgrade URI on the stack and try building
My::App like this:

```
pinto -r ~/repo pull --stack trial URI~1.62
cpanm --mirror file://$HOME/repo/stacks/trial --mirror-only My::App
```

If all goes well, remove the pin from the "master" stack and pull the
newer version of URI back into it.

```
pinto -r ~/repo unpin URI
pinto -r ~/repo pull URI~1.62
```

## Reviewing Past Changes

As you've probably noticed by now, each command that changes the state
of a stack requires a log message to describe it.  You can review
those messages using the `log` command:

```
pinto -r ~/repo log
```

That should display something like this:

```
revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pin GAAS/URI-1.59.tar.gz

     Pinning URI because it is not causes our foo.t script to fail

revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pull GAAS/URI-1.59.tar.gz

     URI is required for HTTP support in our application

...
```

The header for each message shows who made the change and when it happened.
It also has a unique identifier similar to Git's SHA-1 digests.  You can
use these identifiers to see the diffs between different revisions or to
reset the stack back to a prior revision [NB: this feature is not actually
implemented yet].

## Conclusion

In this tutorial, you've seen the basic commands for creating a Pinto
repository and populating it with modules.  You've also seen how to
use stacks and pins to manage your dependencies in the face of some
common development obstacles.

Each command has several options that were not discussed in this
tutorial, and there are some commands that were not mentioned here at
all.  So I encourage you to explore the manual pages for each command
and learn more.

## Comments

Hello, I don't know how old this article is, but im trying to create my own BackPAN by using Pinto. But I run into some problems getting the module versions I want. For example a pull to my custom Pinto repository for "Config::IniFiles 2.39" is not possible, because the module can't be found in the index of BackPAN. But I found this reference list of a complete BackPAN index ( backpan.cpantesters.org/backpan-full-index.txt.gz ) and there the module "Config::IniFiles 2.39" is listed and I can also find it under the path mentioned there. How is it possible to get and pull this module version automatically by using Pinto?


