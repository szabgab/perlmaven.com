---
title: "Checking a valueless checkbox with WWW::Mechanize"
timestamp: 2006-09-07T12:33:10
tags:
  - WWW::Mechanize
published: true
archive: true
---



Posted on 2006-09-07 12:33:10-07 by gab

I'm trying to check this checkbox:

```
<input type="checkbox" id="tandcs" name="tandcs">
```

(BTW: 'tandcs' stands for 'Terms And Conditions')

This seems to pose a problem because it has no defined value.
The WWW::Mechanize::tick() documentation has this to say about the value attribute:
'Dies if there is no named check box for that value.'
which is probably the reason why using 'undef' for the value doesn't work...

Using this:

```perl
$mech->tick('tandcs' => undef);
```

resulted in the following error:

No checkbox "tandcs" for value "" in form at ...

Is there a 'magic' way of getting this infernal checkbox ticked?

Posted on 2006-09-07 13:07:33-07 by b10m in response to 2952

Not sure if "ticking" a valueless checkbox makes any sense for non-Javascript purposes, but you probably need it ;-)
I had to add some Javascript generated hidden inputs once, that drove me crazy too.
After some searching, I found an interesting thread where Gisle explains a little about the undocumented push_input method of HTML::Form.

HTH

Posted on 2006-09-07 13:18:48-07 by szabgab in response to 2952

I think I am using this in the tests of CPAN::Forum but as I can see I have not pushed it to the repository yet so I cannot show the real code.
It looks more or less like this:

```perl
my $form = $w->form(....);
my $input = $form->find_input('tandcs');
$input->check;
```

Posted on 2006-09-07 16:28:53-07 by gab in response to 2955

Thank you, szaz, for the speedy and useful response.
For what its worth, in case anyone else ever has this error, here is how I was originally going to do it,
and the fix I had to use to get around it...
ORIGINAL PLAN:

```perl
$mech->field('pass1', $password);
$mech->field('pass2', $password);
$mech->tick('tandcs');
$mech->click_button( 'value' => 'Sign up!' );
```

Which would have been rather simple and elegant, had it worked. Unfortunately,
a web developer neglected to add a value for a checkbox, and WWW::Mechanize relies
upon the value being there, hence this forum post, and the following workaround...

```perl
$mech->field('pass1', $password);
$mech->field('pass2', $password);
my $form = $mech->current_form();
$form->find_input('tandcs')->check();
$mech->click_button( 'value' => 'Sign up!' );
```

(This article is based on a thread on the CPAN::Forum.)
<!-- from http://cpanforum.com/threads/2952 -->


