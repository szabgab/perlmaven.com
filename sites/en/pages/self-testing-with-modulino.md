---
title: "Self testing Perl modules using the Modulino concept"
timestamp: 2017-12-20T14:30:01
tags:
  - Test::More
  - tests
  - modulino
published: true
books:
  - testing
author: szabgab
archive: true
---


Earlier we saw how to create a [modulino which is both a module and a script](/modulino-both-script-and-module).  In this example we'll see how to use this feature to create a file that can include its own unit-tests.


We are going to create a module called **SelfTestingCalc.pm**  and a script called **use_self_testing_calc.pl**.
The latter looks like any other Perl script. It loads a module importing a function and then calls that function.
Nothing special:

{% include file="examples/use_self_testing_calc.pl" %}

If we run this script we see the result printed on the screen:
```
$ perl use_self_testing_calc.pl
7
```

On the other hand, if we try to "run" the module we see the same [Test Anything output](/tap-test-anything-protocol) as we would see if we ran a [unit test](/testing-a-simple-perl-module).
Including potential test failures:

```
$ perl SelfTestingCalc.pm
1..4
ok 1
ok 2
not ok 3
#   Failed test at SelfTestingCalc.pm line 24.
#          got: '42'
#     expected: '0'
ok 4
# Looks like you failed 1 test of 4.
```

The source code of the module is here:

{% include file="examples/SelfTestingCalc.pm" %}

The first part of the module is exactly the same as we would write any "normal" module.
Well, maybe except of the fact that I added a deliberate error case in the `add` function
just so I can show you a test failure.

The difference is that we also have a `self_test` function and then we call this function
at the bottom of our module if it is [executed as a script](/modulino-both-script-and-module).

In the `self_test` function we write almost exactly the same as we would write in an external
test file discussed in the [testing series](/testing).

There are two differences:

One is that we load the module using the run-time [require](/use-require-import) and the
[import](/use-require-import), instead of the compile-time [use](/use-require-import) statement.

The other is that we have to put parentheses after each one of the functions imported from the [Test::More](https://metacpan.org/pod/Test::More) module such as `plan`, `ok`, `is`, `like`, ...


## Why write self testing modules?

Just as having documentation embedded in the module in [pod](/pod-plain-old-documentation-of-perl) format will ensure that the code is not distributed without documentation, having test-code embedded in the module will also make sure you can always test the module.

Despite this advantage of course the need to compile this extra code on every invocation of the module might make some people feel uncomfortable and this does not provide a clear suggestion where to put cross-module tests, but this certainly can be an option. Especially in projects where the directory layout is different from the ["standard Perl project layout"](/distribution-directory-layout).


## More about self testing Modulinos

Read more about self testing Modulinos in
[Mastering Perl](https://www.amazon.com/gp/product/144939311X/?tag=szabgab-20) by brian d foy who coined the term.

## Comments

Wow! It's a neat concept :) What really surprised me is the "import Test::More;". If I understand correctly, It's indirect method calling, right?


Some odd little corners of Perl. I hope this helps clear things up.

It's just doing what `use` does at compile time at run time. That way you only get the Test::More overhead if you are actually using it. See https://perldoc.perl.org/functions/use

Indirect method calls are when you use the `my_method MyClass arg1, arg2, ...` syntax. You don't see it much because we have learned to avoid it due to the fact that it is ambiguous. See https://perldoc.perl.org/perlobj#Indirect-Object-Syntax

It's all in TFM, assuming you can find it. I've been rereading the darn things for nearly 20 years and sometimes things still surprise me.


<hr>

the need to compile this extra code on every invocation

Compromise might be to move tests to t/xxx.t once you have finished development. And add a "require" in the self_test sub.

