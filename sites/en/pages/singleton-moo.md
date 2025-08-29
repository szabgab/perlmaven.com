---
title: "Singleton Moo"
timestamp: 2015-05-08T09:40:01
tags:
  - MooX::Singleton
books:
  - moo
published: true
author: szabgab
---


While one of the main ideas behind Object Oriented programming is to be able to
create multiple, and different instances of the same class, this is not always convenient.

If you have a class representing users of a system, we probably want to be able
to create several instances, but in most applications there should be only one
set of configuration at any given time.

The [Singleton Pattern](http://en.wikipedia.org/wiki/Singleton_pattern)
offers the theory behind the solution.


Let's start with a very simple example using the
[MooX::Singleton](https://metacpan.org/pod/MooX::Singleton)
extension of [Moo](https://metacpan.org/pod/Moo).

We have the `MyConf.pm` file with the following content:

{% include file="examples/singleton-moo/MyConf.pm" %}

For now it only receives a filename, the name of the configuration file it is supposed
to read, but to keep the example small we don't actually read the file. 

Our "application" code looks like this:

{% include file="examples/singleton-moo/application.pl" %}

Instead of calling `new` as the constructor, we must call the
`instance` method. For the first call it behaves exactly 
as the `new` method would, but when we call it again it
disregards the parameters and returns the exact same object as earlier.

Calling `new` does not have any special behavior. The output of
the above script will be:

```
conf.ini
conf.ini
conf.ini
other.ini
zorg.ini
```

Please note, the `instance` method will silently ignore any
arguments passed in the second or any subsequent call.
This can cause surprises, so I'd recommend passing arguments only
in one place of the application and calling `instance` without
any arguments in other places.

## Why is this singleton interesting?

The above example is probably not showing why is using a singleton interesting.

What if we have an application implemented in 10 different modules, all of which need
access to the configuration information?

One solution would be to create an instance of the `MyConf` class in the main script
and then pass that object to the constructor of each class. Then each class would have
an attribute called `conf`. This is doable, but it requires a lot of parameter passing.

Another solution is to have a global variable (e.g. `our $conf = MyConf->new(...)` in the
main script and then access it via `$main::conf` from every part of the code. This kind of
**package global variable** can work, but it does not look good. In every place we now have
to hard-code the fully qualified name of the variable. Soon we'll find a case (for example a test script)
that needs to work differently.

A third solution would be to create a `MyConf` object in every class. Then we would probably need to
pass around the attributes of the constructor. In our example that is the name of the configuration file.
Even if we could solve that problem, this solution would mean we need to read the configuration information
in every class - and in every object of that class. This is both a run-time and a memory penalty.

A singleton class would allow us to create the instance in the main script using
`my $conf = MyConf->instance( file => 'conf.ini' );` and then in every class we can just call
`my $c = MyConf->instance;` and we know we get back the exact same object. Without touching
the configuration file, and without duplicating the configuration data in the memory.

## Loading the content of the configuration file

Getting back to the actual example, it is not enough to have the name of the configuration file
passed to the `MyConf` class. We would also like to load the content of the configuration file.

In this case we assume the configuration file is a simple
[INI file](http://en.wikipedia.org/wiki/INI_file) with sections and key-value pairs:

{% include file="examples/singleton-moo-config/config.ini" %}

We can load that using the [Config::Tiny](https://metacpan.org/pod/Config::Tiny) module
and we can do it in a `BUILD` subroutine of Moo. This means the configuration file will be loaded
the first time we call `instance` method where we are expected to pass the `file => 'config.ini'`
parameters when we create the object in the main script or setup subroutine.

Later calls to `instance` won't call the `BUILD` method any more and thus won't expect to have
a `file => ...` parameter, nor will it even look at it.

{% include file="examples/singleton-moo-config/MyConf.pm" %}

In the main script we call:

```perl
MyConf->instance( file => 'conf.ini' );
```

then anywhere in our application we can have the following call to
fetch the configuration values:

```perl
my $c = MyConf->instance();
my $a_value = $c->conf->{'section A'}{key};
```

See the main script:

{% include file="examples/singleton-moo-config/application.pl" %}

and two modules used by that script. In **ModuleA** we call
`instance` without passing any parameter:

{% include file="examples/singleton-moo-config/ModuleA.pm" %}

In **ModuleB** we pass a new `file => ...` parameter,
but it is disregarded by the code. The `BUILD` function is not
even called:

{% include file="examples/singleton-moo-config/ModuleB.pm" %}

Running that script we get the following output:

```
$ perl application.pl
BUILD called
Foo
Foo
```

