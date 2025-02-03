---
title: "Get Coveralls to notify when test-coverage shrinks"
timestamp: 2020-02-02T19:02:01
tags:
  - Coveralls
published: true
books:
  - markua
author: szabgab
archive: true
---


After pushing out the code for [Collecting errors while parsing Markua](/collecting-errors-while-parsing-markua)
out of curiosity I looked at the [Coveralls](https://coveralls.io/github/szabgab/perl5-markua-parser) report and noticed it is now only at 94%. I am slightly disappointed that I have not received any notification from Coveralls.


On a second check I noticed that when I look at the [list of commits](https://github.com/szabgab/perl5-markua-parser/commits/master) I can see a red x next to the most recent commit and if I click on it I get a popup where it tells me one check failed.

![](/img/markua-parser-coveralls-decrease-report.png)

If I click on the "Details" link next to it, I get to the [Coveralls report page](https://coveralls.io/builds/15811512)
of this specific commit.

By further digging around I found that I can enable e-mail notifications. I only have to visit the [project page](https://coveralls.io/github/szabgab/perl5-markua-parser), click on `Settings` which is currently in the top left corner. Click on `Notifications` which is again in the top left corner, type in my e-mail address in the empty box and click on `Save`.

## Testing the mail

There is even a button to send a test email message. It will send out a message exactly like the one you'd get automatically
for the most recent coverage report. The message I got looked like this:

![](/img/markua-parser-coveralls-coverage-decreased-mail.png)


## The missing test-case

Looking at the details:

[Parser.pm](https://coveralls.io/builds/15811512/source?filename=lib/Markua/Parser.pm)

I found out that the line saving the line which we cannot process is the one that was never executed during the tests.
This code:

```perl
push @errors, {
    row => $cnt,
    line => $line,
}
```

Of course. Both of the test cases are properly parsed. So I never need to save such incorrectly parsed line.
As I don't know all the details of the Markua specification (well, I hardly know any part of it.), I don't know
if there actually could be a case in which a line is not parsed properly and an error is reported because of that.

So for now I don't know what test to write to exercises this code. Maybe it is not really needed in the parser as maybe any line that is not recognized otherwise should be considered as a paragraph. At this point I don't know that. I'll have to talk to the authors
of the Markua specification for clarification.

In any case this code will probably help me catch issues with the code as we make progress.

In addition I know we need some kind of error reporting. For example if there is code to include files or embed images,
if the file or image does not exist we'd like to collect this information and return to the user.

## Conclusion

For now we'll have to live with a lower test coverage, but at least from now on we'll be notified if the coverage goes down again.

