# Tutorial

## Command line flags and parameters

For the official documentation visit [perldoc perlrun](https://perldoc.perl.org/perlrun) or the same on [MetaCPAN](https://metacpan.org/dist/perl/view/pod/perlrun.pod)

* `-v` print the version of perl
* `--version` the same as `-v`
* `-V` print defailed information about the perl. (e.g. compilation flags)
* `-e` Execute the perl code that follows this flag.
* `-E` Just like `-e`, but enable all extra features add to Perl since the 5.10 release.
* `-n` Wrap the code provided using the `-e` or `-E` flags in a `while` loop to execute the code on every line of every file. The current line is in `$_`.
* `-p` Do the same as `-n` and also print the possibly modified content of the current line stored in `$_`.
* `-i` in-place editing (replace the processed file by the output)
* `-i.bak` in-place editing with backup


## Code snippets we use in the book

* Regex (or regexp or Regular Expression) `/bla/`  or `m/bla/` or `m{bla}` where `bla` can be any regular expression. See [perlre](https://perldoc.perl.org/perlre) or on [MetaCPAN](https://metacpan.org/dist/perl/view/pod/perlre.pod).
* Substitution with regex `s/bla/replacement/`.
* `if` - conditional
* `not` - boolean negation
* `unless` the same as `if not`
* `$.` the current line number starting from 1


## Best practices

* Use version control (e.g. git) on all of your file, including your data files.
* When doing in-place editing, if you don't have version control of the files you are editing then create a backup either before the process or during the process using `-i.bak`
* Quotes: On Linux and macOS we usually use single-quotes around the perl code of the oneliner. On MS Windows AFAIK you cannot do that and thus there the outer quotes are double-quotes. This also means that the quotes, if used in the code, will need to be used differently. Therefore in general it is better to use `q()` instead of single quotes and `qq()` for double quotes.


