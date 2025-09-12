# Tutorial

## Command line flags and parameters

For the official documentation visit [perldoc perlrun](https://perldoc.perl.org/perlrun) or the same on [MetaCPAN](https://metacpan.org/dist/perl/view/pod/perlrun.pod)

* `-v` print the version of perl
* `--version` the same as `-v`
* `-V` print defailed information about the perl. (e.g. compilation flags)
* `-e` Execute the perl code that follows this pa
* `-n` Wrap the code provided using the `-e` or `-E` flags in a `while` loop to execute the code on every line of every file. The current line is in `$_`.
* `-p` Do the same as `-n` and also print the possibly modified content of the current line stored in `$_`.
* `-i` in-place editing (replace the processed file by the output)


## Code snippets we use in the book

* Regex (or regexp or Regular Expression) `/bla/`  or `m/bla/` or `m{bla}` where `bla` can be any regular expression. See [perlre](https://perldoc.perl.org/perlre) or on [MetaCPAN](https://metacpan.org/dist/perl/view/pod/perlre.pod).
* Substitution with regex `s/bla/replacement/`.
* `if` - conditional
* `not` - boolean negation
* `unless` the same as `if not`

