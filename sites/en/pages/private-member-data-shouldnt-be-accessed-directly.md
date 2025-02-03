---
title: "Private Member Data shouldn't be accessed directly - encapsulation violation"
timestamp: 2016-06-01T09:30:01
tags:
  - Perl::Critic
  - ValuesAndExpressions::ProhibitAccessOfPrivateData
published: true
author: szabgab
archive: true
---


[Perl::Critic](/perl-critic) has many policies, but there are several additional modules that
provide even more policies. For example the [Perl-Critic-Nits](https://metacpan.org/release/Perl-Critic-Nits)
distribution provides the 
[ValuesAndExpressions::ProhibitAccessOfPrivateData](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::ProhibitAccessOfPrivateData)
policy that if violated would generate a message like this:

<pre>
Private Member Data shouldn't be accessed directly at ... 
Accessing an objects data directly breaks encapsulation and should be avoided.  Example: $object->{ some_key }.
</pre>


The policy tries to get us use

```perl
$obj->attribute;
```

instead of 

```perl
$obj->{attribute};
```

Unfortunately the this generates a lot of false positive reports.

I think the most problematic part is that Perl::Critic, being a static analyzer, cannot know
if `$h` in a code snippet like this: `$h->{name}` is going to be a blessed object
or a plain hash reference. So the policy will report violations for plain hash references as well.

Another issue might be in [classic OOP](/getting-started-with-classic-perl-oop) where
at least the accessors will need to access the attributes as elements of a hash reference.

## Example for plain hash reference

See this example:

{% include file="examples/access_hash_ref_element.pl" %}

If we run

```
perlcritic --single-policy ValuesAndExpressions::ProhibitAccessOfPrivateData access_hash_ref_element.pl 
```

we get:

<pre>
Private Member Data shouldn't be accessed directly at line 9, column 5.
Accessing an objects data directly breaks encapsulation and should be avoided.  Example: $object->{ some_key }.  (Severity: 5)
</pre>

You can avoid the policy violation report by putting a comment on the line where you know it is
ok to access the element of a hash reference:

```
say $h->{name}; ## no critic (ValuesAndExpressions::ProhibitAccessOfPrivateData)
```

## Conclusion

If the code is primarily object oriented, especially if it is based on [Moo](/moo) or
[Moose](/moose), where you don't write your own accessors, then this policy can catch
code that violates the encapsulation.

<h3>Screenshots</h3>

<img src="/img/shots/private-member-data-shouldnt-be-accessed-directly.png" alt="Accessing private member data directly" >

## Comments

Sometime is use the following to filter out those messages. At leas when I want to concentrate on the other issues perlcritic finds.

perlcritic --exclude ValuesAndExpressions::ProhibitAccessOfPrivateData my_file.pm

Thanks for the write up Gabor.


