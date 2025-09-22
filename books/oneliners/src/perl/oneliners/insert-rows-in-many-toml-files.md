# Insert rows in many TOML files


My [Rust Maven](https://rust.code-maven.com/) web site contains several books written in Markdown and I am using [mdbooks](https://mdbook.code-maven.com/) to convert them to web sites.
Each such book as a configuration file called `book.toml`.

In the configuration file one can add an entry that looks like this:

```toml
[rust]
edition = "2024"
```

By default this entry is not in the files, but at one point I wanted to add it to all the files.


In the generic case it might be a better idea to use a real TOML-handling library to make these changes, but as I know all of my `book.toml` files look the same I could safely use a regex-based solution.

I am using a Linux system, but if you are using git-bash from [git-scm](https://git-scm.com/) on Windows, you can probably do the same.

## Example book.toml file

This is how such a file looks like:

{% embed include file="src/examples/oneliners/book.toml" %}

## Insert rows

We want to insert 3 rows in every file (two rows with content and an empty row for readability) just above a line containing a specific content.

```
perl -p -i -E 'say qq{[rust]\nedition = "2024"\n} if /# Add github/' */book.toml
```

* `-E` tells perl to execute the command that follows it.
* `-p` tells perl to iterate over the lines of every file following the command and to execute the command for every line while the content of the current line is in the `$_` variable. after executing the command print the content of `$_` that might have been modified.
* `-i` meant inline editing. That is, instead of printing the content of `$_` to the screen write it back to the original file.

* `-i.bak` Would tell perl to create a backup of the file before changing it. I don't use it as my files are in version control so I can easily return to the previous version and I don't want to have lots of `.bak` files laying around.


In our case we don't modify the lines. Instead we `say qq{[rust]\nedition = "2024"\n}` will print the 3 lines when the current line (in the invisible `$_` variable) match the regex `/# Add github/`.
The slashes are the delimiters of the regex.
