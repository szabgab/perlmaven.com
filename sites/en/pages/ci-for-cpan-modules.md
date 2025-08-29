---
title: "CI for CPAN modules"
timestamp: 2022-10-17T10:30:01
tags:
  - GitHub
published: true
author: szabgab
archive: true
show_related: true
---


After I read the editorial of [Perl Weekly issue 586](https://perlweekly.com/archive/586.html) I though I should try to send
as many PR as I can to enable GitHub Actions on CPAN projects.

There is a whole series about [why use CI and how to set up CI](/ci) and several [examples with videos](/os).

I started at [CPAN Digger](https://cpan-digger.perlmaven.com/)


2022.10.11 [Pinto-Remote-SelfContained](https://metacpan.org/dist/Pinto-Remote-SelfContained)
I add a GitHub Actions configuration file, but bumped into an error:
[Error: [PodWeaver] [Support] No bugtracker in metadata!](https://github.com/reyjrar/Pinto-Remote-SelfContained/issues/2)
Locally I get a different error: [Can't locate Test/EOL.pm](https://github.com/reyjrar/Pinto-Remote-SelfContained/issues/3).

2022.10.17 [Test-Spy](https://metacpan.org/dist/Test-Spy) - thar was easy. I configure [GitHub Actions](https://github.com/bbrtj/perl-test-spy/pull/1).
Everything worked, except that it seems Perl 5.36 is not available on Windows to be used pn GitHub Actions. The Pull-request was accepted within a few minutes. **DONE**

2022.10.17 [Weather-GHCN-Fetch](https://metacpan.org/dist/Weather-GHCN-Fetch) I have added [GitHub Action configuration files](https://github.com/jgpuckering/Weather-GHCN-Fetch/pull/2).
The tests are failing with [Bailout called. Further testing stopped: *E* cached folder is missing](https://github.com/jgpuckering/Weather-GHCN-Fetch/issues/1).
I also sent a [PR with .gitignore](https://github.com/jgpuckering/Weather-GHCN-Fetch/pull/3)

2022.10.17 [EAV-XS](https://metacpan.org/dist/EAV-XS) has a number of non-perl dependencies listed in the README that I did not know how to install
so [I asked for help](https://github.com/gh0stwizard/p5-EAV-XS/issues/1). **DONE**

2022.10.17 [Gzip-Libdeflate](https://metacpan.org/dist/Gzip-Libdeflate) was complaining that it [Could not open 'lib/Gzip/Libdeflate.pod'](https://github.com/benkasminbullock/gzip-libdeflate/issues/3).
Ben Bullock, the author, quickly replied and made some adjustments so I could make some progress (even though I did not exaactly liked the solution).
Anyway I bumped into [another issue](https://github.com/benkasminbullock/gzip-libdeflate/issues/4).
After I was told how to proceed (and basically how to set up a development environment) I could finish the
[working CI workflow](https://github.com/benkasminbullock/gzip-libdeflate/pull/5).

2022.10.17 [Memoize](https://metacpan.org/dist/Memoize)  I found some generated files that [were not in .gitignore](https://github.com/ap/Memoize/pull/2). (Apparently Aristotle does not want to ignore anything as he
removed the .gitignore file a few monthes ago.)
adding GitHub Actions was [quite easy](https://github.com/ap/Memoize/pull/3). **DONE**

2022.10.18 [Dancer2-Plugin-RPC-RESTISH](https://metacpan.org/dist/Dancer2-Plugin-RPC-RESTISH)
It was quite simple to [add GitHub Actions](https://github.com/abeltje/Dancer2-Plugin-RPC-RESTISH/pull/1) to this module,
but it seems that the installation of the dependencies was a bit flaky when I first set up GA.

2022.10.18 [Hustle-Table](https://metacpan.org/dist/Hustle-Table) It was [easy to enable CI](https://github.com/drclaw1394/perl5-hustle-table/pull/1).

2022.10.18 [Term-TablePrint](https://metacpan.org/dist/Term-TablePrint) It was [easy to enable CI](https://github.com/kuerbis/Term-TablePrint/pull/2). **DONE**

2022.10.18 [PAUSE-Packages](https://metacpan.org/dist/PAUSE-Packages) It was [easy to enable CI](https://github.com/neilb/PAUSE-Packages/pull/11) though the tests
fail on MS Windows so I had to disable that platform.

2022.10.18 [Bio-ToolBox](https://metacpan.org/dist/Bio-ToolBox) the tests are currently failing. It was
[reported](https://rt.cpan.org/Public/Bug/Display.html?id=144444) a few weeks ago. The first iteration of the
CI showed the same error.

2022.10.21 [Sniffer-HTTP](https://metacpan.org/dist/Sniffer-HTTP). When I tried to install it I got a problem that Net-Pcap,
one of the dependencies would not install out of the box. So first I looked at that module to see if I can figure out how to install that.
Then [this Pull-Request](https://github.com/Corion/sniffer-http/pull/1) was much easier. **DONE**`

2022.10.21 [Net-Pcap](https://metacpan.org/dist/Net-Pcap) wasn't difficult after all, but I had to install some external dependencies using
```
    - name: Install external dependencies on Ubuntu
      if:  ${{ startsWith( matrix.runner, 'ubuntu-')}}
      run: |
        sudo apt-get install libpcap-dev
```

I only figured out how to do it on Ubuntu. Either the author of the module will add the installation on OSX and Windows as well, or if they tell me how to do
it I might have the time to figure out how to do it on the CI server.

I had to install a bunch of extra Perl modules for the tests, enable an environment variable and even create a directory. Though as I can see
a spell checker is still missing.

I also trid to run the CI on all versions of Perl betwee 5.10 and 5.36, but it seems some of the dependencies need perl 5.26 so I limited the
matrix for that. Anyway here is the [Pull-Request](https://github.com/maddingue/Net-Pcap/pull/14)

2022.10.21 [WebFetch](https://metacpan.org/dist/WebFetch). I configured the CI, but encountered and reported a problem:
[Error: Duplication of element resources.repository.web](https://github.com/ikluft/WebFetch/issues/2). After that was fixed I sent a [PR](https://github.com/ikluft/WebFetch/pull/3). **DONE**

2022.10.23 [MooseX-Types-Parameterizable](https://metacpan.org/dist/MooseX-Types-Parameterizable)
[PR to add GitHub Actions](https://github.com/jjn1056/MooseX-Types-Parameterizable/pull/10)

2022.10.24 [Math-MPFR](https://metacpan.org/dist/Math-MPFR) I had to play around a bit till I managed to send the [Pull-Request](https://github.com/sisyphus/math-mpfr/pull/8)
* There were two external dependencies to be installed on Linux. However I did not understand what was going on on OSX and Windows. Do they already have those external dependencies or are the tests somehow passing despite not being able to compile the code?
* I had to install some extra modules to run all the tests, but some of these extra modules failed on OSX so they are only installed on Linux and Windows.
* There were lots of warnings and errors in all the runs that I did not understand.
The authoris not interested in have CI. **Nope**

2022.10.24 [Math-NV](https://metacpan.org/dist/Math-NV) once I managed to set up the PR for Math-MPFR, this was alread [easy](https://github.com/sisyphus/math-nv/pull/1),
but there were various errors reported in the logs here too. I hope these will be more meaningful to the author of the modules.
The authoris not interested in have CI. **Nope**

2022.10.24 [Perl-Metrics-Halstead](https://metacpan.org/dist/Perl-Metrics-Halstead) I ran into some strange behaviour.
I was expecting **dzil** to install the test dependencies, but it did not.
I opened an [issue](https://github.com/ology/Perl-Metrics-Halstead/issues/1). After I got a response there
it was just a matter of adding a flag to dzil to have [GitHub Actions PR](https://github.com/ology/Perl-Metrics-Halstead/pull/2).
It currently fails on Windows. **DONE**

2022.10.24 [Music-ToRoman](https://metacpan.org/dist/Music-ToRoman) and [PR](https://github.com/ology/Music-ToRoman/pull/1). The idea was rejected as this is only a "fun module". **Nope**

2022.10.24 [Music-ScaleNote](https://metacpan.org/dist/Music-ScaleNote) I bumped into some issues. Luckily I did not waste too much time on trying to figure out the problem as it would have been rejected anyway. **Nope**

2022.10.25 Steven Bakker took issues in his own hands. He [asked for help](https://github.com/szabgab/perlmaven.com/issues/567), but then resolved it alone and now [Term-CLI](https://metacpan.org/dist/Term-CLI) also has
[GitHub Actions](https://github.com/sbakker/perl-Term-CLI) enabled. It could be interesting to see how this is being done for [Term-ReadLine-Gnu](https://metacpan.org/dist/Term-ReadLine-Gnu) and <a
href="https://metacpan.org/dist/TermReadKey">Term::ReadKey</a>. Anyway this is now **done**.

At this point I thought it might be better to first open issues asking the authors if they are interested at all in CI.

2022.10.26 [Kelp-Module-Sereal](https://metacpan.org/dist/Kelp-Module-Sereal) [issue](https://github.com/bbrtj/perl-kelp-module-sereal/issues/2). **rejected**.

2022.10.26 [IO-FD](https://metacpan.org/dist/IO-FD) [issue](https://github.com/drclaw1394/perl-io-fd/issues/1).
[Pull-Request](https://github.com/drclaw1394/perl-io-fd/pull/2) **done**

2022.10.26 [Quiq](https://metacpan.org/dist/Quiq) [issue](https://github.com/s31tz/Quiq/issues/3).

2022.10.26 [App-Elog](https://metacpan.org/dist/App-Elog) [issue](https://github.com/zorgnax/elog/issues/1) [PR](https://github.com/zorgnax/elog/pull/3). **done**

2022.10.26 [BmltClient-ApiClient](https://metacpan.org/dist/BmltClient-ApiClient) [issue](https://github.com/bmlt-enabled/bmlt-root-server-perl-client/issues/1).

2022.11.06 [Math::Round::SignificantFigures](https://metacpan.org/dist/Math-Round-SignificantFigures) [Pull-request](https://github.com/mrdvt92/perl-Math-Round-SignificantFigures/pull/1)

2022.11.06 [List-NSect](https://metacpan.org/dist/List-NSect) [Pull-request](https://github.com/mrdvt92/perl-List-NSect/pull/1)

2022.11.06 [Scope-OnExit](https://metacpan.org/dist/Scope-OnExit) marked as deprecated so I did not send the PR.

2022.11.06 [App-Puppet-Environment-Updater](https://metacpan.org/dist/App-Puppet-Environment-Updater) This is strange. In this [repository](https://github.com/mstock/App-Puppet-Environment-Updater/) the default branch
is called **releases** and it does NOT have GitHub Actions enabled, but there is a separate branch called **master**.
See the the video on [separate release branch for App::Puppet::Environment::Updater](/separate-release-branch-for-app-puppet-environment-updater).

2022.11.06 [Sys-OsPackage](https://metacpan.org/dist/Sys-OsPackage) had to disable testing on OSX and Windows and could not enable RELEASE_TESTING either. [Pull-Request](https://github.com/ikluft/Sys-OsPackage/pull/2).  **DONE**

2022.11.15 [Types-ULID](https://metacpan.org/dist/Types-ULID), [Pull-Request](https://github.com/bbrtj/perl-types-ulid/pull/1) **done**

2022.11.15 [Template-Perlish](https://metacpan.org/dist/Template-Perlish), [Pull-Request](https://github.com/polettix/Template-Perlish/pull/5) **done**

2022.11.15 [Data-ULID](https://metacpan.org/dist/Data-ULID), [Pull-Request](https://github.com/bk/Data-ULID/pull/10) **done**

2022.11.15 [Text-Markdown-Discount](https://metacpan.org/dist/Text-Markdown-Discount) [Pull-Request](https://github.com/sekimura/text-markdown-discount/pull/31) **done**

2022.11.15 [UTF8-R2](https://metacpan.org/dist/UTF8-R2) [Pull-Request](https://github.com/ina-cpan/UTF8-R2/pull/1)

2022.11.15 [Game-TileMap](https://metacpan.org/dist/Game-TileMap) [Pull-Request](https://github.com/bbrtj/perl-game-tilemap/pull/1) **done**.

2022.11.16 [Algorithm-QuadTree-XS](https://metacpan.org/dist/Algorithm-QuadTree-XS) [Pull-Request](https://github.com/bbrtj/perl-algorithm-quadtree-xs/pull/3) **done**

2022.11.16 [POE-Component-EasyDBI](https://metacpan.org/dist/POE-Component-EasyDBI) [Pull-Request](https://github.com/gps4net/POE-Component-EasyDBI/pull/6)

2022.11.16 [Dancer2-Plugin-DoFile](https://metacpan.org/dist/Dancer2-Plugin-DoFile) [Pull-Request](https://github.com/Pero-Moretti/Perl-Dancer2-Plugin-DoFile/pull/2)

2022.11.16 [Algorithm-QuadTree](https://metacpan.org/dist/Algorithm-QuadTree) [Pull-Request](https://github.com/bbrtj/perl-algorithm-quadtree/pull/1) **rejected, but will be done later by the author**.

<!--
2022.11.16 [Apache-Solr](https://metacpan.org/dist/Apache-Solr) <a href=""></a>
2022.11.16 <a href=""></a> <a href=""></a>
-->

