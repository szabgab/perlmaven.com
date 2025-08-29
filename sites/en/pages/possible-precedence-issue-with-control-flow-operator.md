---
title: "Possible precedence issue with control flow operator"
timestamp: 2017-09-12T12:30:01
tags:
  - warnings
  - B::Deparse
published: true
author: szabgab
archive: true
---


Recently I've encountered some code hidden in a 1000-line long file that looked like this:

{% include file="examples/return_or.pl" %}

I am not even sure how I noticed it, but it looked incorrect so I created the above simple example.


If we run that script we get:

```
1: hello
2: 
```

I think the intention was to return the 'default' value if the `$param` is empty, but 
that should be written as:

```perl
    return $param || 'default';
```

or, if we only want to  [use the 'default' value](/how-to-set-default-values-in-perl)
in case `$param` is
[undef](/beginner-perl-maven-undef) then, starting from perl 5.10 we should write

```perl
    return $param // 'default';
```

The problem with using `or` is that its precedence is lower that that of the `return` call.

We can use [B::Deparse](https://metacpan.org/pod/B::Deparse) to learn what perl really thinks about our code.

Running

```shell
perl -MO=Deparse,-p examples/return_or.pl
```

We get the following output:

{% include file="examples/return_or_deparsed.pl" %}

Look at line 4. It is of course strange, but basically it means

Return the content of `$param` and if the return call resulted
something [false](/beginner-perl-maven-true-false), then check the content of 'default',
but don't do anything with it.

Not very clever, but that's what perl understands.

## How to locate these issues?

Now that we know this code is incorrect, we can hopefully go and fix it replacing `or` with `||`,
but given a huge code-base, how can we find all the other places where such code was written?

As you can notice this code-base omitted the [use warnings](/always-use-strict-and-use-warnings) statement.

So what happens if we add `use warnings;` ?

Nothing.

We get the same results and no warnings.

We use perl 5.16 in our system and As it turns out this specific issue has not triggered a warning in that version of perl.
Not even in 5.18.2.

The first version I have on my computer that warns about this construct is perl version 5.20.

It says:

**Possible precedence issue with control flow operator**.

## Conclusion

[Always use warnings](/always-use-strict-and-use-warnings), and even if you don't plan to upgrade
to newer version of perl, run your tests there too. At least your compile-test.
They can reveal all kinds of potential bugs.

Also [check for no warnings](/testing-for-no-warnings) during the tests. That will help you locate
new warnings that were not around in previous versions of Perl.

## Comments

somewhere in documentation it is documented that `return` looks like a function call, but actually it is not. So we should not expect `or ...` willbe executed after `return ...`

But I agree with you. It will be good if perl warn about never reachable code.

<hr>

This reminds me of a similar problem I had once with `exit`; I wrote a blog post about that ( https://blogs.perl.org/users/buddy_burden/2014/06/when-a-failure-is-not-a-failure.html )

I'm not sure it's the same issue—I'm not sure if `return` is considered a named unary operator like `exit`—but tobyink's final comment on my blog post is interesting either way. :-)

