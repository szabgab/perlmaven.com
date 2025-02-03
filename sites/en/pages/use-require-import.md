---
title: "What is the difference between require and use in Perl? What does import do?"
timestamp: 2017-01-27T10:00:11
tags:
  - use
  - require
  - import
  - BEGIN
types:
  - screencast
books:
  - advanced
published: true
author: szabgab
---


We have learned about [modules](/modules) and how to [load them to memory](/require-at-inc),
but I have not explained the difference between `use` and `require`, and you probably have seen
`use` in most places and I have only explained about `require` in the previous episode.


<slidecast file="advanced-perl/libraries-and-modules/use-require-import" youtube="1W_llZqt74k" />


## require

We saw

```perl
require Math::Calc;
```

when the script is running and it reaches the above expression, it will go over the directories listed in
the `@INC` array, check if any of them has a subdirectory called `Math` and if that subdirectory
there is a file called `Calc.pm`. When it finds the fist such file, it loads it into memory, compiles it and stops the search.
This will let you use the functions of the module with their [fully qualified name](/namespaces-and-packages) (eg. `Math::Calc::add()`)

## use

If you have either of these expressions in the code:
 
```perl
use Math::Calc;
```

```perl
use Math::Calc qw(add);
```

then perl will load and compile the module during the compilation time of the script.
That's because having `use` in the script will be replaced by the following piece of code
in the file:

```perl
BEGIN {
    require Math::Calc;
    Math::Calc->import( qw(add) );
}
```

The `BEGIN` block means that we ask perl to run the code inside the block immediately when that
part of the script has finished compiling.

So during the compilation for phase, when perl finished compiling the code in the BEGIN-block, it will
pause the compilation and execute the code inside the block. The first statement there is the `require`
statement that means, find the `Math/Calc.pm` file, load it and compile it.
The second statement in the `BEGIN` runs the `import` method of the newly loaded module if
there is such a method. (If there is no `import` method then nothing happens.)

If the user who typed in `use Math::Calc ...` also added a list of values, as we did in the second
example with the `qw(add)`, then this list is passed to the `import` method.

What the `import` method does is up to the author of the (`Math::Calc`) module, but in most
cases it will arrange for the `add` function to be inserted in the name-space of the code where
the `use` statement was located so that the author of that code can call `add` without
providing the fully qualified name `Math::Calc::add()` of the function.

In other words, the `import` method imports the `add` function to the name-space of the user.


So that's the difference. `require` happens at run-time, and `use` happens and compile-time
and the `use`, in addition to loading the module, it also imports some functions into the current name-space.

## Load conditionally

So some people might think they want to load a module conditionally so they write:

```perl
if ($holiday) {
    use Vacation::Mode;
}
```

but this <b>does NOT work</b> as we expect because the `use` statement, regardless of its location(!)
will be executed during compile time. So when perl compiles this script and reaches the if-statement
in the compilation, it will load the `Vacation::Mode` module and import its function, regardless
of what value the variable `$holiday` will hold during run-time.

If you want to load modules on condition, in order to save on start-up time, or save on memory consumption
hoping that you won't need to load all the modules in a give process, then you can write the following:

```perl
if ($holiday) {
    require Vacation::Mode;
    Vacation::Mode->import;
}
```

Because `requires` is only executed during run-time, this piece of code will be executed only during run-time
and only if the `$holiday` variable holds something that is considered True by Perl.

Then you can call the `import` method of the module. If you want to.

## Comments

Maybe also discuss Module::Load which is pretty cool when you want to dynamic include modules or files. Good article!

<hr>

include() function it adds the content of the page or
file into the file where this function is used.If there is any problem
in loading a file then the include() function generates a warning but the script will continue execution. require() function takes all the text in a specified
file and copies it into the file that uses the include function. If
there is any problem in loading a file then the require() function generates a fatal error and halt the execution of the script.Vistit Here for example
https://techlifediary.com/whats-difference-include-require-functions/

<hr>

I have encountered a "problem" with require in that the loaded script cannot see the <std in=""> of the calling script. (The "require" / second script cannot be amended in any way, ie moving the data in STD IN to @ARGV etc!)


