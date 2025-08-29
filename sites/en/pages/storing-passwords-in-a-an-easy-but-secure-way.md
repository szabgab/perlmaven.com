---
title: "Storing Password in an easy and secure way using Perl"
timestamp: 2013-11-09T13:30:01
tags:
  - Crypt::PBKDF2
  - Digest::SHA
  - Digest::MD5
  - crypt
  - salt
published: true
author: szabgab
---


In a system where users need to authenticate with a password, we need some way to
validate if the user has typed in the correct password. For this we need to keep
a copy of the password on our system. Keeping it in clear-text form would be a security
issue as anyone who might get a copy of this storage would know what is the password
for each user. Even if the production machine is well protected, someone might break in
to a testing machine, or might find a copy of the database backup.

So we need to encrypt the clear-text password and save the encrypted version.


Before going on with the explanation, let's see the recommended solution:

```perl
use Crypt::PBKDF2;

my $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA2',
    hash_args => {
        sha_size => 512,
    },
    iterations => 10000,
    salt_len => 10,
);

my $password = "s3kr1t_password";
my $hash = $pbkdf2->generate($password);
```



## Encrypt the password

```perl
use Crypt::PBKDF2;

my $pbkdf2 = Crypt::PBKDF2->new;
my $password = "s3kr1t_password";

my $hash = $pbkdf2->generate($password);
```

The `$password` is received from the user
and after computing it, we store the `$hash` in the database,
along with the user identifier (e.g. username).

The hash will look like this string:
`{X-PBKDF2}HMACSHA1:AAAD6A:SEvDOw==:1rmVDmR6OgwPEYV5CiwUeYnd+OE=`

## Check the password

```perl
use Crypt::PBKDF2;

my $password = "s3kr1t_password";
my $hash = '{X-PBKDF2}HMACSHA1:AAAD6A:SEvDOw==:1rmVDmR6OgwPEYV5CiwUeYnd+OE=';

my $pbkdf2 = Crypt::PBKDF2->new;
if ($pbkdf2->validate($hash, $password)) {
    print "valid password\n";
    ...
}
```

The user will supply the `$password` and the user identifier (probably a username).
The `$hash` will be fetched from the database using the username.
`validate` will compute the hash again from the `$password` and
compare it with the `$hash`. You might ask why do we need a separate method
for this and you'll find the explanation below.

## Encrypt the password with improvements

Later in the article this will be explained, but let's have an improved
version of the code here, that provides a lot stronger encryption than the
default:

```perl
use Crypt::PBKDF2;

my $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA2',
    hash_args => {
        sha_size => 512,
    },
    salt_len => 10,
);

my $password = "s3kr1t_password";
my $hash = $pbkdf2->generate($password);
```



## Theory and Explanation

The encryption employed should be some kind of an algorithm that makes it easy to
convert the clear-text password to an encoded version, but makes it impossible,
or at least unreasonably difficult to convert the encoded version back to clear-text,
or to find another string that converts to the same encrypted version.

In the above sentence, the **impossible** refers to the assumption that
mathematicians so far could not find a fault in the algorithm.

The **unreasonably difficult** means that a potential attacker
would need many years and many very powerful computer to compute all encrypted
version of all the possible clear-text strings. So unless the attackers are lucky
they won't find the real password for some time.

Having such protection for a few centuries sounds like reasonable protection.

## Hashing or encryption

While the word `encryption` is often used in this context and it is
also used in this article, an `encryption` usually means that there is
also a reverse method called `decryption`. In our case there is no
decryption so the proper name is either `one-way-encryption` or `hashing`

## Hashing algorithms

Perl provides the `crypt` function that can be used as such hashing function,
but the algorithm behind it is relatively simple and there are newer better such
hashing functions.

[Digest::MD5](https://metacpan.org/pod/Digest::SHA) implements the
well know MD5 algorithm.

[Digest::SHA](https://metacpan.org/pod/Digest::SHA) implements
the SHA algorithm with various complexity. The higher the number the more secure the
algorithm.

There are other algorithms as well, but instead of changing the algorithm there
are other techniques as well that help improving the security.
[Key stretching](http://en.wikipedia.org/wiki/Key_stretching) (or key strengthening)
usually refers to two techniques:

One of them is to make the clear-text password longer by adding some random characters.
This is usually referred to as [salting](http://en.wikipedia.org/wiki/Salt_(cryptography)).

The other technique is to call the encryption function repeatedly.

Both strategies make it more computational intensive to generate hashed strings from possible passwords
reducing the possibility of a
[brute force attack](http://en.wikipedia.org/wiki/Brute_force_attack) or the creation
of a [rainbow table](http://en.wikipedia.org/wiki/Rainbow_table).

One can implement these techniques with either of the above hashing algorithms (the built-in
`crypt` function even accepts a parameter called salt, but using
<a  href="https://metacpan.org/pod/Crypt::PBKDF2">Crypt::PBKDF2</a> make it unnecessary.

By default the `generate` method of the module will use a random 4-bytes long salt
and will encode the salt and the password 1000 times.
By default it will use the HMAC-SHA1 algorithm implemented in
[Digest::SHA](https://metacpan.org/pod/Digest::SHA).

That means, using Crypt::PBKDF2 is a lot less vulnerable than plain SHA1.

While the above defaults work well, you can set your own values in the constructor
as shown in the synopsis of the module:

```perl
use Crypt::PBKDF2;

my $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA1', # this is the default
    iterations => 1000,       # so is this
    output_len => 20,         # and this
    salt_len => 4,            # and this.
);
```


The module even limits the length of the output to make it easy to insert the data
in a database with max-width fields.


## Improve security

Actually, would be more secure to use SHA256 instead of SHA1 as a default there.
Luckily Crypt::PBKDF2 already comes with back-end that can use other than SHA1. The
[Crypt::PBKDF2::Hash::HMACSHA2](https://metacpan.org/pod/Crypt::PBKDF2::Hash::HMACSHA2)
hash class can handle SHA 224, 256, 384, and 512. It defaults to 256.
All you need to do is tell the constructor to use `HMACSHA2` as the hash_class:

```perl
use Crypt::PBKDF2;

my $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA2',
);
```

If you want to go all the way to SHA 512 you need to pass a parameter to the constructor
of HMACSHA2 using the hash_args key:


```perl
use Crypt::PBKDF2;

my $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA2',
    hash_args => {
        sha_size => 512,
    },
);
```

Finally you might want to add more salt:

```perl
use Crypt::PBKDF2;

my $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA2',
    hash_args => {
        sha_size => 512,
    },
    iterations => 10000,
    salt_len => 10,
);
```


## The basic implementation

Let's see how, more or less, the `generate` method of Crypt::PBKDF2 is implemented:

Simple hashing would look like this:

```perl
sub generate {
    my ($self, $password) = @_;

    return hashing($password);
}
```

Salted hashing first, and incorrect attempt:

```perl
sub generate {
    my ($self, $password) = @_;

    my $salt = $self->generate_salt(); # returns a 4 character long string
    return hashing( "$salt$password" );
}
```

but it has a big problem. How can we validate the password? If we call
generate again on the same password it will generate a different random salt
and the result will be different.
So the code looks more like this:

```perl
sub generate {
    my ($self, $password) = @_;

    my $salt = $self->generate_salt(); # returns a 4 character long string
    return $salt . hashing( "$salt$password" );
}
```

Then we know that the first 4 characters of the string returned by generate
is the salt so we can write a `validate` method that will look like this:

```perl
sub validate {
    my ($self, $password, $hash) = @_;

    my $salt = substr($hash, 0, 4);
    my $generated = $self->generate($password, $salt);
    return $hash eq $generated;
}
```

For this to work we will of course need to alter the `generate`
method a bit, to accept an optional salt:

```perl
sub generate {
    my ($self, $password, $salt) = @_;

    $salt //= $self->generate_salt(); # returns a 4 character long string
    return $salt . hashing( "$salt$password" );
}
```

Now we already have a pair of working generate and validate methods.


<h3>Salted hashing with iterations would work like this:</h3>

```perl
sub generate {
    my ($self, $password, $salt, $iteration) = @_;

    $salt //= $self->generate_salt();
    $iterations //= $self->iterations;
    for (1 .. $iterations) {
        $password = hashing( "$salt$password" );
    }
    return $salt . ':' .  $iterations . ':' . $password;
}
```

In this case the `generate` method needs to return both the salt and the number
of iterations, but as the number of iterations can be any number, it is better to
use a character to separate these field than to assume a fixed length.
This also allows us to use longer strings for salt.

The `validate` function in this case looks like this:

```perl
sub validate {
    my ($self, $password, $hash) = @_;

    my ($salt, $iterations) = split /:/, $hash;
    my $generated = $self->generate($password, $salt, $iterations);
    return $hash eq $generated;
}
```

Finally we might want to be able to change the actual hashing algorithm
and then we have to ensure that the string returned from `generate`
will contain this information so that the `validate` method will
know what to use during validation.

The name of the method can be attached to the beginning of the string returned
by `generate`.

As a really, really last step, we might want to ensure that we can later change
the format of the string returned by the `generate` method so we would like
to add a field that identifies this method.

In case of <a  href="https://metacpan.org/pod/Crypt::PBKDF2">Crypt::PBKDF2</a> the format looks
like this:

`{X-PBKDF2}HMACSHA1:AAAD6A:SEvDOw==:1rmVDmR6OgwPEYV5CiwUeYnd+OE=`

which is called the ldap-like format.

In the curly braces we have the identifier of the string format. (X-PBKDF2)

Immediately after that is the identifier of the hashing algorithm. (HMACSHA1)

The next field, separated by a `:`, is the number of iterations encoded
with MIME::Base64.

Then the salt and finally the actual hash.

## Longer is better

While we have been educated to use short passwords with all kinds of strange characters,
actually having long passwords is more important than having cryptic passwords.

So in general it is a good idea to encourage the users to use long passwords.

## Denial of Service attack

One thing to note. If the application allows arbitrary length passwords
it can create a denial of service attack by overloading the server.
This problem was recently
[reported and fixed](https://www.djangoproject.com/weblog/2013/sep/15/security/) in
[Django](https://djangoproject.com/).

So while users should be encouraged to use long password, the accepted password length
should be also limited.


## Some reference

For extra flexibility it might be worth to look at the
[password management in Django](https://docs.djangoproject.com/en/1.5/topics/auth/passwords/).

In addition, Sebastian Willing has a good explanation of why
[slower is better](http://www.pal-blog.de/entwicklung/perl/when-slower-is-better-secure-your-passwords.html).


## Update

You might also want to read [this post](https://hynek.me/articles/storing-passwords/), take a look at [Crypt::Argon2](https://metacpan.org/pod/Crypt::Argon2). See also [Argon2](https://en.wikipedia.org/wiki/Argon2). I have not checked it myself.

## Comments

but if you get the string from a server, can't one just run it through their own perl encrypt program, reverse engineer it and get the password?

no, they can't

<hr>

Any idea what to do with:
Can't locate object method "get_or_add_package_symbol" via package "Package::Stash" at /usr/lib64/perl5/vendor_perl/Class/MOP/Package.pm line 128.

I have all the perl mods installed and up to date.


I don't see that method being called in the latest version https://metacpan.org/release/ETHER/Moose-2.2009/source/lib/Class/MOP/Package.pm I think you need to print the version numbers of the loaded modules using Dumper \%INC , the version of perl and the code snippet you are trying to use. Post all that in Stack overflow.


