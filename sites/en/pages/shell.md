---
title: "Bash - shell scripting examples"
timestamp: 2013-12-19T07:30:01
tags:
  - Bash
published: true
author: szabgab
---


While this site is primarily about Perl programming, a real Perl Maven needs to be familiar with a lot of other technologies. Not only Perl. This page is a collection of expressions in
Bash, one of the most commonly used Unix/Linux shell language.

I am not a frequent Shell-script writer, but for example I needed this for the
build script of [DWIM Perl for Linux](/dwimperl).


## sh-bang

```
#!/bin/bash -e
```

See [Writing robust shell scripts](http://www.davidpashley.com/articles/writing-robust-shell-scripts/) for an explanation about the `-e`.

## if statements

### Does this directory exist?

```
TEST_DIR=/opt/myperl
if [ -d "$TEST_DIR" ]; then
    echo $TEST_DIR already exists. Exiting!
    exit
fi
```

### Does file exist?

```
    PERL_SOURCE_ZIP_FILE=perl-5.18.1.tar.gz
    if [ ! -f "$PERL_SOURCE_ZIP_FILE" ]; then
        wget http://www.cpan.org/src/5.0/$PERL_SOURCE_ZIP_FILE
    fi
```

### Is variable empty?

```
X=abc
echo "$X"
if [ "$X" == "" ]; then
    echo yes
fi
```

or maybe even better to use the `-z` operator:

```
X=abc
echo "$X"
if [ -z "$X" ]; then
    echo yes
fi
```


### Command line arguments

```
if [ $# == 0 ]; then
    echo "empty"
else
    for x in "$@"; do
        echo "$x"
    done
fi
```

(Remember to put " around the $@ or it will incorrectly handle command-line parameters
with spaces in them, like "Perl Maven")

See other [comparison operators](http://tldp.org/LDP/abs/html/comparison-ops.html).
 
## for loop

```
for tool in gcc make cmake; do
    echo "Checking $tool"
done
```

## Conditionally install packages on CentOS

```
for tool in gcc make cmake; do
    echo "Checking $tool"
    $tool --version || {
        echo "Installing $tool"
        yes | yum install $tool || { echo "Could not install $tool"; exit 1; }
    }
done
```


## Assign values to a variable from external code

```
BUILD_HOME=$(pwd)
```

## Avoid backticks!

$() does the same is better readable and can be stacked.

```
cwd=$(pwd)

$( $(which test) -d $DIRECTORY)
```

## [[

It was also recommended to use [[ ]] instead of [ ],
but I am not yet sure why.

## Quoting

Also always double quote your variables, always (unless you have a good reason not to - which
requires you to know the reason. if you don't, quote your variables.) And using lowercase or
camel case variable names avoids accidental overriding of environment variables.

## Thanks

the article was updated based on the comments of 
Edward Macke, Dirk Deimeke, Norbert Varzariu, Adam Outler

