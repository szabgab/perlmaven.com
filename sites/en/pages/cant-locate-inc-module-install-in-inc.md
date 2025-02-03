---
title: "Can't locate inc/Module/Install.pm in @INC (you may need to install the inc::Module::Install module) (@INC contains: ...)"
timestamp: 2014-04-08T07:30:01
tags:
  - Module::Install
published: true
author: szabgab
---


In certain cases, when you try to install a Perl module from source code, (e.g. after cloning from GitHub),
you run `perl Makefile.PL` and get an error message:

```
Can't locate inc/Module/Install.pm in @INC (you may need to install the inc::Module::Install module) (@INC contains: ...)
```
with a long list of directories instead of the 3 dots.


This is a special case of the [Can't locate ... in @INC](/cant-locate-in-inc) error message.

You need to [install](/how-to-install-a-perl-module-from-cpan) the module called
[Module::Install](https://metacpan.org/pod/Module::Install) before you go on.

Check out the other article explaining how you can [install a Perl module from CPAN](/how-to-install-a-perl-module-from-cpan)
depending on your situation.


## Background

There are at least 4 main ways to [create a Perl module distribution](/minimal-requirement-to-build-a-sane-cpan-package).
One of them is by using [Module::Install](https://metacpan.org/pod/Module::Install).

The developers of the module will have Module::Install on their system, and when they release the module to CPAN,
part of the installer is automatically included in the zip file uploaded to CPAN. The part that is included in the
<b>inc/</b> subdirectory is called `inc::Module::Install`. It might be a bit strange if this is the first time
you encounter it, but it works because `.`, the <b>current working directory</b> is part of `@INC`.

So when the `Makefile.PL` reached the `use inc::Module::Install;` statement, it will find the file in
`inc/Module/Install.pm`. That is, in the packaged distribution of the module.

In regular circumstances, when you install the module from CPAN, it already comes with inc::Module::Install, and
everything works fine. On the other hand, when you try to install the module from the version control system,
that usually does not include the `inc/` subdirectory. (And that's OK, these files should not be part of the
version control system of the module under development.) In this case you basically act as the a developer of the said
module, and you are expected to install [Module::Install](https://metacpan.org/pod/Module::Install) yourself
to somewhere in `@INC`.

Once you have installed Module::Install, run `perl Makefile.PL` of the desired module again again.
It will probably list the dependencies and even offer you to install them automatically.

## Comments

Can't locate ReadFastx.pm in @INC (you may need to install the ReadFastx module) im getting this error

<hr>

I have installed a module: Bio::Perl , but when I try to execute it in Padre, it shows an error can not locate BioPerl in @INC. Please guide me Sir!

use strict;
use warnings;
use lib 'C:/Perl/site/lib';
use Bio::Perl;
$seuence="ATGGGGGAAAACCCC";
$reverse_complement = revcom( $sequence );
print $reverse_complement;


