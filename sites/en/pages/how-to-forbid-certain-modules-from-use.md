---
title: "How to forbid certain Perl modules from use?"
timestamp: 2017-08-25T10:30:01
tags:
  - Perl::Critic
  - Modules::ProhibitEvilModules
published: true
author: szabgab
archive: true
---


When you inherit a code base there might be uses of old, deprecated modules that you'd like to avoid. You can
grep through the code-base trying to find all the locations, but that will not stop some of the new (or old)
developers to start using the module again. You can write a test-case doing the grepping, but I found
[Modules::ProhibitEvilModules](https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitEvilModules)
Perl Critic rule that will do it for you.


In the `.perlcriticrc` file of your project add the following:

```
[Modules::ProhibitEvilModules]
modules = Switch Fatal JSON JSON::MaybeXS 
```


When you run perlcritic on your code-base you'll see a policy-violation report like this:

```
lib/Perl/Maven.pm: [Modules::ProhibitEvilModules] Prohibited module "JSON" used at line 9, column 1.
    Use this policy if you wish to prohibit the use of specific modules.
    These may be modules that you feel are deprecated, buggy, unsupported,
    insecure, or just don't like.
```

That would baffle some of the developers though. Why is JSON prohibited?

## Provide your own error message

An improved version of the configuration file would like this:

```
[Modules::ProhibitEvilModules]
modules = Switch Fatal JSON { use Cpanel::JSON::XS instead of JSON } JSON::MaybeXS { use Cpanel::JSON::XS instead of JSON::MaybeXS }
```

The error message in this case will include whatever we put in the curly braces:

```
lib/Perl/Maven.pm: [Modules::ProhibitEvilModules]  use Cpanel::JSON::XS instead of JSON  at line 9, column 1.
    Use this policy if you wish to prohibit the use of specific modules.
    These may be modules that you feel are deprecated, buggy, unsupported,
    insecure, or just don't like.
```

This is probably much better than the default message.

## One module per line

An even better approach, if you have many modules you'd like to forbid, is to create a separate file containing the list.
In that case the `.perlcriticrc` file would contain 

```
[Modules::ProhibitEvilModules]
modules_file = .forbidden_modules
```

(You can use any filename instead of `.forbidden_modules`)

The the `.forbidden_modules` file can contain lines like these:

```
Switch
Fatal
JSON           use Cpanel::JSON::XS instead of JSON
JSON::MaybeXS  use Cpanel::JSON::XS instead of JSON::MaybeXS
# DateTime      use DateTime::Tiny or Time::Moment instead
```

Here each line contains the name of the forbidden module and then the error message. We don't even need to use the curly braces
and we can add comments after `#` or we can comment out certain entries if we cannot apply them yet.


## Which modules to forbid?

This of course will entirely depend on your situation and your judgment, but let me give you a few suggestions with recommended
error messages.

```
DateTime         Use DateTime::Tiny or Time::Moment instead.
Fatal            Use autodie instead of Fatal.
File::Slurp      Use Path::Tiny instead of File::Slurp.
JSON             Use Cpanel::JSON::XS instead of JSON.
JSON::MaybeXS    Use Cpanel::JSON::XS instead of JSON::MaybeXS.
JSON::Syck       Use Cpanel::JSON::XS instead of JSON::Syck.
JSON::PP         Use Cpanel::JSON::XS instead of JSON::PP.
MIME::Lite       Use Email::Stuffer instead of MIME::Lite.
Mouse            Use Moo or Moose instead of Mouse.
Switch           Use if, elsif instead of the deprecated Switch module.
XML::Simple      Use XML::LibXML instead of XML::Simple.
YAML             Use YAML::XS instead of YAML.
lib              Only scripts should change @INC. Modules should not.
Acme::Damn       Use Data::Structure::Util for unbless instead of Acme::Damn.
```

To be clear this list does not mean the modules on the left hand side are not receommended.
Especially in the case of DateTime which is awesome. We (at a client of mine) just had a situation where DateTime::Tiny
was enough and we wanted to make sure others in the organization will switch to the lighter module.

Same with some of the other modules.


