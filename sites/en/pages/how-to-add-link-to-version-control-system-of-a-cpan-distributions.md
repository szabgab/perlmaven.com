---
title: "How to convince Meta CPAN to show a link to the version control system of a distribution?"
timestamp: 2013-01-03T10:45:56
tags:
  - Perl
  - Perl 5
  - CPAN
  - Git
  - Github
  - SVN
  - Subversion
  - VCS
  - META
  - ExtUtils::MakeMaker
  - Module::Build
  - Module::Install
  - Dist::Zilla
  - CPAN::Meta::Spec
published: true
books:
  - metacpan
author: szabgab
---


When you look at [META CPAN](https://www.metacpan.org/), you will see that some modules
have a link to Github or some other place where they host their project.

On Meta CPAN it is a link on the left-hand side of the page called "Clone repository".


Both sites take the link to the Version Control system from the META files included in the CPAN distributions.
Either META.yml, or the newer META.json. (They should only differ in their format.)

As the META files are usually generated automatically when the distribution is released
by the author, I am going to show you how you can tell the 4 main packaging systems
to include the repository link.

In the examples I'll use the link to the repository of [Task::DWIM](https://metacpan.org/pod/Task::DWIM),
which is an experimental distribution listing all the modules included in a [DWIM Perl](/dwimperl)
distribution.

## ExtUtils::MakeMaker

If you use [ExtUtils::MakeMaker](https://metacpan.org/pod/ExtUtils::MakeMaker) add the following to your Makefile.PL
as parameter in the **WriteMakefile** function:

```perl
META_MERGE => {
    'meta-spec' => { version => 2 },
     resources => {
         repository => {
             type => 'git',
             url  => 'https://github.com/dwimperl/Task-DWIM.git',
             web  => 'https://github.com/dwimperl/Task-DWIM',
         },
         bugtracker => {
             web => 'https://github.com/dwimperl/Task-DWIM/issues'
         },
         homepage   => 'https://perlmaven.com/',
     },
},
```

If your version of ExtUtils::MakeMaker does not yet support this, just upgrade ExtUtils::MakeMaker.
You can also write the following, if you'd like to make sure old version of ExtUtiles::MakeMaker won't
freak out:

```perl
(eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
    'meta-spec' => { version => 2 },
     resources => {
         repository => {
             type => 'git',
             url  => 'https://github.com/dwimperl/Task-DWIM.git',
             web  => 'https://github.com/dwimperl/Task-DWIM',
         },
         bugtracker => {
             web => 'https://github.com/dwimperl/Task-DWIM/issues'
         },
         homepage   => 'https://perlmaven.com/',
     }})
     : ()
),
```


## Module::Build

If you use [Module::Build](https://metacpan.org/pod/Module::Build), add the following to Build.PL,
in the **Module::Build->new** call:

```perl
meta_merge => {
    resources => {
        repository => 'https://github.com/dwimperl/Task-DWIM',
        bugtracker => 'https://github.com/dwimperl/Task-DWIM/issues'
    }
},
```

This will include a link to both the GitHub repository and the GitHub issues.

## Module::Install

If you use [Module::Install](https://metacpan.org/pod/Module::Install) add the following to Makefile.PL:

```perl
repository 'https://github.com/dwimperl/Task-DWIM';
```

## Dist::Zilla

If you use [Dist::Zilla](http://dzil.org/), the
[Dist::Zilla::Plugin::Repository](https://metacpan.org/pod/Dist::Zilla::Plugin::Repository)
will automatically add the link to your repository, though you can also specify it manually.

```perl
[MetaResources]
repository.url = https://github.com/dwimperl/Task-DWIM.git
```

A detailed version would include more details as in the following example. As I can see, these parts are only
included in the META.json file and not in the META.yml file. In order to generate that file, you'll also need
to include the [MetaJSON plugin](https://metacpan.org/pod/Dist::Zilla::Plugin::MetaJSON) of Dist::Zilla.

```perl
[MetaResources]
repository.web = https://github.com/dwimperl/Task-DWIM
repository.url = https://github.com/dwimperl/Task-DWIM.git
bugtracker.web = https://github.com/dwimperl/Task-DWIM/issues
repository.type = git

[MetaJSON]
```

There are other ways to <a href="http://www.lowlevelmanager.com/2012/05/dzil-plugins-github-vs-githubmeta.html">add
the repository links</a> to the META files when using Dist::Zilla.

Probably the most simple way is to use the
[GithubMeta](https://metacpan.org/pod/Dist::Zilla::Plugin::GithubMeta) plugin by
adding the following line to the dist.ini file:

```
[GithubMeta]
issues = 1
[MetaJSON]
```

## Why shall I add this link?

It's simple. The easier it is to send patches to the most recent version of your module,
the more likely you'll get them.

Also you might have already made some changes to your module since the latest release.
You might have already fixed the bug I'd like to fix. If I can see your repository we can avoid duplicate work.

## Other resources

If you are already dealing with this, you could add some other resources as well.
The [CPAN META Specification](https://metacpan.org/pod/CPAN::Meta::Spec#resources) has all that listed.
If something is unclear there, just ask.

## Licenses

In an other article I showed [how to add the license information to the META files of CPAN distributions](/how-to-add-the-license-field-to-meta-files-on-cpan).
If you had a public repository, it would be easier for others to send that patch too.

