---
title: "Compare the speed of Perl and Python regexes"
timestamp: 2020-07-01T09:30:01
tags:
  - Perl
  - Python
  - re
  - time
published: true
author: szabgab
archive: true
show_related: true
---


After writing the article on <a href="https://code-maven.com/compare-the-speed-of-grep-with-python-regex">comparing the speed of **grep** with **Python** regexes</a>
and arriving to the conclusiong that grep is 50-100 times faster than Python I thought, what about **Perl**?


I've create two scripts that read a large file and ran a very simple regex.
I know that for this we don't even need a regex as we can use the **index** function in Perl
or the **index** or **find** methods in Python, but this is a good exercise.

I also ran the same regex several times as that was important for the original case comparing **grep** and **Python**.

In the original article you can also find the script that generated the text file we are parsing.

## Grep with Python regexes

{% include file="examples/grep_speed.py" %}

## Grep with Perl regexes

{% include file="examples/grep_speed.pl" %}


## Comparing the speed

```
$ time python examples/grep_speed.py a.txt 20

real  0m9.610s
user  0m9.590s
sys   0m0.020s
```

```
$ time perl examples/grep_speed.pl a.txt 20

real    0m1.275s
user    0m1.253s
sys     0m0.021s
```

Perl is about 8 times faster than Python.

## More complex Python regex

This regex is slightly more complex. This is an expression that would be quite difficult to implement without regexes.

{% include file="examples/grep_speed_oxo.py" %}

## More complex Perl regex

{% include file="examples/grep_speed_oxo.pl" %}


## Comparing the speed of the more complex examples

```
$ time python examples/grep_speed_oxo.py a.txt 20

real   0m24.472s
user   0m24.401s
sys    0m0.036s
```


```
$ time perl examples/grep_speed.pl a.txt 20

real  0m1.239s
user  0m1.227s
sys   0m0.012s
```

Here Perl is about 20 times faster than Python.

## Version information

```
$ python -V
Python 3.8.2
```

```
$ perl -v
This is perl 5, version 30, subversion 1 (v5.30.1) built for x86_64-linux
```


## Conclusion

The regex engine in **Perl** is much faster than the regex engine of **Python**.

The are both slower than **grep** as measured when I [compares Python with grep](https://code-maven.com/compare-the-speed-of-grep-with-python-regex).

