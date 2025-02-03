---
title: "Always require explicit importing of functions"
timestamp: 2017-08-31T08:30:01
tags:
  - Perl::Critic
  - Subroutines::ProhibitCallsToUndeclaredSubs
published: true
author: szabgab
archive: true
---


Modules in Perl are either 
[Object Oriented](/oop), in which case they don't export and your code
[does not import any function](/beginner-perl-maven-using-object-oriented-module),
or they are [procedural](/beginner-perl-maven-using-procedural-module).
In which case you use some of their functions as function.

If you use the default import of several procedural modules that all export many function, you might end up importing two different function,
doing different things, but having the same name. In which case you will see a seemingly unpredictable behavior in which case the order
of import will decide which function is in use.

Being explicit about what you import can greatly reduce this risk, and the maintenance programmer (you know, the proverbial psychopath, who knows
where you live) will praise your name.

So how to make sure you don't forget to explicitly import functions?


As it turns out there is a [Perl::Critic](/perl-critic) policy called
[Subroutines::ProhibitCallsToUndeclaredSubs](https://metacpan.org/pod/Perl::Critic::Policy::Subroutines::ProhibitCallsToUndeclaredSubs)
that requires explicit importing of functions.

It is an ad-on policy that lives in the [Perl-Critic-StricterSubs](https://metacpan.org/release/Perl-Critic-StricterSubs) distribution,
but after you install it, you can use it either on the command line or by enabling it in the `.perlcriticrc` of your project. 

Here you can see it in action while using the `single-policy` flag:

```bash
$ perlcritic --single-policy Subroutines::ProhibitCallsToUndeclaredSubs script.pl
Subroutine "greeting" is neither declared nor explicitly imported at line 5, column 1.  This might be a major bug.  (Severity: 4)
```

## The code

The module we are using is a rather simple module that uses the `import` function
of the standard [Exporter](https://metacpan.org/pod/Exporter) and the `@EXPORT`
array use by that [import](/import) function to, well, export the 'greeting' function.
This is one way to [create a module for code reuse](/how-to-create-a-perl-module-for-code-reuse).

{% include file="examples/explicit_import/MyModule.pm" %}

The script that uses the module, cleverly named 'script.pl', just loads the module and relies on the fact
that the function is exported (and imported) implicitly.

{% include file="examples/explicit_import/script.pl" %}

If you run this script, you will see it works:

```bash
$  perl script.pl 
Hello World!
```

## Explicit importing

While there is a certain level of danger of importing the same function name twice, I think the much bigger issue
is the documentative value of importing functions explicitly. When 2 years after you wrote this someone needs to
read and understand the code of the 'script.pl', which by that time grew to a 2,000 lines long monster using 15
different modules, it will be a great help to be able to easily locate the source of the 'greeting' function.
The easiest way to that is to make the really little effort of explicitly importing the function.

{% include file="examples/explicit_import/explicit.pl" %}

Of course, I know when you have to make some quick changes to a piece of code, and for some reason we are
always asked to do it urgently, you will forget to do this. I certainly would.

In those cases it is a huge help to have a Perl::Critic policy configured and enabled in the tests that will remind
me to do this 2-second long task.

## Comments

even better: always use the fully qualified name if at all possible :) , then you don't have to prefix your subs to make the names meaningfull

<hr>

should be described also how to prevent importing: use Xxxx();
