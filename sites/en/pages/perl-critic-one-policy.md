---
title: "Improving your Perl code - one Perl::Critic policy at a time"
timestamp: 2013-02-17T09:45:56
tags:
  - Perl::Critic
  - perlcritic
published: true
books:
  - beginner
author: szabgab
---


If you are as many other people, you will want to learn from more experienced people and improve your code.
[Perl::Critic](https://metacpan.org/pod/Perl::Critic) is a wonderful tool for this.

Perl::Critic itself is a CPAN module, but it comes with a command line tool, that will let you check your
code against a set of policies.


## Running Perl Critic

After installing Perl::Critic from CPAN, you'll get a tool called `perlcritic`.
You can invoke it on the command line:

**perlcritic lib/Module/Name.pm**

It can generate a lot of output.

For example, in my case it had lots of lines like this, in addition to lots of other types of policy violations.

```
lib/Module/Name.pm: Subroutine prototypes used at line 15, column 1.
    See page 194 of PBP.  (Severity: 5)
```


Each entry will tell you exactly where the policy was violated in your code,
and where to read the Perl Best Practices book. It won't tell you any more details,
especially it won't tell you what is the name of the policy that was violated.

Without the name, you cannot easily turn it off, if that's what you want.

Don't worry though, there is a flag called `--verbose N` that can provide you with more detailed output.
By default it is at level 4, but you can pass it a smaller number to be less noisy, or
a bigger number to provide more details. (According to the documentation, N can be between 1 and 11.)


At level 8, it starts to display the name of the policy:
Running this command: **perlcritic --verbose 8 lib/Module/Name.pm**

will change the report to look like this:

```
[Subroutines::ProhibitSubroutinePrototypes]
   Subroutine prototypes used at line 15, column 1.  (Severity: 5)
```

## Turning off policies one-by-one

Once,you have this, you can create a file called `.perlcriticrc` in the home directory
of your project and add the following line to it:

```
[-Subroutines::ProhibitSubroutinePrototypes]
```

That will turn off the specific policy for your project.

That can be useful if you think the specific policy does not make sense in your project,
some of the rules are really controversial, or if you have too many violations, and you
cannot deal with all of them at once.

You can turn off those that make a lot of noise, and fix them one-by-one.

## Checking for a single policy

So how can you ask perlcritic to check for a specific policy? There is a flag for that called
`--single-policy`

**perlcritic --single-policy  Subroutines::ProhibitSubroutinePrototypes lib/Module/Name.pm**

That's wonderful. Now I can see every place where this specific policy is violated and fix it.
This will work even if you still have the policy turned off in the configuration file.

Before fixing though, I should either read the explanation in the **Perl Best Practices**
book or read the community contributed explanations.
That's easy. Just turn the verbosity level to 10, and you will get out like this:

```
Subroutine prototypes used at line 15, column 1.
  Subroutines::ProhibitSubroutinePrototypes (Severity: 5)
    Contrary to common belief, subroutine prototypes do not enable
    compile-time checks for proper arguments. Don't use them.
```

This policy has a short explanation, some others (for example Subroutines::ProhibitExplicitReturnUndef)
have really long and detailed explanations. (If you feel you have a better explanation for one of the
policies, you can contribute it to the project.)

## Conclusion

When cleaning up a code base, you might want to recognize a single type of issue and fix it through the whole
code base. (Instead of fixing all the problems in a single file.)

To make it easy you can disable all the policies that bother you for some reason,
and can go over the problematic policies one-by-one and fix them in your whole code base.



## Comments

I'm quite keen on the *why* we should use perlcritic. Especially if we're inheriting a 15 year old codebase with fair test coverage.


