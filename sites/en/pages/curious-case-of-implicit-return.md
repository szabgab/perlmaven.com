---
title: "The curious case of implicit return"
timestamp: 2023-12-03T07:30:01
tags:
  - sub
  - return
published: true
author: szabgab
archive: true
description: "If a function in Perl does not explicitly call return then it will implicitly return the result of the last statement evaluated."
show_related: true
---


My son works at a company where they analyze source code and report on potential [data privacy violations](https://privya.ai/).
For this they need to parse source code in various programming languages. He mentioned that one day they might need to support Perl too.
I thought about the difficulties in parsing Perl and one case came to my mind was the strange implicit return from a function that Perl has.

Then I also thought that [Rust](https://www.rust-lang.org/) also has some strange ideas. BTW Do you know that I have a new web site called
[Rust Maven](https://rust.code-maven.com/) where I write about Rust? Now you know.

Anyway, back to Perl:


What do you think this function will return and what will this code print?

{% include file="examples/implicit_return.pl" %}

I know it is a very contrived example, but in the few minutes I spent on it I could not come up with a more realistic one. Send me a better example!


## Spoiler Alert

If a function in Perl does not explicitly call **return** then it will implicitly return the result of the last statement evaluated.

In the above code, if the **if** condition inside the "function" evaluates to **true** then the code inside the block will be executed
and thus the assignment to **$total** will be the last executed statement and so the value of **$total** will be returned.

On the other hand if the **if** condition inside the "function" evaluates to **false** then this will be the last statement
in the function and thus this **false** value will be returned that will happen to be the **empty string**.

In the example I added a check to show whether the returned values is [defined](/defined) or if it is [undef](/undef).
A separate check is included to show if it **equals** to the empty string or not using the [ternary operator](/the-ternary-operator-in-perl).


```
defined
NOT the empty string
5
-------------------
1
empty string

-------------------
```


