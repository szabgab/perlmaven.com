---
title: "substr"
timestamp: 2020-05-30T09:30:01
tags:
  - PerlMaven
published: true
author: szabgab
archive: true
show_related: true
---


Given a string the `substr` function can extract some part of it based on the location and the length of the part.
Moreover `substr` can also replace the content of a string.


In the following example I have collected all the interesting cases of substr.

{% include file="examples/substr_all.pl" %}

<ol>
  <li>In the 1st example we provide the string, the beginning of the substring and the length of it.
So starting from character 4 give me 5 characters.</li>

  <li>In the second example we omit the length so we say: give me the substring starting on character 22 till the end of the original string.</li>

  <li>In the 3rd example the 3rd argument is a negative number. This indicates the number of characters from the end of the string that we don't want.
Instead of saying how many you characters you would like, we can say how many we don't want. In the comment of the 3rd example you can also
see an expression where we use the [length](/length) function to get the same result. Isn't our example neater?</li>

  <li>In the 4th example we indicate the location of the starting character with a negative number. In this we indicate where to start as
counted from the right-hand-side of the string. As if we wrote `length($str)-4`. In this example too you can see the expression in the comment.</li>

  <li>In the 5th example we indicate the starting point as a negative number (so counting from the right end) and then we indicate the length.</li>

   <li>In the 6th example we use negative number for both.</li>
</ol>

Which one you use will depend on how can you best describe the location of the substring you are interested in.

## substr to change a string

The `substr` can also be used to make changes to a script.

{% include file="examples/substr_replace.pl" %}

<ol>
  <li>The 1st example shows what happens if you provide a 4th paramater to the `substr` function.
  The function still return the same substring as it would if there were only 3 parameters, but it also **changes the original string**
  replaceing the part that was designated by the location and length by the 4th parameter.</li>

  <li>The 2nd example is rarely used, I don't think I ever used it outside of my exmples. I probably won't recommend you its use
  as it can be very confusing to people not knowing this capability of Perl.<br>
   It shows how you can use the `substr` call on the left-hand-side of an assignment. Similarly to the previous one
   this expression also replaces the designated part of the original string by what we have on the right-hand-side of the
   assignment operator. However the return value of the whole expression is the same string as we had on the right-hand-side
   and not the original part as we had in the previous expression.</li>
</ol>

You can find more example about [substr](string-functions-length-lc-uc-index-substr).


[documentation](https://metacpan.org/pod/perlfunc#substr-EXPR,OFFSET,LENGTH,REPLACEMENT)

