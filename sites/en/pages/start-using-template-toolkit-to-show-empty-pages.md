---
title: "Start using Template Toolkit to show the empty pages"
timestamp: 2015-04-28T14:30:01
tags:
  - Template::Toolkit
  - PSGI
types:
  - screencast
published: true
books:
  - search_cpan_org
author: szabgab
---


Now that we have created the [skeleton PSGI application](/create-skeleton-psgi-application) we should further improve it.
It is clear that we should **not** have HTML embedded in the Perl code. We need to use some kind of templating system and move
all the HTML there. There are tons of templating systems on CPAN, but [Template-Toolkit](http://template-toolkit.org/) is
probably the most well known and most commonly used. It also has plenty of plugins. We are going to us that.


{% youtube id="6hNWd48HxqU" file="start-using-template-toolkit-to-show-empty-pages" %}

In `lib/MetaCPAN/SCO.pm` we replace the

```
return [ '200', [ 'Content-Type' => 'text/plain' ], ['Hello'], ];
```

with

```
return template('index');
```

and then implement the `template` function.
The value passed to the `template()` function is the name of the template file we need to
use to serve this page.

The templates themselves will be located in the `tt/` subdirectory in the root of the project. They all have `.tt`
extension. Thus the template of the main page of the site `/` will called `tt/index.tt`

We create the `tt/` directory and the `tt/index.tt` file with some dummy content:

```
MetaCPAN::SCO
```

This is the content of the page and it is plain text. To make the page really HTML we need to add some HTML-tags before and after.
Every web page in a web project have some common attributes. If nothing else then the html tag at the beginning of each file and the
closing html tag at the end. Usually though a lot more parts are common. In order to avoid repeating the same HTML code
we can put these common elements in separate files and then include them in the main file. Even better Template::Toolkit understand
that the beginning and the ending of each page is similar and allows us to configure templates to be processed before and
after the main template of each page. Hence we also create a two more files:

`tt/incl/header.tt` contains

```
<html>
<head>
  <title>The CPAN Search Site - search.cpan.org</title>
</head>
<body>
```

`tt/incl/footer.tt` contains

```
</body>
</html>
```

Not much, but we have to start somewhere and eliminating the repetition of these parts is already a win. Especially
when later we'll want to make some changes. These file were also created in a subdirectory of `tt/` called
`tt/incl/` to have some separation among template that are for pages and templates that are to be included.
It is not required, but it makes it easier to understand what is what.

Now let's see the `template()` function that ties these files together:

We'll have to supply the path to the directory of the templates. At this point I did not have better idea so
I looked at the content of the `__FILE` pseudo variable. It holds the name of the current file. (`lib/MetaCPAN/SCO.pm`
in our case.) `abs_path` imported from [Cwd](https://metacpan.org/pod/Cwd) will convert the relative path of
`lib/MetaCPAN/SCO.pm` to a full path. Something like this: `/home/gabor/work/MetaCPAN-SCO/lib/MetaCPAN/SCO.pm`.
Then the `dirname` function of [File::Basename](https://metacpan.org/pod/File::Basename) will return the path withut the last part.
Calling it 3 times will return <hl/home/gabor/work/MetaCPAN-SCO`, the root of our project. (Not being able to pass 3 as a second parameter
of `dirname` always bothered me.)

The constructor of [Template](https://metacpan.org/pod/Template), the main module of Template::Toolkit, accepts a number
of parameters. `INCLUDE_PATH` is the path to the directory where it is going to look for templates. We just pass to it
a full path to the `tt/` directory of our project.

We set `INTERPOLATE`  to 0, to avoid expanding strings that look like perl scalars (e.g. `$var`).

`POST_CHOMP` will clean up whitespaces.

`EVAL_PERL` means TT will evaluate Perl code-blocks. I think I usually turn this off. I think I left it on by mistake.

A template is HTML with some embedded special tags defined by Template::Toolkit. By default these tags start with `[%`
and end with `%]`. The `START_TAG` and `END_TAG` directives allow us to change them. The tags I selected
will make the whole code look more like plain HTML.

Setting the `PRE_PROCESS` and `POST_PROCESS` variables tell Template Toolkit to load the respective template
before and after the main template which is going to be passed to the `process` method. Here we pass the path to the
header.tt and footer.tt files relative to the directory provided in the `INCLUDE_PATH` parameter.

`$tt` will hold the Template object.

We call the `process` method of this object with 3 parameters. The first one is the name of the template file.
It is the value our `template()` function received with the `.tt` extension. The second parameter is a hash
reference where later we'll pass the values to be inserted into the template. The 3rd parameter is a reference to an empty
scalar variable. The result of the processing will be placed in this variable. As I did not have better idea, I called `die`
in case the process method returned failure. In a web context this might not be a good idea. We might be better off sending back
some lame excuse, or a very cryptic error message `Internal error 307` to the user and log the failure.
For now, during development it will work well.

Once we have the generated HTML in the `$out` we can return the 3-element array expected by PSGI.
The content-Type now really should be `text/html` and the 3rd value is an array reference with a single element
which is the HTMl we have just generated.

```perl
sub template {
    my ( $file ) = @_;

    my $root = dirname(dirname(dirname( abs_path(__FILE__) )));

    my $tt = Template->new(
        INCLUDE_PATH => "$root/tt",
        INTERPOLATE  => 0,
        POST_CHOMP   => 1,
        EVAL_PERL    => 1,
        START_TAG    => '<%',
        END_TAG      => '%>',
        PRE_PROCESS  => 'incl/header.tt',
        POST_PROCESS => 'incl/footer.tt',
    );
    my $out;
    $tt->process( "$file.tt", {}, \$out )
        || die $tt->error();
    return [ '200', [ 'Content-Type' => 'text/html' ], [$out], ];
}
```

In order this to work we also had to load a couple of modules:

```perl
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use Plack::Request;
use Template;
```

These module were also added as prerequisites to Makefile.PL.


Once we have all this we can launch the application again using `plackup` and
visit [http://localhost:5000/](http://localhost:5000/) to check the result.
Don't forget to "view-source" in your browser to see that we really got the HTML.

```
$ git add .
$ git commit -m "Start using Template toolkit to show the empty pages"
```

[commit](https://github.com/szabgab/MetaCPAN-SCO/commit/0ce8f29b47e3f6fbebecbe904fd148bed7898904)

