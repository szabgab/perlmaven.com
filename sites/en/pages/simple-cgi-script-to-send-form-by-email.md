---
title: "Simple CGI Perl script to send form by e-mail"
timestamp: 2012-08-10T12:45:56
tags:
  - CGI
published: true
books:
  - cgi
author: szabgab
---


While there are a lot of other, better ways to handle this, unfortunately I see
many people struggling with old Perl code where they cannot use the modern approaches.

In many cases they cannot even use new modules from CPAN.

Just recently someone sent me a horrific CGI script, asking me how could he capture
the fields of an HTML form and send a mail message through Perl.

At this point I won't go into refactoring that code. I just show a simple example,
how to process a web form and send the values via e-mail.


## Processing the HTML form using CGI

Here is a very simple HTML page with a form. The form has 3 fields.
a text field called **fullname**, a selector called **country**,
and a textarea called **question**.

I assume you already understand this part.

What might be new, are the parameters of the **form** itself.
The `action` is the URL to the CGI script. The `method` can be either **GET** or **POST**.
For our purposes the difference is, that in the case of GET,
the values will be shown in he address-bar of your browser while in the case of POST they will be hidden.

We use POST in this example.

```html
<html>
<head><title>Submit form</title>
</head>
<body>

<form action="/cgi/sendmail.pl" method="POST">
Full name: <input name="fullname"><br>

Country:
<select name="country">
<option></option>
<option value="usa">USA</option>
<option value="russia">Russia</option>
</select><br>

Question:
<textarea name="question"></textarea><br>

<input type="submit" value="Send mail">
</form>

</body>
</html>
```

The first Perl CGI script we see will only process the form
and echo back the results.

```perl
#!/usr/bin/perl -T
use strict;
use warnings;
use 5.008;

use Data::Dumper;
use CGI;
my $q = CGI->new;

my %data;
$data{fullname} = $q->param('fullname');
$data{country} = $q->param('country');
$data{question} = $q->param('question');

print $q->header;
if ($data{fullname} !~ /^[\s\w.-]+$/) {
    print "Name must contain only alphanumerics, spaces, dots and dashes.";
    exit;
}

print "response " . Dumper \%data;
```

Let's see the CGI part:

`use CGI;` loads the `CGI` module and we create a new CGI object called `$q`.

It has two purposes. One, is to fetch the parameters from the submitted form, the other
is to print out the HTTP header.

### Printing the header

Printing the header is done by the `print $q->header;` line. That is equivalent to
`print "Content-Type: text/html; charset=ISO-8859-1\n\n";` we saw in
[another example](/how-to-calculate-balance-of-bank-accounts-in-csv-file-using-perl).

### Fetching submitted values

The `param` method of the CGI object gets the fullname of the field as
a parameter and returns the submitted value. We call it 3 times for the 3 fields
in the form. We could have assigned the values to separate scalar variables
($fullname, $country, $question), but having them in a single hash makes it easier
to handle them later on. We could have used the `Vars` method, but
in this case I wanted to be explicit with the field names.

The following 4 lines, declare the hash and then fill it with values received via the form.

```perl
my %data;
$data{fullname} = $q->param('fullname');
$data{country} = $q->param('country');
$data{question} = $q->param('question');
```

The next step is printing the HTTP header, that has to be done for any kind of
response we would like to send to the browser.

Then we start the input validation.

I only show here one example, but in your case you'd probably want to
make sure each field received only acceptable values.

```perl
if ($data{fullname} !~ /^[\s\w.-]+$/) {
    print "Name must contain only alphanumerics, spaces, dots and dashes.";
    exit;
}
```

In this code we make sure the fullname field only contains alphanumerics, spaces, dots and dashes.
Too limit for an international company that needs to accept Unicode characters, but probably
good as a simple example. In case the validation fails we print an error message, that will
show up in the browser and exit the CGI script. We don't want the rest of the code to
execute.

The last step in this part of the code is to print the contents of the `%data` hash
to send it back to the browser. We do this only to verify we managed to capture the values
as they were submitted.

### Validation in JavaScript?

It is nice to provide this validation in some JavaScript that comes with the form.
That can improve usability, but it does **NOT** provide the necessary protection
to your code and server. You have to validate the data

## Sending the e-mail

A warning before we go on:

While this script works, I'd only recommend this as a last resort.
If you can use CPAN, there are much better ways to handle the e-mail sending part.

## Security: Taint mode

You might have noticed, the first line of the form processing code, the sh-bang line
ended with `-T`. This flag is called the `Taint mode`. It helps you make
your code more secure by restricting certain operations. For example, the e-mail sending
code executes an external program. As we cannot fully trust the environment variables,
the taint mode requires us to set the `PATH` environment variable by ourselves.
As we don't really need it for our script, we just set it to nothing: `$ENV{PATH} = '';`.

```perl
$ENV{PATH} = '';
sendmail(
    'Target <to@perlmaven.com>',
    'hello world',
    'submitted: ' . Dumper(\%data),
    'Source <from@perlmaven.com>');

sub sendmail {
    my ($tofield, $subject, $text, $fromfield) = @_;
    my $mailprog = "/usr/lib/sendmail";

    open my $ph, '|-', "$mailprog -t -oi" or die $!;
    print $ph "To: $tofield\n";
    print $ph "From: $fromfield\n";
    print $ph "Reply-To: $fromfield\n";
    print $ph "Subject: $subject\n";
    print $ph "\n";
    print $ph "$text";
    close $ph;
    return ;
}
```

In this part of the script we are using some ancient technique to send e-mail.
It only works on Unix/Linux systems that have a working sendmail or equivalent.

The actual sending is enclosed in a subroutine that gets 4 parameters.

* The address where we want to send to.
* The subject line.
* The content of the e-mail.
* The From field.

Inside the subroutine we open a process handle to the sendmail command
and hand it some parameters. The process handle ($ph in this case) behaves
just like a regular file-handle that was open for writing. You can print
to it text that will appear on the standard input of the "other program".
In this case the "other program" is the systems sendmail program.

When we call `close $ph` the e-mail is injected in the regular
mail queue of the system and is scheduled to be sent out with all the
other messages. This usually means within a few seconds the system will
try to deliver your e-mail.

## Another Warning

Do not use the above script in an environment where anyone can supply
the fields in the e-mail header: To, From, Reply-To, Subject in this case.
This can create an [open mail relay](http://en.wikipedia.org/wiki/Open_mail_relay),
that can be used to send spam.


## Comments

Thanks Gabor. You have no idea how many of your articles I have read to help me with my perl projects. Regards.

<hr>

Hi, I want to do something similar to your article. I want to display "Thanks for your submission" after submitting input by the user and simultaneously execute the cgi script. How can I do that?


