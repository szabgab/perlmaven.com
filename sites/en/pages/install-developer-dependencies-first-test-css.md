---
title: "Show error logs on Github Actions - Install developer dependencies first (Test::CSS)"
timestamp: 2022-10-08T09:30:01
tags:
  - Github
published: true
types:
  - screencast
author: szabgab
archive: true
show_related: true
---


While trying to enable GitHub Actions to the [Test-CSS](https://metacpan.org/dist/Test-CSS) distribution I received the following error:

```
! No MYMETA file is found after configure. Your toolchain is too old?
Configuring /home/runner/work/Test-CSS/Test-CSS ... N/A
! Configuring . failed. See /home/runner/.cpanm/work/1665208338.1655/build.log for details.
Error: Process completed with exit code 1.
```

Surprisingly this only happened on Linux and OSX. On Windows, where we use [Strawberry Perl](https://strawberryperl.com/) everything worked fine.


{% youtube id="N-b3dHpQXZ0" file="perl-install-developer-dependencies-first-test-css.mp4" %}

## Showing error logs

The error message did not help much, so I added the following steps to the GitHub Actions configuration file, to display the content of the log files:

```
   - name: Show Errors on Ubuntu
      if:  ${{ failure() && startsWith( matrix.runner, 'ubuntu-')}}
      run: |
         cat /home/runner/.cpanm/work/*/build.log

    - name: Show Errors on OSX
      if:  ${{ failure() && startsWith( matrix.runner, 'macos-')}}
      run: |
         cat  /Users/runner/.cpanm/work/*/build.log
```

Pushing out the changes triggered another run of the CI and this time I could see the content of the log file in the "Show Errors on Ubuntu" step:

```
...
Running Makefile.PL
Error: Can't locate File/ShareDir/Install.pm in @INC (you may need to install the File::ShareDir::Install module) (@INC contains: /home/runner/work/Test-CSS/Test-CSS/local/lib/perl5 /home/runner/work/_actions/shogo82148/actions-setup-perl/v1/scripts/lib /opt/hostedtoolcache/perl/5.32.1/x64/lib/site_perl/5.32.1/x86_64-linux /opt/hostedtoolcache/perl/5.32.1/x64/lib/site_perl/5.32.1 /opt/hostedtoolcache/perl/5.32.1/x64/lib/5.32.1/x86_64-linux /opt/hostedtoolcache/perl/5.32.1/x64/lib/5.32.1 .) at Makefile.PL line 7.
Error: BEGIN failed--compilation aborted at Makefile.PL line 7.
-> N/A
-> FAIL No MYMETA file is found after configure. Your toolchain is too old?
! Configuring . failed. See /home/runner/.cpanm/work/1665208877.1651/build.log for details.
```

Similar output could be seen from OSX.

## Developer dependency

I assume this is a developer-only dependency so I included it among the other modules we need to install for the author tests and moved the installation of them
before the installation of the run-time dependencies. The final configuration file is this:

{% include file="examples/test-css-ci.yml" %}



