---
title: "Can't locate ... in @INC"
timestamp: 2013-07-25T07:30:01
tags:
  - warnings
  - @INC
published: true
books:
  - beginner
author: szabgab
---


One of the frequent compile time errors people get from Perl looks like this:
`Can't locate Acme/NameX.pm in @INC (@INC contains: ... )`

Starting from Perl version 5.18 it will say:

`Can't locate Acme/NameX.pm in @INC (you may need to install the Acme::NameX module) (@INC contains: ... )`

a much needed improvement, that already helps people go in the right direction.


Experienced Perl developers already know what does this mean but 
people with little or no experience with Perl might not understand it.
Especially because instead of ... there is usually a long list of directories.
In all that noise the important part gets a bit lost.

This error means your code is trying to load the Acme::NameX module, but cannot
find it. 

You probably have either `use Acme::NameX` or `require Acme::NameX`
somewhere in your code.

In order to load this module, Perl will go over the directories listed in
an internal array of Perl called `@INC`. In each directory it will look
for a subdirectory called Acme, and inside that subdirectory a file called NameX.pm.

If it cannot find the file, then you will get the above error.

## Why Perl cannot find the module?

Either there is a typo in the name of the module
(e.g. in our case the module is probably called Acme::Name),
or you don't have the Acme::Name module installed.

Please also note that the names of the modules are case sensitive.
So if you write `use acme::name`, it will not find the module
Acme::Name. (And on Windows it might find it but it will still not work
properly.)

If you have just installed the module, then either it was installed in
a non-standard place, or it actually failed the installation.

What you can do is try to look at the output of the command you used
to install the module. If you don't have that, then try to install
it again, but this time pay really close attention to what is being printed.

It might say where does it fail, but if it was successful it will tell you
in which directory was it placed.

Then you can try to see if it is one of the directories listed in `@INC`.
You can get the list of directory on the command line by typing `perl -V`.

If, for some reason it was installed in a non-standard directory, you can
[change the @INC array](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)
in several ways.

On the other hand, if the module is part of your applications, then you might
want to [change @INC relative to your script](/how-to-add-a-relative-directory-to-inc). (pro article)

## Can't locate warning.pm in @INC

A very special case of this error messages is when perl cannot locate the <b>warning</b> module.
(Although many people will call it pragmata and not module.)

```
Can't locate warning.pm in @INC ...
```

 I often see this very special case when I am teaching Perl to beginners. The first thing I teach is
to always add `use warnings;` at the beginning of every script. Unfortunately in many cases
people write `use warning;` leaving out the trailing <b>s</b>. So this is is just a simple case of typo.

## Comments

This problem might appear when you are using system function on perl to run another script inside yours. The reason for this in my case was that system function is called in a terminal that weren't allowed to load all the environment that contains my PM module. I found the following line in my ~/.cshrc file:

# Exit if this is not an interactive shell
#if ($?prompt == 0) exit

Since the terminal that is executed the linux command from the perl script is not interactive the script failed with the same error that is addressed in this thread.

<hr>

I seem to have everything in order, but still getting error. Module is installed, .pm file exists, file permissions on file are sufficient and the path is included in @INC. I disabled SELINUX and stopped iptables. Can't uninstall and reinstall perl modules. Any ides?

---

Which module are you trying to use?

<hr>
You just saved a nerd , I was writing use warning


