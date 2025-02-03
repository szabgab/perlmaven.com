---
title: "Dancer 1 Skeleton"
timestamp: 2019-04-25T08:40:01
tags:
  - Dancer
published: true
books:
  - dancer
author: szabgab
archive: true
---


You can build your Dancer application piece-by-piece, you can also kick-start your application by creating a skeleton.




```
dancer -a My::App
```

This will create a directory called `My-App` with the following structure:

```
My-App/
├── bin
│   └── app.pl
├── config.yml
├── environments
│   ├── development.yml
│   └── production.yml
├── lib
│   └── My
│       └── App.pm
├── Makefile.PL
├── MANIFEST
├── MANIFEST.SKIP
├── public
│   ├── 404.html
│   ├── 500.html
│   ├── css
│   │   ├── error.css
│   │   └── style.css
│   ├── dispatch.cgi
│   ├── dispatch.fcgi
│   ├── images
│   └── javascripts
│       └── jquery.min.js -> /usr/share/javascript/jquery/jquery.min.js
├── t
│   ├── 001_base.t
│   └── 002_index_route.t
└── views
    ├── index.tt
    └── layouts
        └── main.tt
```

You can now cd into the `My-App` directory and run:

```
plackup bin/app.pl
```

Then visit  http://localhost:5000/ to see your application.



