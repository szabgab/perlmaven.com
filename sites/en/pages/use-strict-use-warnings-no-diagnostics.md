---
title: "use strict; and warnings; but no diagnostics"
timestamp: 2016-02-14T22:50:01
tags:
  - strict
  - warnings
  - diagnostics
published: true
books:
  - cpan_co_maintainer
author: szabgab
archive: true
---


While in the mids of the previous editing sessions, I noticed the tests don't have `use warnings;`,
but on the other some of them had `use diagnostics;`.


Usually you'd be better off having `use warnings;`,
but [use diagnostics](/use-diagnostics-or-splain)
you only need if the shorter explanations did not help. Even then, you might find a more suitable
explanation among the [common errors and warnings of Perl](/common-warnings-and-error-messages)
or by using [splain](/use-diagnostics-or-splain).


Add `use warnings;` to the tests and remove `use diagnostics;` from tests.

So I went over the test, remove the `use diagnostics;` statements. Added the `use warnings;`
where it was missing.
I've also remove the `# -*- perl -*-` entries as those are just instructions for Emacs to recognize
these are Perl file. Not really necessary. I've also reorganized the module loading.

It should be like this:

```
use strict;
use warnings;

# Load generic modules (e.g. use Path::Tiny qw(path);)
# Load Test::More, set plan
# Load modules under test (Pod::Tree modules in our case)

# test code
```

Then I ran the tests again to see everything works fine and that there are no warnings.

That brought me to this
[commit](https://github.com/szabgab/Pod-Tree/commit/f3a978f891f2a9ad22fbbaa91e71c4e6fe006eb3).

## use strict; use warnings; in modules 

Then I looked around and noticed some of the modules were also missing `use warnings;`, 
and some even the `use strict;` statements. Both make our code more robust and thus are
highly recommended.

So I went over all the modules and added `use warnings;` and `use strict;` where they were missing from the modules.
Actually, some of the pm-files contained more than one `package` statements. I've added the two statements
to each one of those as I am planning to move them to separate files anyway. (I am just waiting to show you how Perl::Critic
will tell me to do so.)

Once I've finished doing this I ran the test and got the following warnings: (The tests passed, but these warnings were printed.)

```
t/00-compile.t .. 1/? "my" variable $index masks earlier declaration in same scope at blib/lib/Pod/Tree/PerlFunc.pm line 148.
"my" variable $pods masks earlier declaration in same scope at blib/lib/Pod/Tree/PerlPod.pm line 148.
t/00-compile.t .. 9/? mod2html syntax OK
podtree2html syntax OK
pods2html syntax OK
"my" variable $index masks earlier declaration in same scope at blib/lib/Pod/Tree/PerlFunc.pm line 148.
"my" variable $pods masks earlier declaration in same scope at blib/lib/Pod/Tree/PerlPod.pm line 148.
```

These are actually minor issue. (Some other code might generate a lot more warnings and maybe even compilation errors after adding
`use warnings;` and `use strict;`.

I could fix these errors in one place by removing the `my`, and in another place by renaming the variable that was
declared to something that seems to be more suitable anyway.

Then I ran the test. As everything passed and there were no warnings either I could 
[commit](https://github.com/szabgab/Pod-Tree/commit/4db46adbaf9deb2a04f128c8c7e4a7ab79cf302c) the changes.

## use warnings; in the scripts as well

Then I remembered there are some scripts as well, and added `use warnings;` to those as well.

Some people might be nervous about the many relatively small commits, but it is actually a good thing.
It makes it easier for someone to understand each commit separately.

[commit](https://github.com/szabgab/Pod-Tree/commit/68dc12a08baa2bde61d7ec1ef1225f55aff0f409)


## Remove use 5.6 and friends

Another small issue was the `use 5.005;` and `use 5.6.0;` statements sprinkled around the code.

They mean we require at least Perl version 5.005 and 5.6 respectively. This might have been important back
when the code was written and some people were still using perl 4, but today they don't add a lot of value.

In any case the code now requires at least perl version 5.6 that was release in 2000. Quite a low expectation
from the users.

Actually I am not sure about this move. Maybe I should add a minimum perl requirement to the modules and
scripts as a good practice.

[commit](https://github.com/szabgab/Pod-Tree/commit/9e4cc59c81fdfa719d9a972fde73021aa1b9a592)

