# Change a value in many TOML files


My [Rust Maven](https://rust.code-maven.com/) web site contains lots of small Rust examples. Each one is a crate (a library) and thus each one has a `Cargo.toml` file that has the `edition` field.
Some are older examples where the `edition` is 2021, others are newer with `edition` being 2024. First I wanted to see this information, which file has which editions,
and then I wanted to update every example to be in the newer edition.

I am using a Linux system, but if you are using git-bash from [git-scm](https://git-scm.com/) on Windows, you can probably do the same.

## Print the edition of every Cargo.toml file

The `find . -name Cargo.toml` command lists all the `Cargo.toml` files in the directory tree starting the current directory represented by dot. There are a lot.

I can count them if I pipe the result through the `wc` command with the `-l` flag.

```
$ find . -name Cargo.toml | wc -l
1342
```

If I pipe the results through `xargs` then I can execute a command on the resulting list of files, for exampl I can use `grep edition` to extract all the lines that contain the word `edition`:

```
$ find . -name Cargo.toml | xargs grep edition
...
```

I can take the result of that command and pipe through `wc` again to get the number of lines:

```
$ find . -name Cargo.toml | xargs grep edition | wc -l
1342
```

So the number of `edition` lines is the same as the number of file.


I can use the `grep 2024` to see filter all the edition-lines that contain the value 2024

```
$ find . -name Cargo.toml | xargs grep edition  | grep 2024
```

... and I can count those:

```
$ find . -name Cargo.toml | xargs grep edition  | grep 2024 | wc -l
534
```

I can also use the `-v` flag of grep to filter the lines that do NOT contain 2024, these are the ones I will want to edit.


```
$ find . -name Cargo.toml | xargs grep edition  | grep -v 2024
```

... and I can count those as well:

```
$ find . -name Cargo.toml | xargs grep edition  | grep -v 2024 | wc
808
```

Looks good. 808 + 534 is really 1342


I did not check if all the non-2024 editions indeed contain 2021, but it does not really matter as I would find that out run the above commands again after I make the changes.

## Change the edition

In order to make the change I use a little expression in perl and pipe through all the file.

* `-i` tells perl to replace each file with the results. If I did not have all the files in version control I'd use `-i.bak` to create a backup before making the changes, but I have all these examples in git.
* `-p` tells perl to go over each line in the files and print them.
* `-e` tells perl to execute the statement following it. As we have `-p`, perl will execute this statement on every line.
* `s/edition = "2021"/edition = "2024"/` is a rather simple regular expression substitution. Whatever is matched by the regex between the first two slashes is replace with the string between the 2nd and 3rd slash.

```
$ find . -name Cargo.toml | xargs perl -i -p -e 's/edition = "2021"/edition = "2024"/'
```

So that's it I change all the files.

## Verification

Now lets do some verification.

As all of my examples are in version control I can run `git diff` to see the changes. I did that. Thet looked good.

I can also run `git status` to see which files have changed and I can pipe it through `wc -l` to see how many files changed:


```
$ git status | wc -l
    813
```

Oh. That baffled me. How is that I only had 808 files that were not 2024, but 813 have changed?

That's actaully easy, the `git status` command prints some text above and some below the list of files and `wc` countd those lines as well.

So let's use the `--porcelain` flag. That will only print the filenames without any extra:


$ git status --porcelain | wc -l
    805

Oups. Now it say only 805 changed and we had 808 lines to change.

## Troubleshooting

I ran the counters again and they told me all the 1342 `edition` lines have now 2024. So I did not know what's going on.

The only thing I could think of is that there might be some `Cargo.toml` files that have the `edition` line more than once.

So I set out to try to count the number of edition lines in each file

Count how many time edition appears in each Cargo.toml file

For example I used this command:

```
$ find . -name Cargo.toml | xargs grep edition | grep -v 2024 | cut -d: -f1 | sort | uniq -c | head
```

and this command

```
$ find . -name Cargo.toml | xargs  perl -MData::Dumper -n -E '$c{$ARGV}++ if /edition/; END {say Dumper \%c}'
```

Nothing.


Then it occured to me:

What if I have some `Cargo.toml` files in the tree that are not under version control? Those would still be counted when I was counting
the edition lines, but they would not appear in the `git status` output as they are not under version control.

So I ran this command to see if there might be any files that are not in any of the `/src/` folders.

```
$ find . -name Cargo.toml | xargs grep edition | grep -v 2024 | grep -v '/src/'
```

Indeed it showed me 3 files. 3 html files that were generated by mdbook. There were only 3 because most of the books did not have the generated version on my disk
and the book (the [rust async](https://rust.code-maven.com/rust-async/) book only had 3 examples with older editions.

Huh. I spent quite a few minutes feeling totally lost, but I am glad I finally found the source of that difference.

With that I could commit the changes.

