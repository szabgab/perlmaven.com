---
title: "Use the same sub as function or as method in Perl"
timestamp: 2019-09-13T14:30:01
tags:
  - bless
  - ref
published: true
author: szabgab
archive: true
---


When you write a modules, sometimes you'd like to allow your users two ways of operations. A simple one for which you provide a single function
and a complex one where they need to instantiate an object of your class and call methods.

Sometimes you'd like to use the same function name for both case.

I found an examples in version 1.000031 of [Text::Markdown](https://metacpan.org/pod/Text::Markdown)

Let's see how does it work:


## The code snippet

The relevant part of the code was coped here:

{% include file="examples/method_or_function_in_text_markdown.pm" %}

## Using the function / method

It can be used in two ways.

As a function:

```perl
use Text::Markdown 'markdown';
my $html = markdown($original_text, { option => "value" });
```

or as an instance method:

```perl
use Text::Markdown;
my $m = Text::Markdown->new;
my $html = $m->markdown($original_text, { option => "value" });
```

## The problem

The big problem that need to be solved is that in the functional mode the first parameter that the `markdown` function
receives is the `$original_text` while in the OOP case perl will pass the object (`$m`) in front of the `$original_text`.
So we need a way inside the `markdown` function to differentiate between the two cases.

In the OOP case we inside the `markdown` sub:

```perl
$self = $m;
$text = $original_text;
$options = { option => "value" };
```

In the functional case we have inside the `markdown` sub:

```perl
$self = $original_text;
$text = { option => "value" };
$options = undef;
```


## Explanation of the OOP case

While using the function-interface might be simpler, I think it is simple to explain the implementation of the OOP version first.

After loading the module with `use Text::Markdown;` we call the `new` method, the constructor of our class.
The `new` method creates a blessed reference to a hash. (In our copy it is an empty hash, in the real code it was filled by some parameters,
but that's not the issue for us now.)  See the explanation about the [constructor in core Perl](/core-perl-oop-constructor) or the
[Constructor and accessors in classic Perl OOP](/constructor-and-accessors-in-classic-perl-oop) or even the
[Getting started with Classic Perl OOP](/getting-started-with-classic-perl-oop).

Once we have our instance object in our hand (in the `$m` variable in the above example) we call the `markdown` method passing
the the `$original_text` to it that we would like to parse.

In the `markdown` method we accept 3 parameters. The first is assigned to `$self`. As explained it the links above, when we call
a method with the `$object->method(param, param)` notation, Perl will take the `$object` and pass it as the first parameter
before the first param. So when we call `$m->markdown($original_text, { option => "value" })`, perl will actually run `markdown($m, $text, { option => "value" })`.

The method in the example also accepts a third parameter called `$options`. It is the second "param" to be passed by the user of the module.

Then there is the code to detect and handle the functional mode. (The comment was in the original code.)

Here we use the [ref](/ref) function to check the reference type of the variable. In the OOP case `$self`
will be a reference to a hash blessed into the `Text::Markdown` class or to its subclass if there was one.
In that case `ref $self` will return the name of the class. We are not interested in the actual value, just that it has
something in it, that it is not empty.

`unless (ref $self) {`  which is the same as `if (not ref $self) {`.

The condition will enter the block only if `$self` is not a reference. If we called `$m->markdown($original_text, { option => "value" })` then
`$self` is the same as `$m` for which `ref $self` returns the name of the class which means we skip the whole block.

In the next line `$options ||= {};` we set the options to be [by default](/how-to-set-default-values-in-perl) an empty reference to a hash in case
it was not provided.

The code `%$self = (%{ $self->{params} }, %$options, params => $self->{params});` takes those options and updates the list of parameters already in
the instance. Currently we are not interested in how this works.

Finally we call the `_Markdown` method that does the real work of parsing the Markdown text.

## Explanation of the functional case

In this case we load the module and import the `markdown` function by `use Text::Markdown 'markdown';`
then we simply call the `markdown` function passing the the `$markdown_text`, and the `{ option => "value" }` to it without creating an object.

In this case the content of `$markdown_text` will be assigned to the variable `$self`, the `{ option => "value"}` will be assigned to `$text`,
and the variable `$options` will be [undef](/undef-and-defined-in-perl).
Yes, you are right to be slightly disgusted. The values are assigned to the wrong variables.

This is the price we pay if we want to have the same name work in both ways. This is also what we need to correct in the code so that it will work properly.

When we reach `unless (ref $self) {` the variable `$self` will contains plain string for which `ref` will return false. This means that we enter the block
of the `unless`.

Inside there is a safety check. We check if `$self` is the same as the name of our package found in the `__PACKAGE__` variable. `__PACKAGE__`
is `Text::Markdown` in our case. You might wonder why would be pass the name of the package as the first parameter to the `markdown` function. We probably would not on purpose,
but that would happen if we called `markdown` as a class-method the same way as we called `new` above.

If the user wrote `Text::Markdown->markdown($text);`, an easy to make mistake, then `$self` in the `markdown` function would contain `Text::Markdown`.
the condition `if ( $self ne __PACKAGE__ ) {` is there to properly report if that was the case. If the condition fails then we get to the `else` part that will
`croak` (similar to [die](/beginner-perl-maven-die-warn-exit), just better).

If the condition is true then we create an instance object using the `new` method and call the `markdown` function, but this time as a method. As the comment explains this is the time
to fix the misalignment of the parameters. `# $self is text, $text is options`.

I personally feel the condition should be the other way around, but that's probably just personal taste as I prefer positive code.

## Working example

This is a module based on the above code that has all the other requirements I left out from the above code. This is executable:

{% include file="examples/method_or_function/Module.pm" %}

Here are the tests to show it works:

{% include file="examples/method_or_function/test.t" %}

Just as the original code, this one also has one input check to protect against one user error. The calling of `markdown` as a class-method we discussed
above. Probably this was a use-case the author of the module has encountered. (I know I fell in this trap myself several time.)

There are a number of other ways as well to break the code. For example calling `markdown({}, 'abc')` will return `Parsing 'abc' with options ''`.
We could try to protect our code against this and probably other incorrect uses, but probably it is not worth the effort.

