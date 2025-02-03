---
title: "substr outside of string at ..."
timestamp: 2019-03-25T08:30:01
tags:
  - substr
  - warnings
published: true
author: szabgab
archive: true
---


I don't encounter this warning often, but when I do it indicates a bug in my code.

I saw this at two my clients recently, one we turned [use warinings](/always-use-warnings) on. Frankly I don't understand why even in 2018 some companies insist on not using `warnings`.


This is the script:

{% include file="examples/hello_perl_world.pl" %}


It does not do anything special. It just runs [substr](/string-functions-length-lc-uc-index-substr) on a string. In the first 2 cases the 2nd parameter, that indicates the beginning of the substring is inside the original string. This does not generate a warning even if the full substring is expected to be longer than what we have the string.


In the 3rd case however, the 2nd parameter is bigger than the full length of the string, which means that already the beginning of the substring is outside the original string.

That generates a warning.

```
$ perl hello_perl_world.pl

'Perl'
'World'
substr outside of string at hello_perl_world.pl line 13.
```

See all the other [common warnings and errors in Perl](/common-warnings-and-error-messages).
