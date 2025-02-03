---
title: "Mocking function to fake environment"
timestamp: 2015-05-12T00:30:01
tags:
  - Test::Mock::Simple
  - LWP::Simple
types:
  - screencast
published: true
books:
  - testing
author: szabgab
---


How can we test an application that makes calls to some external system, for example needs to access a website or a web-base API?
We can hit the external system for every test-run, but that will probably slow down our testing, might get us banned from the web site,
but maybe most importantly (for the tester), the test will be unreliable. In addition, it will be impossible to test cases when the
external web site returns some error condition.

Let's try a simple example in which we fetch a web page and count specific strings.


{% youtube id="kwiJttQdtQY" file="mocking-function-to-fake-environment" %}

More specifically we have a file called `MyWebAPI.pm` with the following code in it:

{% include file="examples/mocking-functions/MyWebAPI.pm" %}

This code fetches the content of British [Daily Mail](http://www.dailymail.co.uk/) that provides reliable information on the 
status of the world. Once the page is fetched we count how many times given specific strings appear and return the numbers as a reference
to a hash containing `"string" => count` pairs.

## Test live web server

We can write a test script call `webapi.t` with the following content:

{% include file="examples/mocking-functions/webapi.t" %}

We check the relative popularity of Beyonce and Miley Cyrus and as we can see Beyonce is winning 26 to 3.
If we run this script `perl webapi.t` the output will indicate that everything is ok:

```
1..1
ok 1
```

Unfortunately the actual content of the website changes and thus the numbers will change. That means our test
will soon break even though the actual "application" is still working correctly.

We can solve this by either disregarding the actual number in the result and only checking if there was a number.
This will make our test more universal, but weaker. Or, we can replace the content of the web site as returned
by the `get` function of [LWP::Simple](https://metacpan.org/pod/LWP::Simple). 

We have other issues as well. For example how can we test the behaviour of our application in the case when
the Daily Mail web site is down or returns garbage? We could build our fake version of the Daily Mail, but it
is probably simpler to fake the `get` function.

That's what we are going to do. We are going to use [Test::Mock::Simple](https://metacpan.org/pod/Test::Mock::Simple)
to fake (or mock) the `get` function.

## Mocking the get function

We load the module using `use Test::Mock::Simple;` and then 
instead of `use MyWebAPI` we load our module to be tested using
`my $mock = Test::Mock::Simple->new(module => 'MyWebAPI');`

Then we replace the `get` function imported from `LWP::Simple` with an anonymous function we provide,
which will return a simple string:

```perl
$mock->add(get => sub {
    return 'Beyonce Beyonce Miley Cyrus';
});
```

We also adjusted the values in the expected hash to reflect the string we return. This is the new version of
the test script:

{% include file="examples/mocking-functions/fake_webapi.t" %}

## More test cases

We can now add more test cases, including one where the `get` function returns the empty string. We just have to remember to update the `plan`
as well.

{% include file="examples/mocking-functions/more_webapi.t" %}

## Testing exception

As a tester I don't know if the `get` function of `LWP::Simple` would ever throw an exception, but I wonder how would the `MyWebAPI` module handle it?

I can add the following test case:

{% include file="examples/mocking-functions/exception_snippet.t" %}

As can be seen from the result, the `MyWebAPI` module does not handle such cases. Is this a bug, or is this the correct behavior?
That's beyond the scope of this article, but now at least we know how to check what happens in this extreme case.

The full example of the test script with the exception testing:

{% include file="examples/mocking-functions/exception_snippet.t" %}

And the result:

```
1..2
ok 1
Something went wrong at exception.t line 25.
# Looks like you planned 2 tests but ran 1.
# Looks like your test exited with 255 just after 1.
```

## A bug when lines are wrapped

What if the web site contains the name "Cyrus Miley" broken in two lines like in the following example?

{% include file="examples/mocking-functions/linewrap_snippet.t" %}

Indeed this test fails now:

```
1..4
ok 1
ok 2
ok 3
not ok 4
#   Failed test at ../training/pm/examples/mock/webapi.t line 61.
#     Structures begin differing at:
#          $got->{Miley Cyrus} = '1'
#     $expected->{Miley Cyrus} = '2'
# Looks like you failed 1 test of 4.
```

We can now update the module fixing this case and we can test it in a controlled environment.

The full test script that will generate the error for the line wrapping bug:

{% include file="examples/mocking-functions/linewrap.t" %}

