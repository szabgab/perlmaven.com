---
title: "Checking the whois record of many domains"
timestamp: 2015-04-07T01:30:01
tags:
  - Path::Tiny
  - path
  - /m
  - /g
  - Net::Whois::Raw
published: true
author: szabgab
---


I have 35 domain names registered in various Top-level domains.
Some, like [szabgab.com](https://szabgab.com/) are in the .com TLD,
Others, like [perlide.org](http://perlide.org/) are in the .org TLD, yet others are
[perl.org.il](http://perl.org.il/) in the .il ccTLD.

Recently I decided I'd like to run my own DNS servers for all of the domains. I set up everything
and went through the web interface of the domain name registrar I use to configure each domain name
with the correct <b>Name server</b> records.

The question remained, how can I check that all the domains have been configured correctly?

For this I need to run the <b>whois</b> command for each domain and then look at the result.

Let's see how can I automate this.


<h2 id="whole">The whole script</h2>

Look at the whole script, or jump to the [explanations](#explanation)

{% include file="examples/whois.pl" %}


<h2 id="explanation">Explanation</h2>

I looked around and decided to use [Net::Whois::Raw](https://metacpan.org/pod/Net::Whois::Raw).
I did not remember it, but apparently I even maintained it a bit after the original author passed away.

The first step was to see what does the `whois` function of this module return. I flipped on
two of the configuration bits (`CHECK_FAIL` and `OMIT_MSG`), though there are a few other,
interesting ones listed in the documentation of the module. The module names

{% include file="examples/try_whois.pl" %}

This printed out the same information as the command line <b>whois</b> would do. 

For examples this command:

```
perl examples/try_whois.pl google.com
```

generated this output:

{% include file="examples/whois_google.txt" %}

Later, this script will be even more useful when I noticed that the output can be different
for the various domain names. (I have not checked the details, but I think it depends on
the TLDs: .com, .org, .net, .il etc.)

## Handle multiple domains

The next step was to go over all the domain I have.
I created a file called `domains.txt`
in which each line was a domain name:

{% include file="examples/domains.txt" %}

and changed a code a bit:

{% include file="examples/whois_domains.pl" %}

I am using [Path::Tiny](https://metacpan.org/pod/Path::Tiny), the excellent module of David Golden
to read the domains.txt file that is <b>expected to be in the same directory where the script is</b>.

Path::Tiny automatically exports the `path` function, but I like it to be explicit, and I like when I can
easily find the definition of all the functions, so I loaded it using `use Path::Tiny qw(path);`.

`path` returns an object representing the given path.
`$0` is the relative path to the script being executed. `parent` returns an object representing
the parent directory and if `$0` only contained the name of the script the `parent` will
return an object representing `.`, the current directory. (It works like the `dirname` of File::Basename.)

`child('domains.txt')` will concatenate the the value passed to it to the directory object. Just like File::Spec->catfile,
but it is clever enough to replace the single `.` with the new string.

So `path($0)->parent->child('domains.txt')` returns the object representing the `domains.txt`
file in the same directory where the script is.

The `lines` method then reads the file, and returns each value as a separate element. Just as if you'd read
from a file-handle in [list context](/scalar-and-list-context-in-perl).

The, `{ chomp => 1}`, you might have guessed, will make sure the newlines are already chomped off from
the end of each line.

I like this.

Anyway, this mean that the line
`my @domains = path($0)->parent->child('domains.txt')->lines( { chomp => 1 } );`
will find the right file and read all the lines already chomped.

If we did not want to run this script from the any directory, we could of course write:
`my @domains = path('domains.txt')->lines( { chomp => 1 } );`

Then we have code to override the list of domains by providing them on the command line.
This was especially useful during development when I wanted to be able to process specific
domains:

```perl
if (@ARGV) {
    @domains = @ARGV;
}
```

Finally, I added a look to call `whois` on every domain in the array.

## Parsing the result of whois

The next step was to parse the result of the `whois` function.
It took me a while to understand that there are 3 different formats for my domains.
* .com and .net gives me one format
* .org a different format
* .il is again different

I assume every other TLD might give different results.
So I wrapped the whole code extracting the name servers in a subroutine.
The subroutine is expected to get the result of the `whois`.

```perl
sub get_ns {
    my ($data) = @_;

    my @ns = map { uc $_ } sort $data =~ /^Name Server:\s*(\S+)\s*$/mg;

    if (not @ns) {
        @ns = map { uc $_ } sort $data =~ /^nserver:\s*(\S+)\s*$/mg;
    }

    if (not @ns) {
        my @lines = split /\n/, $data;
        my $in_ns = 0;
        for my $line (@lines) {
            if ($line =~ /^\s*Domain servers in listed order:\s*$/) {
                next;
            }
            if ($line =~ /^\s*$/) {
                $in_ns = 0;
            }
            if ($in_ns) {
                $line =~ s/^\s+|\s+$//g;
                push @ns, uc $line;
            }
        }
        @ns = sort @ns;
    }

    return @ns;
}
```

Let's see parts of the result we got from the `whois` command
and how to deal with each one:

For <b>.org</b> domains:

```
Name Server:NS.TRACERT.COM
Name Server:NS2.TRACERT.COM
Name Server:
Name Server:
```

The code extracting the strings is

```perl
map { uc $_ } sort $data =~ /^Name Server:(\S+)\s*$/mg;
```

In the regex `$data =~ /^Name Server:(\S+)\s*$/mg;` the `/m`
ensures the `^` will match at the beginning of every line. `/g`
will match as many times as possible and in list context (and `sort` creates list context)
it returns the matches. Unless, there are capturing parentheses in the expression. In that case
the regex will return whatever was captured by the parentheses. So in our case the regex will return
the names of the names servers. As we used a `\S+` it requires to have at leas one non-space
character after the text "Name Server:" eliminating the empty slots.

We sort the data - mostly just to make it easy later to compare them with the expected strings,
and use a `map` with calls to `uc` to make sure all the strings are in the same case.
Again, to make it easier for us to compare them to the expected values.


for <b>.il</b> domains this is the section from the output of `whois`:

```
nserver:      ns2.tracert.com
nserver:      ns.tracert.com
```

The code fetching the data is very similar, just the string preceding the actual names is different:

```perl
map { uc $_ } sort $data =~ /^nserver:\s*(\S+)\s*$/mg;
```

For <b>.com</b> and <b>.net</b> domains we have bit more work to do.
The hostnames don't have a prefix, but they are in a section with a title:

```
  Domain servers in listed order:
     NS.TRACERT.COM
     NS2.TRACERT.COM
```

```perl
my @lines = split /\n/, $data;
my $in_ns = 0;
for my $line (@lines) {
    if ($line =~ /^\s*Domain servers in listed order:\s*$/) {
        $in_ns = 1;
        next;
    }
    if ($line =~ /^\s*$/) {
        $in_ns = 0;
    }
    if ($in_ns) {
        $line =~ s/^\s+|\s+$//g;
        push @ns, uc $line;
    }
}
@ns = sort @ns;
```

Instead of a regex, here I decided to iterate over the lines.
I could not use the flip-flop operator of perl as the whole array ended just after the
last name server entry, so I had to use my own flag `$in_ns` to indicate when we
are inside the section of the name servers.
<ol>
  <li>The first `if` statement will notice the title of the section.</li>
  <li>The second `if` statement is there only in case the name server section is not the
  last one for some domains.</li>
  <li>The third `if` statement is collecting the name servers (after removing the leading and trailing spaces).</li>
</ol>


## Checking the Name servers

The `check_ns` subroutine is basically the only one that is specific for my needs.
It gets a list of name servers ad compares the list to the expected list.
If they don't match an error message is printed.

```perl
sub check_ns {
    my ($domain, @ns) = @_;

    if (@ns != 2 or $ns[0] ne 'NS.TRACERT.COM' or $ns[1] ne 'NS2.TRACERT.COM') {
        say "Error in $domain";
        say Dumper \@ns;
    }
}
```

## The main loop

Now that we went over all the pieces, let's look at the main loop.
We iterate over all the domain names read from the file or received from the command line.
Print out each name, call `whois`. We take the resulting text and, using `get_ns`
fetch the name servers. Please note, if the `whois` call fails for some reason it would
return `undef`. In this code, I have not handled that situation.

The we call `check_ns` with the list of name servers we received. This subroutine will print out
the error message. As we are processing the domain names one after the other in a linear fashion, this
means the error message will appear right under the domain name it belongs to.

The last 4 lines might be strange. If this was a <b>.org</b> domain we sleep 16 seconds before we continue.

According to  [PIR](http://www.pir.org/WHOIS) (the maintainer of the .org domains) there is a rate
limit of 4 queries per minute for the <b>.org</b> domains through port 43. The rate limit through the web interface
is 50 per minute, but there is a CAPTCHA to disable programmable access. So I had to make sure we don't send more
that 4 requests a minute.

This is not the best solution, but I don't think I'll run this script too often so I did not want to invest
a lot of energies in making it faster.

```perl
foreach my $domain (@domains) {
    say $domain;
    my $data = whois($domain);
    my @ns = get_ns($data);
    check_ns($domain, @ns);

    if ($domain =~ /\.org$/) {
        say 'Waiting 16 seconds to avoid rate limit';
        sleep 16;
    }
}
```

That's it, now you [can see](#whole) a straight-forward way to process whois records.
If you need to process domains from other TLDs, they might need some more adjustment.

## Parallel processing

If you run the above script you will notice there is a small delay between the processing of the domain names,
and a big gap of more than 16 seconds after every <b>.org</b> domain. Even if there is a non .org name after it.

We could eliminate the extra, and unnecessary wait times after the .org domains if we separated them from the others
and then stopped waiting after the last one.

That still would not eliminate the wait time till the `whois()` call returns.

If we had only non-org names, the requests would still go one after the other, taking a lot of time.

During these wait time the script does not do anything. It just sits there waiting for the response, or in the
case of `.org` domains it waits for time to pass.

How can we make sure that the script can do something else while it is waiting for the response of the whois servers?

In a separate article I'll solve the same problem using <b>Asynchronous</b> programming.


## Comments

Thank you a lot Gabor! Especially for the explanation

<hr>

Hello Gabor,

I am getting the error below:
#################
google.com
Error in google.com
$VAR1 = [];
#################

Any idea about the above error?

Also, I changed line 31 from "my ($data) = @_;" to "my $data = @_;" as I was getting an error of used of uninitialized variable at lines 33, 36, and 40. With that change the error disappeared.

Regards,

---

That changes is certainly incorrect. It will put the number of elements of @_ into $data.

---

I also found the bug in the code. I am not sure if this part never worked or if the output of whois changed a bit. In any case I had to add a \s* in the regex to accept optional spaces in before the name of the Names Server:
Now it seems to work.


<hr>


