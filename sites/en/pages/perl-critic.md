---
title: "Perl Critic distributions and policies"
timestamp: 2015-05-21T11:58:01
tags:
  - Perl::Critic
published: true
author: szabgab
archive: true
show_related: false
---


[Perl::Critic](http://perlcritic.com/) is configurable lint-like static analyzer for Perl that can provide recommendations how to improve your code and
can even locate code snippets that are sources of common errors. It has a base library that provides the engine and a large set of
policies (things to be checked). In addition there are a number of distributions on CPAN that provide further policies.

In this article we collect **all** the CPAN distributions related to Perl::Critic and all the policies available.


## Articles

* [Getting Started with Perl::Critic (the linter for Perl)](/getting-started-with-perl-critic)
* [Avoid (unwanted) bitwise operators](/avoid-unwanted-bitwise-operators) using [Perl::Critic::Bangs](https://metacpan.org/pod/Perl::Critic::Bangs)
* [Bare Here documents are deprecated - How to find offending code?](/bare-here-documents-are-deprecated) using the core [ValuesAndExpressions::RequireQuotedHeredocTerminator](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::RequireQuotedHeredocTerminator) policy.
* [How to improve my Perl program?](/how-to-improve-my-perl-program) - just use Perl::Critic
* [Improving your Perl code - one Perl::Critic policy at a time](/perl-critic-one-policy)
* [Move packages to their own files - release Pod::Tree 1.21](/move-packages-to-their-own-files) part of the [Refactoring and CPAN co-maintainer](/becoming-a-co-maintainer) series.
* [Type checking with Moo](/type-checking-with-moo) recommends the use of the [ValuesAndExpressions::ProhibitAccessOfPrivateData](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::ProhibitAccessOfPrivateData) policy from [Perl::Critic::Nits](https://metacpan.org/pod/Perl::Critic::Nits).
* [Private Member Data shouldn't be accessed directly - encapsulation violation](/private-member-data-shouldnt-be-accessed-directly)
* [Always require explicit importing of functions](/require-explicit-importing-of-functions)

## Interviews

* [Interview with Jeffrey Thalhammer, author of Perl::Critic and Pinto](/jeffrey-thalhammer-perl-critic-and-pinto)

## Other Articles

* [An Introduction To Perl Critic](http://www.slideshare.net/joshua.mcadams/an-introduction-to-perl-critic) slides from 2007
* [Automatically review your code](http://perltraining.com.au/tips/2009-02-05.html)
* [Integrating perlcritic and vim](http://blogs.perl.org/users/ovid/2012/07/integrating-perlcritic-and-vim.html)
* [Perl::Critic at CERN Computer Security Information](https://security.web.cern.ch/security/recommendations/en/codetools/perl_critic.shtml)
* [Cleaning Up Perl](http://chimera.labs.oreilly.com/books/1234000001527/ch07.html) (Chapter 7 of [Mastering Perl](http://www.masteringperl.org/))
* [Module of the month November 2014](http://devblog.nestoria.com/post/103804565528/module-of-the-month-november-2014-perl-critic)
* [Format perlcritic output as TAP to integrate with Jenkins](http://www.uponmyshoulder.com/blog/2012/format-perlcritic-output-as-tap-to-integrate-with-jenkins/)

## Distributions

<table>
   <tr><th>Distribution</th><th>Abstract</th><th>Author</th><th>Date</th></tr>
[% FOR d IN distributions %]
   <tr><td>[[% d.name %]](https://metacpan.org/release/[% d.name %])</td>
       <td>[% d.abstract %]</td>
       <td>[[% d.author %]](https://metacpan.org/author/[% d.author %])</td>
       <td>[% d.date %]</td>
   </tr>
[% END %]
</table>


## Policies

<table>
  <tr>
    <th>Name</th>
    <th>Severity</th>
    <th>Abstract</th>
  </tr>
  [% FOR p IN policies.keys.sort %]
    <tr>
      <td>[[% p.substr(22) %]](https://metacpan.org/pod/[% p %])</td>
      <td>[% policies.$p.level %]</td>
      <td>[% policies.$p.abstract %]</td>
    </tr>
  [% END %]
</table>

## Examples

* <a href="">BuiltinFunctions::ProhibitBooleanGrep</a>

