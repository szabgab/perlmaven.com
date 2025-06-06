---
title: "Don't keep generated files in version control"
timestamp: 2015-02-17T08:45:56
tags:
  - .gitignore
  - .hgignore
  - svn:ignore
published: true
author: szabgab
---


If you write open source code it is very useful to have a public version control system, but it is also
important to remember what <b>not</b> to put in version control. Besides passwords, credit card numbers and other
private information, one should also avoid putting files that are generated by various tools.
Including the build and release processes.


<h2 id="why">Why to exclude generated files?</h2>

Before going to the list of [what](#what) and the explanation of [how](#how), let's see <b>why</b> should we exclude generated files.

One of the values a version control system provides is making it easy to locate the changes we made. If there are
files that were generated by various tools, those just create noise that makes it harder to focus on the real changes.

Besides, some of these files might include a timestamp so even if you have not changed anything in the code,
just ran `perl Makefile.PL` you might get these files updated. Adding these changes to the repository would
create a lot of noise.

There are cases when opening a source file for reading will create a temporary file (e.g. vim will create a swap file).
It would be very disturbing to see these files in the repository.

If you use a Mac, and use the Finder to browse the project directory, it might create a file called `.DS_Store`
we certainly don't want those to litter the filesystem of other people.

Finally, some of the generated files will be different among operating systems or even architectures of the same
operating system. They might even differ based on what other Perl modules you have installed.

Seeing all those changes in the history will just confuse everyone and will make it hard to focus on the
real changes.
 
<h2 id="what">What to exclude</h2>

Now let's go over the files and directories that should <b>NOT</b> be under version control and have some explanation
what is what. We can even try to categorize them as [Neil Bowers](http://neilb.org/) suggested.

<h3>Files generated by various parts of the Perl/CPAN toolchain</h3>

The `blib/` directory (which probably stands for build lib) is where the build process creates a directory structure
that will be installed. In a simple perl modules this means copying the `.pm` files from the `lib/` directory
to the `blib/` directory. In more complex cases modified versions of the `.pm` files are placed in the
`blib/` directory. I even recall modules that were creating `.pm` file on-the-fly during the `perl Makefile.PL`.
Other distributions, especially ones that are partially based on XS or C code, will put compiled files in the `blib/`
directory.

`Build` and `Build.bat` are created by `perl Build.PL` and they aid in the release and installation process.
The former is created on *nix systems. The latter on MS Windows. Neither of these need to be kept around, nor should they be distributed.

`_build/` is also created by `perl Build.PL` and holds several files aiding the build process. No need
to keep them or to distribute them.

`/.build/`

`.last_cover_stats`

`Makefile` is created by running `perl Makefile.PL`. It can be very specific to the current system so
it should not be kept in version control or distributed.

`Makefile.old` and `Makefile.bak` are two "backup copies" of the Makefile. Usually none of them is needed.
Certainly they should not be kept around in version control, nor should they be distributed.

`pm_to_blib` is an empty file created by the build process. It is used only to check if any of the source files are
out of date and needs to be rebuilt.

The `inc/` directory is created by [Module::Install](https://metacpan.org/pod/Module::Install). The content
of this directory should be included in the distribution, but should not be in the version control system. The directory
is created when the developer runs `perl Makefile.PL` and it is used when the user installing the module runs
`perl Makefile.PL`.

`META.yml` and `META.json` both contain computer readable meta-information about the distribution. They
are based on the content of the Makefile.PL, Build.PL, dist.ini and on the content of the modules being distributed.
There are two files for historical reasons. Originally it was just the yml file, now many people also include the json file.
Theoretically the content should be identical, though as far as I know the json file usually contains more details.
Some tools, e.g. [MetaCPAN](https://metacpan.org/) use the content of these files.
They are generated during the release of the distribution, and they should be included in the distribution,
but because they are generated files, they should <b>NOT</b> be under version control.

`MYMETA.json` and `MYMETA.yml` are similar to the META.json and META.yml files but they incorporate the
local specialties of the system where the distribution is currently being installed. They are used during the installation process,
but because they are site specific they should <b>NOT</b> be included in the distribution, and the should <b>NOT</b>
be under version control.

If you use `MANIFEST.SKIP` then I'd add `/MANIFEST` to the .gitignore file. 

`Distribution-Name-*` - If this is a repository of a distribution that will be released as Distribution-Name-1.02.tar.gz then
the build process is going to create a directory called Distribution-Name-1.02/ and then a
file called Distribution-Name-1.02.tar.gz. None of these should be kept in the repository where we keep the source code.

<h3>Files generated by various Perl tools</h3>

The `cover_db/` directory is created by [Devel::Cover](https://metacpan.org/pod/Devel::Cover) module when
you generated a test-coverage report.

`nytprof.out` is created by [Devel::NYTProf](https://metacpan.org/pod/Devel::NYTProf), the profiler
many people use. This generated file should not be kept in version control, nor should it be included in the distribution.

`.tidyall.d/` is a directory created and maintained by [Code::TidyAll](https://metacpan.org/pod/Code::TidyAll).
It is a cache to speed up the perltidy process.

<h3>Files from the OS</h3>

On Mac the Finder, the directory browser creates a file called `.DS_Store` in directories
one visits. This is computer specific and should be excluded from the version control system

<h3>Files from text editors, compilers, etc</h3>

If you use `vim` for editing file I'd add `*.swp` to ignore  the swap files.

<h2 id="how">How to exclude</h2>

It depends on the version control system you use. [Git](http://git-scm.com/) will look at a file called `.gitignore` in the root
of the repository. [Mercurial](http://mercurial.selenic.com/) (HG) looks at a file called `.hgignore`
in the root of the repository.  [Subversion](https://subversion.apache.org/) uses the `svn:ignore` property
on a directory to defined what items to ignore in that directory.  The SVN Book describes
[how to ignore unversioned files in Subversion](http://svnbook.red-bean.com/en/1.7/svn.advanced.props.special.ignore.html).

GitHub maintains a repository of [gitignore files](https://github.com/github/gitignore).
They have language, project, operating system and editor specific gitignore files. A good gitignore file
is for a perl project is probably a combination of several of these files.

## .gitignore for Git users

As Git is currently the most widely used version control system for Perl-based project, let's see a
useful `.gitignore` file with some explanation.

If you have a Git repository you can easily tell it which files to ignore.
You create a file called `.gitignore` in the root directory
of your repository and then follow the [instructions on gitignore](https://help.github.com/articles/ignoring-files/).
If you'd like to understand more deeply, then you can also read the
[explanation about .gitignore](http://git-scm.com/docs/gitignore).

In [this repository](https://github.com/github/gitignore) there is a sample 
[gitignore file for Perl developers](https://github.com/github/gitignore/blob/master/Perl.gitignore)
I've repeated here:

```
/blib/
/.build/
_build/
cover_db/
inc/
Build
!Build/
Build.bat
.last_cover_stats
/Makefile
/Makefile.old
/MANIFEST.bak
/META.yml
/META.json
/MYMETA.*
nytprof.out
/pm_to_blib
*.o
*.bs
```

I'd probably add the following:

```
# If MANIFEST.SKIP is used:
/MANIFEST

# Mac Finder generated:
.DS_Store

# vim swap files:
*.swp

# random backup files:
*.bak

# Code::TidyAll Test::Code::TidyAll cache:
/.tidyall.d/
```


In addition there are some module specific things you might want to add to the .gitignore file:

```
# Dancer puts the session objects in the session directory and the logs in the logs/ directory
/session
/logs
```


If you have additions or more recommendation, you can fork the repository of this site and send me a pull-request.
Look for the big green button at the top of the page.

