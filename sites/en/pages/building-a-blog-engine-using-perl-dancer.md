---
title: "Building a blog engine using Perl Dancer"
timestamp: 2014-05-14T20:45:56
tags:
  - Dancer
types:
  - screencast
books:
  - dancer
published: true
author: szabgab
---


In this [screencast](https://www.youtube.com/watch?v=NGX5pgKWVoc) we build a
simple blog engine using [Perl Dancer](/dancer).

If you are on MS Windows start by downloading [Padre on Strawberry Perl](http://padre.perlide.org/)
that already has everything we need. On other system you'll have to install
[Dancer](https://metacpan.org/pod/Dancer), [File::Slurp](https://metacpan.org/pod/File::Slurp)
and the [Template::Toolkit](https://metacpan.org/pod/Template). (Please note, the last one is actually identified
as Template, by the CPAN clients.)


{% youtube id="NGX5pgKWVoc" file="dwimmer_mpeg4_1000.mp4" %}

The application we build is going to be called [Dwimmer](http://dwimmer.org/). We need to
use the command line to build the skeleton of our application by typing in

```
dancer -a Dwimmer
```

This will create a directory called Dwimmer and all the files necessary to build a Dancer application.

The `bin/app.pl` file is just a simple launcher for a web server on port 3000

The real code is in `lib/Dwimmer.pm`

The templates are in the `view/`  directory.

This is the full code:

```perl
package Dwimmer;
use Dancer ':syntax';

use File::Slurp qw(read_file write_file);

our $VERSION = '0.01';

get '/' => sub {
    my $filename = config->{dwimmer}{json};
    my $json = -e $filename ? read_file $filename : '{}';
    my $data = from_json $json;
    template 'index', {data => $data};
};


get '/page' => sub {
    template 'page';
};

post '/page' =>  sub {
    my $filename = config->{dwimmer}{json};
    my $json = -e $filename ? read_file $filename : '{}';
    my $data = from_json $json;
    my $now   = time;
    $data->{$now} = {
        title => params->{title},
        text  => params->{text},
    };

    write_file $filename, to_json($data);
    redirect '/';
};

true;
```

The module [File::Slurp](https://metacpan.org/pod/File::Slurp) provides two functions for reading and writing files
in a simple way.

Dancer is route based so you for each page out there you need to define a route. 
You can even differentiate between the HTTP METHOD types such as <b>GET</b> and <b>POST</b>
though they are written in lower case in Dancer.

We changed the config.yml file in the root of the application. Commented out the 

```
# template: "simple"
```

and enabled

```
template: "template_toolkit"
engines:
  template_toolkit:
    encoding:  'utf8'
```

Later we also added the following

```
dwimmer:
  json: c:\work\dwimmer.json
```

to set where the json "database" is located. (Our home made NoSQL database.)

We edited the view/index.tt file replacing all of its content with a simple HTML
linking to the <b>page</b>.

```
Hi
[add a new entry](/page)
```

clicking on that link would generate a 404-error so we also created a route to
serve the request:

```perl
get '/page' => sub {
    template 'page';
};
```

The page template is simple form.

```
  <form method="POST">
  <input name="title" size="80"/><br />
  <textarea name="text" rows="20" cols="80">
  </textarea><br />
  <input type="submit" value="Post" />
  </form>
```

Note we set the submission method to be POST! Hence when you submit this form
you get a 404 error. We have to implement a separate route to handle this post request:

```perl
post '/page' =>  sub {
    my $filename = config->{dwimmer}{json};
    my $json = -e $filename ? read_file $filename : '{}';
    my $data = from_json $json;
    my $now   = time;
    $data->{$now} = {
        title => params->{title},
        text  => params->{text},
    };

    write_file $filename, to_json($data);
    redirect '/';
};
```

In this code the <b>config</b> method returns the all the configuration options
where we already saved the name of the json file.
-e $filename checks if the file exists. If it does, we read it in to the $json
variable if not then we assign to it a json string representing an empty hash.

```perl
my $json = -e $filename ? read_file $filename : '{}';
```

<b>from_json</b> a built-in Dancer function turning a json string into a Perl data structure.

We then add a new entry to our "database" with the key being the timestamp and having
a hash containing the title and text as received from the user.

```perl
write_file $filename, to_json($data);
```

This will write back the whole data structure after turning it into a json file.

The last line redirects the user to the main page.

This code will save the new blog submission to the json file but won't display yet.

For that we changed the main route copying the data reading code to it.
It then passes the data to the template call.

```perl
get '/' => sub {
    my $filename = config->{dwimmer}{json};
    my $json = -e $filename ? read_file $filename : '{}';
    my $data = from_json $json;
    template 'index', {data => $data};
};
```

The index.tt template itself had to be changed as well to include this:

```
  <% FOR e IN data.keys.sort %>
    <hr />
    <h2><% data.$e.title %></h2>
    <% data.$e.text %>
  <% END %>
```

Which will display all the results from the data hash.

That's it.

Well, sort of.

