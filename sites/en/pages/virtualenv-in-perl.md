---
title: "Virtualenv in Perl 5 - install 2 different versions of the same module"
timestamp: 2017-12-03T07:30:01
tags:
  - cpanm
  - cpanminus
published: true
author: szabgab
archive: true
---


Virtualenv is a great tool in Python that allows the user to separate the 3rd-part package installations of various projects.

When we have multiple projects on the same system using the same modules but requiring different versions we have a problem.

We need to be able to install two different version of the same module. Perl 5 does not provide a way to do this.


## The solution with CPAN Minus

```
cd project_root/

export PERL5LIB=venv/lib/perl5
export PATH=venv/bin/:$PATH
cpanm -l venv/ --installdeps .
```

CPAN Minus is one of the clients of CPAN that makes module installation easy. We just type in

```
cpanm Module::Name
```

and it will install the module.

If we have a `Makefile.PL` that lists all the dependencies of our project we can then use

```
cpanm --installdeps .
```

to install all the dependencies of our project.

Using the `-l` flag we can tell `cpanm` where to install the modules.

If we would like to use the `venv` (any arbitrary directory name would work) directory
inside the root of our project we can pass `-l venv` to `cpanm` and it will
install the modules in that directory.

We also want to make sure the modules that were installed can be found.
This is important any time a module is to be used, including when it is used during
the installation of another module depending on it.
So we assign the appropriate value relative to the `venv` directory:

```
export PERL5LIB=venv/lib/perl5
```

**before** we try to install modules.


Finally, some modules will install executables in the `venv/bin` directory.
We would want the command line to find them:

```
export PATH=venv/bin/:$PATH
```


## Comments

Also check out carton... A much more robust way of doing this.

<hr>

Does not work: I exactly followed your instructions.

$ cpanm -l venv/ --installdeps .
--> Working on .
Configuring /Users/tperiasa/work/perl-dev ... OK
find_module_by_name() requires a package name at /usr/local/bin/cpanm line 35.


