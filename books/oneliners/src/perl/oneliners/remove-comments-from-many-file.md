# Remove comments from many files

In older versions of Rust when we created a new crate using `cargo new` it added a comment to the generated `Cargo.toml` file:

```
# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
```

On one hand this was a good idea as it helped people to find out more about the various keys one can use in the `Cargo.toml` file,
on the other hand it is annoying as it makes the file wide. I know, I can remove it.

And this is exactly what I deceided to do. Remove it from all the files in all the crates. Luckily, in this case, all the crates are located in the same folder:


```
perl -n -i -e 'print unless /^#/' */Cargo.toml
```

* Remember to use `-i.bak` if you don't have the files in version control. Better yet, start using version control **before** you use this one-liner.
* `-n` tells perl to execute the command on every line.
* `print unless /^#/` means: "Print the current line unless it starts with a `#` character." (Both `print` and the `//` regex match apply to the (invisible) `$_` variable that in this situation contains the current line.

