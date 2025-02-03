---
title: "Refactoring Dancer 2 app, using before hook"
timestamp: 2016-04-26T11:50:01
tags:
  - before
  - hook
published: true
books:
  - dancer2
author: szabgab
archive: true
---


By the end of the [reverse echo](/dancer2-ajax-reverse-echo) article we
had a Dancer module with 5 routes. Many of them repeating the setting of the headers:

```
header 'Content-Type' => 'application/json';
header 'Access-Control-Allow-Origin' => '*';
```

We can easily eliminate the code duplication and make our code more readable and nicer by employing a
`before hook`


Dancer provides a number of `hooks` that will be called during the life of a request. Specifically the
`before hooks` will be called before the route is called. We can use it to have common operations.
In our case we set the json header for every api call:

```perl
header 'Content-Type' => 'application/json';
```

and we set the Access-Control-Allow-Origin for the v2 API calls.
(We still keep around the v1 API and we still want it to work only from pages served by the same server.)

So we can add the following code:

```perl
hook before => sub {
    if (request->path =~ m{^/api/}) {
        header 'Content-Type' => 'application/json';
    }
    if (request->path =~ m{^/api/v2/}) {
        header 'Access-Control-Allow-Origin' => '*';
    }
};
```

and we can remove all the other calls to `header`

After that we run

```
make test
```

to check if the tests still pass.

They do.

[commit](https://github.com/szabgab/D2-Ajax/commit/d9601de8cd03265966a71f522960186f2a5e841f)

See also the new version of the [lib/D2/Ajax.pm](https://github.com/szabgab/D2-Ajax/blob/master/lib/D2/Ajax.pm) file.

## Original code

```perl
package D2::Ajax;
use Dancer2;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/api/v1/greeting' => sub {
    header 'Content-Type' => 'application/json';
    return to_json { text => 'Hello World' };
};

get '/v1' => sub {
    return template 'v1';
};

get '/api/v2/greeting' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    header 'Content-Type' => 'application/json';
    return to_json { text => 'Hello World' };
};

get '/api/v2/reverse' => sub {
    header 'Access-Control-Allow-Origin' => '*';
    header 'Content-Type' => 'application/json';
    my $text = param('str');
    my $rev = reverse $text;
    return to_json { text => $rev };
};


true;
```

## After refactoring

```perl
package D2::Ajax;
use Dancer2;

our $VERSION = '0.1';

hook before => sub {
    if (request->path =~ m{^/api/}) {
        header 'Content-Type' => 'application/json';
    }
    if (request->path =~ m{^/api/v2/}) {
        header 'Access-Control-Allow-Origin' => '*';
    }
};

get '/' => sub {
    template 'index';
};

get '/api/v1/greeting' => sub {
    return to_json { text => 'Hello World' };
};

get '/v1' => sub {
    return template 'v1';
};

get '/api/v2/greeting' => sub {
    return to_json { text => 'Hello World' };
};

get '/api/v2/reverse' => sub {
    my $text = param('str');
    my $rev = reverse $text;
    return to_json { text => $rev };
};


true;
```
