---
title: "Uploading files using Dancer"
timestamp: 2016-04-11T20:30:01
tags:
  - Dancer2::Core::Request::Upload
published: true
books:
  - dancer2
author: szabgab
archive: true
---


Uploading images, or files in general was always a hot issue with all the web frameworks.
[Dancer](/dancer) makes it quite easy.


## Create the HTML form for upload

Save this as <b>views/upload.tt</b>

```html
<form action="/upload" method="POST" enctype="multipart/form-data">
<input type="file" name="file">
<input type="submit" name="submit" value="Upload">
</form>
```

In the module implementing the Dancer2 application add the following two routes:

```perl
get '/upload' => sub {
    template 'upload';
};

post '/upload' => sub {
    my $data = request->upload('file');

    my $dir = path(config->{appdir}, 'uploads');
    mkdir $dir if not -e $dir;

    my $path = path($dir, $data->basename);
    if (-e $path) {
        return "'$path' already exists";
    }
    $data->link_to($path);
    return "Uploaded";
};
```

The first route will just display the upload page with the HTML form that allows
the user to select a filename then it will access the second route using `POST`
method. The `request->upload('file');` will fetch the name of the 'file'
field of the HTML form, upload the file to a temporary directory and return and
instance of
[Dancer2::Core::Request::Upload](http://metacpan.org/pod/Dancer2::Core::Request::Upload)
representing the uploaded file. This object has several methods to interact with then
information. We used the `basename` method to fetch the original name of the
file uploaded.

We used `config->{appdir}` to get the path where the whole Dancer2 application
is installed. This is the root of our application. Inside the root we create a directory
called "uploads" if it does not exists.

Then we use the `basename` of the original file to decide what will be the name
of the file on the server. (Actually this is probably not a good idea because it gives too much
power to the users of the system. It would be probably better to create a random and unique name
for the file and use some kind of database to store the connection between the original name
and the name used on the server.)

Then we use the `link_to` method to actually move the file from its temporary location
to the the place and name we want it to be.


## Full example with test

[Uploading a file using Dancer](https://code-maven.com/slides/dancer/upload-a-file)

[Testing uploadig a file using Dancer](https://code-maven.com/slides/dancer/testing-upload-a-file)

## Comments

Thanks for your posts. They've been helpful.

I've set up a handler similar to above. The problem I'm having is that the JSON serializer is throwing an error:

[api:2908] core @2020-12-21 15:28:48> Failed to deserialize content: malformed number (no digits after initial minus), at character offset 1 (before "--------------------...") at /usr/local/share/perl5/Dancer2/Serializer/JSON.pm line 47. in /usr/local/share/perl5/Dancer2/Core/Role/Serializer.pm l. 71

Any idea how to disable the serializer for this request?


I've added two links at the bottom of the article showing a full example and a test case. If you can send me a similar example that exhibits the error you see I might be able to help.



Basically, in your example, if you had:

set serializer => 'JSON';


or a config.yml entry:

serializer: JSON

the upload fails (I tried Mutable serializer and it fails, too). It seems that Dancer2 does not work well when APIs need to have different serializers (e.g., JSON for most APIs, but form-data for uploads).

I don't know if you have dealt with this issue or know a way to work around it?


I have not encountered this but I'll try to replicate it.


See issue https://github.com/PerlDancer/Dancer2/issues/1677
and PR to fix https://github.com/PerlDancer/Dancer2/pull/1678



