---
title: "GitHub Actions for Geo::TCX"
timestamp: 2022-10-11T10:00:01
tags:
  - GitHub
published: true
author: szabgab
archive: true
show_related: true
---


Loking at [CPAN::Digger](https://cpan-digger.perlmaven.com/) I saw that [Geo-TCX](https://metacpan.org/dist/Geo-TCX) does not have any CI configured.
Let's contribute that to the project.


## Unnecessary Makefile.PL ?

Looking at the source code of the prorject I was a bit confused as the <b>Makefile.PL</b> did not contain any reference to GitHub, but somehow MetaCPAN did know about the GitHub
of this project. Then I noticed there is also a <b>dist.ini</b> file. This looks confusing and probably unnecessary.

So I tried to install the dependencies and running the tests using <b>dzil</b> just to have it complain:

```
$ dzil test
[DZ] building distribution under .build/KWtstz9M9b for installation
[DZ] beginning to build Geo-TCX
[DZ] guessing dist's main_module is lib/Geo/TCX.pm
[VersionFromModule] dist version 1.01 (from lib/Geo/TCX.pm)
[DZ] attempt to add Makefile.PL multiple times; added by: filename set by GatherDir (Dist::Zilla::Plugin::GatherDir line 235); encoded_content added by @Basic/GatherDir (Dist::Zilla::Plugin::GatherDir line 236); content set by MakeMaker (Dist::Zilla::Plugin::MakeMaker line 337); content added by @Basic/MakeMaker (Dist::Zilla::Plugin::MakeMaker line 152)
aborting; duplicate files would be produced at /home/gabor/perl5/lib/perl5/Dist/Zilla/App/Command/test.pm line 82.
```

I guess that Makefile.PL is really problematic. So I opened an [issue](https://github.com/patjoly/geo-tcx/issues/1).

## test failure

After removing Makefile.PL (rm Makefile.PL) the tests could be executed, but they still failed with this:

```
t/01_main.t ........ 1/72 Uncaught exception from user code:
    /home/gabor/Data/Garmin/ not a valid directory at t/01_main.t line 75.
    Geo::TCX::set_wd(Geo::TCX=HASH(0x55bb2977a578), "~/Data/Garmin") called at /home/gabor/os/geo-tcx/.build/1zo6gQMAHa/blib/lib/Geo/TCX.pm line 164
    Geo::TCX::new("Geo::TCX", "t/2014-08-11-10-25-15.tcx", "work_dir", "~/Data/Garmin") called at t/01_main.t line 75
# Looks like your test exited with 2 just after 19.
```

This looks scary. Why does this module look at a directory outside its data structure. I hope it did not do anything else.

This was also [reported](https://github.com/patjoly/geo-tcx/issues/2).

## .gitignore .build

Dist::Zilla also generates a directory called <b>.build</b>. It should be ignored.
[pull request](https://github.com/patjoly/geo-tcx/pull/3).


## GitHub Actions

Then came the `.github/workflows/ci.yml` file with a special command in one of the steps. Before installing all the dependencies
we remove the Makefile.PL.

```
    - name: Install Modules
      run: |
        rm -f Makefile.PL
        dzil authordeps --missing | cpanm --notest
        dzil listdeps --missing | cpanm --notest
```

If the author agrees to my earlier suggestion and removes the Makefile.PL from the repository then this command should also be removed from here,
but for now we need it.

The CI process fails with the same error as I have already reported, but once this issue is fixed then the CI should also pass.

I saved the full configuration file here, so even if the author changes it later, you'll still see the original version:

{% include file="examples/geo-tcx-ci.yml" %}

