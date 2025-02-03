---
title: "Dancer, the light-weight Perl web framework"
timestamp: 2013-10-24T18:13:11
tags:
  - Dancer
published: true
books:
  - dancer
author: szabgab
show_related: false
---


The beginning of a series of articles about
[Perl Dancer](http://perldancer.org/), the light-weight web framework of Perl.


* [Modern Web with Perl](/modern-web-with-perl), a quick overview (screencast)
* [Getting Started with Perl Dancer](/getting-started-with-perl-dancer) - Creating an Echo application (screencast)
* [Building a blog engine using Perl Dancer (screencast)](/building-a-blog-engine-using-perl-dancer)
* [Getting started with Perl Dancer 2 on Digital Ocean](/getting-started-with-perl-dancer-on-digital-ocean)

## Dancer 1
* [Hello World with Dancer](/dancer-hello-world)
* [Test Dancer Hello World](/dancer-test-hello-world)
* [Dancer 1 echo using GET and testing GET](/dancer-echo-get)
* [Dancer 1 echo using POST and testing POST](/dancer-echo-post)
* [Dancer 1 skeleton](/dancer-skeleton)
* [Dancer 1 session](/dancer-session)

## Dancer 2
* [Migrating (the Perl Maven site) from Dancer 1 to Dancer2](/migrating-from-dancer-to-dancer2)
* [Hello World with Dancer2](/hello-world-with-dancer2) (both single file and skeleton based version)
* [Password protecting web pages in Dancer 2](/password-protecting-web-pages-in-dancer2)
* [Counter with Dancer session](/counter-with-dancer-sessions)
* [Uploading files using Dancer](/uploading-files-with-dancer2)
* [A counter using Perl Dancer and an in-memory SQLite database](/counter-with-dancer-using-in-memory-sqlite-database)
* [A counter using Perl Dancer and Redis, both in a Docker container](/counter-dancer2-redis-docker)

## Dancer 2 video course

Availbale as a stand-alone purchase via [Leanpub](https://leanpub.com/c/dancer).

* [Install on Windows](/dancer2-install)
* [Install on Linux and Mac OSX](/dancer2-install-perl-on-linux)
* [Hello World](/dancer2-hello-world)
* [Testing Hello World](/dancer2-hello-world-testing)
* [Hello World with Visual Studio Code](/dancer2-hello-world-with-vscode)
* [Plackup reload on Windows and Linux](/dancer2-plackup-reload)
* [Show current time](/dancer2-current-time)
* [Test 404 and 500 response codes](/dancer2-testing-404-and-500-responses)
* [Process GET and POST requests](/dancer2-process-get-and-post-requests)
* [Exercise 1: Calculator, Counter](/dancer2-exercise-1)
* [Solution 1: Calculator](/dancer2-solution-1-calculator)
* [Solution 1: Calculator - fixing](/dancer2-solution-1-calculator-fixing)
* [Solution 1: Counter](/dancer2-solution-1-counter)
* [Show errors during development](/dancer2-show-errors-during-development)
* [Logging](/dancer2-logging)
* [Route parameters and sending 404 manually](/dancer2-route-parameters)
* [More Route parameters and redirect](/dancer2-more-route-parameters)
* [Exercise 2: Multi-Counter, Random redirect](/dancer2-exercise-2)
* [Solution 2: Route-based Multi-Counter](/dancer2-solution-2-route-based-multicounter)
* [Solution 2: Random Redirect](/dancer2-solution-2-random-redirect)
* [Configuration](/dancer2-configuration)
* [Sessions](/dancer2-sessions)
* [Return JSON](/dancer2-return-json)
* [Before and after Hooks](/dancer2-hooks)
* [Exercise 3: Simple Single-user TODO list API](/dancer2-exercise-3)
* [Solution 3: Simple Single-user TODO list API](/dancer2-solution-3-simple-todo-api)
* [Upload files](/dancer2-upload-file)
* [Template::Tiny](/dancer2-template-tiny)
* [Template::Toolkit](/dancer2-template-toolkit)
* [Sekeleton](/dancer2-skeleton)

## Dancer 2 API and AJAX
* [Ajax and Dancer](/ajax-and-dancer2) - Simple GET request to the same server returning JSON with "hello world" and displaying it.
* [Stand-alone Ajax client and the Access-Control-Allow-Origin issue](/stand-alone-ajax-client) - Simple cross-site GET request. Set Access-Control-Allow-Origin in the server.
* [Reverse Echo with Ajax and Dancer 2](/dancer2-ajax-reverse-echo) - An HTML form with single input field, sending the value in a GET request to the server displaying the result: the input reversed.
* [Refactoring Dancer 2 app, using before hook](/refactoring-dancer2-using-before-hook)
* [Silencing the noisy Dancer tests](/silencing-the-dancer-tests)
* [Add and retrieve items - MongoDB, Dancer and Testing!](/add-item-to-mongodb-database) - The backend part setting up MongoDB, an implementing the back-end part of inserting an item and retrieving a list of items
* [Add and retrieve elements - jQuery + Ajax](/add-and-retreive-items-jquery-ajax) - jQuery retrieve list and show list (building HTML using string concatenation). New HTML form, jQuery POST the text of the item
* [Deleting item using Ajax request with DELETE and OPTIONS](/deleting-item-using-ajax-with-delete-and-options) - Change the list displayed and include a delete button with each item. When clicked send a DELETE request. Add Access-Control-Allow-Methods header and let the server respond to OPTIONS request to fix the issues.
* [Replace manual HTML generation by the use of Handlebars](/replace-manual-html-generation-by-handlebars)
* [Add a date stamp to the items in the database and to the HTML](/add-date-to-items-in-mongodb) - Add a date stamp to the items in the database. Show the list including the date.
* [Convert list to table and add jQuery tablesorting with Date column](/convert-list-to-table-and-jquery-tablesorting-with-date-column) - Let the user sort the data in the browser based on text or based on date.
* [Keep data in client and fetch only changes](/keep-data-in-client-and-fetch-only-changes) - Stop fetching the full list on every action, so when the user adds a new element to the list,
 let the server only indicate that it stored the new value, but insert the value in the list kept in the client.  Same for delete.

<!--
  Implement the idea of updating the list in the client only once, and letting it handle the data itself.
Then also implement a notification solution so if the data is changed on the server, the client will be notified.

-->

[Single Page Application with Perl Dancer and AngularJS](/dancer2-angularjs-single-page-application)

## See Also
* [PSGI](/psgi) - Dancer is a PSGI based web framework. Learning about the lower layer might be useful.

## Supporters

These are the people who supported the crowdfunding campaign of the [Dancer SPA eBook](https://leanpub.com/dancer-spa/). Without them, the book would not be possible.  Thank you for your trust and support!

[The Perl Shop, LLC](http://theperlshop.com),

[Brad Currens](https://www.linkedin.com/in/bradcurrens/),
[Mikko Koivunalho](https://www.linkedin.com/in/mikkokoivunalho/),
[Thomas Oettli](https://www.linkedin.com/in/thomas-oettli-0600aa57/),

[Akshay Mohit](https://www.linkedin.com/in/akshay-mohit-356b1119/),
Cyril Grall,

David Mills,
[Keedi Kim](https://www.linkedin.com/in/keedi-kim-21684757/),
[Mark Tagawa](https://www.linkedin.com/in/marktagawa/),
[Peter Mottram](https://www.linkedin.com/in/petermottram/),
[Rudy Robles](https://www.linkedin.com/in/rudyrobles24/),
Sawyer X,
[Sören Laird Sörries](https://www.linkedin.com/in/soerenmlairdsoerries/),
[Thomas Lokajczyk](https://www.linkedin.com/in/thomas-lokajczyk-723b727/),

[Emmanuel Seyman](https://www.linkedin.com/in/emmanuelseyman/),
Warren Young,

[Dave Cross](https://www.linkedin.com/in/davorg/),
[David Lee Crites](https://www.linkedin.com/in/davidleecritesauthor/), 
[Gerhard Gonter](https://www.linkedin.com/in/gerhard-gonter-23a9248/),
[Ian Gates](https://www.linkedin.com/in/ian-gates-5b49211/),
John Steventon,
Miller Hall,
[Uri Bruck](https://www.linkedin.com/in/uribruck/),
Vincent Boerner,

[Alfonso Pinto Sampedro](https://www.linkedin.com/in/alfonso-pinto-sampedro-a096b657/),
[Brandon Wood](https://www.linkedin.com/in/woody2143/),
[John Pendreich](https://www.linkedin.com/in/jpendreich/),
Joseph Kline,
Joseph Bakker,
Judith Hollenberger,
Keith Miller,
Larry Sherwood,
[Lorne Schachter](https://www.linkedin.com/in/lorneschachter/),
[Michael F Maguire](https://www.linkedin.com/in/michael-maguire-808400b/),
[Norman Gaywood](https://www.linkedin.com/in/norman-gaywood-b7684610/),
[R Geoffrey Avery](https://www.linkedin.com/in/rgeoffrey/),
[Ray Lauff](https://www.linkedin.com/in/ray-lauff-a2655/),
[Tudor Constantin](https://www.linkedin.com/in/tudorconstantin/),

[A. Sinan Unur](https://www.linkedin.com/in/sinanunur/),
[Christopher Burger](https://www.linkedin.com/in/chris-burger-743776/),
[Edward Freyfogle](https://www.linkedin.com/in/edfreyfogle/),
Francois Houyengah,
[Jean A Plamondon](https://www.linkedin.com/in/jean-a-plamondon-26580814/),
[Jeremiah Foster](https://www.linkedin.com/in/jeremiahfoster/),
Marcos Laborde,
[Mike Schienle](https://www.linkedin.com/in/mike-schienle-6104563/),
[Richard Noble](https://www.linkedin.com/in/richard-noble-13272515/),
Thomas M,
[Ynon Perek](https://www.linkedin.com/in/ynon-perek-6055266/),

[Adam McMillen](https://www.linkedin.com/in/adam-mcmillen-8a382572/),
[Assad Arnaud](https://www.linkedin.com/in/arnaudassad/),
[Chris Jack](https://www.linkedin.com/in/chrisjack/),
Chris Bayly,
[Gunnar Hansson](https://www.linkedin.com/in/ghansson/),
[Jason Crome](https://www.linkedin.com/in/cromedome/),
Jens Bernt Tage Budde,
Raymond Shewan,
[Salvador Fandiño](https://www.linkedin.com/in/salvador-fandi%C3%B1o-6146b41/),

[Robert Lawson](https://www.linkedin.com/in/robert-lawson-44178b7/),
Tomek Wardega,
Ulrich Reining,

[Borkur Gudjonsson](https://www.linkedin.com/in/borkurg/),
Brian Gaboury,
Brian F. Yulga,
Ernst Bayer,
[Issac Goldstand](https://www.linkedin.com/in/margol/),
[Jakub Narębski](https://www.linkedin.com/in/jnareb/),
Jens Löschke,
[Kaare Rasmussen](https://www.linkedin.com/in/kaare-rasmussen-76865a1/),
Markus Monderkamp,
[Matija Grabnar](https://www.linkedin.com/in/matija-grabnar-a209b/),
[Meir Guttman](https://www.linkedin.com/in/meir-guttman-17b790161/),
[Neil Bowers](https://www.linkedin.com/in/neil-bowers-567a40/),
Nigel,
Sachi Purcal,
Shimon Cohen,
Stewart Leicester,
Vegard Vesterheim,
[Wayne Hall](https://www.linkedin.com/in/whallorg/),

[Horst Ritter](https://www.linkedin.com/in/horst-ritter-55697587/),

Alexandre Mestiashvili,
[Andrew Solomon](https://www.linkedin.com/in/asolomon/),
[Aranya Sen](https://www.linkedin.com/in/aranyasen/),
[Austin Kenny](https://www.linkedin.com/in/austin-kenny-87515311/),
Bob Lanteigne,
Brian Donorfio,
[Chris Davies](https://www.linkedin.com/in/thechristopherdavies/),
[Collin Seaton](https://www.linkedin.com/in/collin-seaton-781b8714/),
[Csaba Gaspar](https://www.linkedin.com/in/csaba-gaspar-15b99186/),
[Dale Gamble](https://www.linkedin.com/in/dale-gamble-8a90715/),
[David Precious](https://www.linkedin.com/in/bigpresh/),
Eduardo Santiago,
[Efthimios Mavrogeorgiadis](https://www.linkedin.com/in/emavro/),
<a href="https://www.linkedin.com/in/eugenevillar/">Eugene Alvin Villar</a<>,
[Gert van Oss](https://www.linkedin.com/in/gert-van-oss-4228b13/),
[Ian Macdonald](https://www.linkedin.com/in/ian-macdonald-632a296/),
[Dave Jacoby](https://www.linkedin.com/in/jacobydavid/),
Jochen Schnuerle,
John Keener,
[Jon Lucenius](https://www.linkedin.com/in/headhacker/),
Jorg Bielak,
[Jose De Arce](https://www.linkedin.com/in/josedearce/),
Juan Demerutis,
[Laurent Rosenfeld](https://www.linkedin.com/in/laurentrosenfeld/),
[Keren Bartal](https://www.linkedin.com/in/keren-bartal-3253a21/),
[Kristen Kjoberg](https://www.linkedin.com/in/kristen-kjoberg-050a402/),
[Magnus Enger](https://www.linkedin.com/in/magnusenger/),
Manfred Laner,
[Manuel Trujillo](https://www.linkedin.com/in/toomanysecrets/),
[Matthew Persico](https://www.linkedin.com/in/matthewpersico/),
[Maxim Motylkov](https://www.linkedin.com/in/motylkov/),
Mikael Asp Somkane,
Mike Weisenborn,
Mike Whtaker,
[Mohammad S Anwar](https://www.linkedin.com/in/mohammadanwar/),
Nikos Vaggalis,
[Olaf Alders](https://www.linkedin.com/in/olafalders/),
[Paul Johnson](https://www.linkedin.com/in/pauljcjohnson/),
Paul M. Lambert,
Peter Ulvskov,
[Peter Corrigan](https://www.linkedin.com/in/perlcgi/),
[Péter Gál](https://www.linkedin.com/in/peter-gal/),
[Phil Wells](https://www.linkedin.com/in/phil-wells-69a4026/),
Robert Threet,
[Rói á Torkilsheyggi](https://www.linkedin.com/in/r%C3%B3i-%C3%A1-torkilsheyggi-487aa81/),
[Simon Green](https://www.linkedin.com/in/simongreennet/),
[Stephen Hall](https://www.linkedin.com/in/stephen-hall-b5b3826/),
Sven Kirmess,
[Tim Teasdale](https://www.linkedin.com/in/timteasdale/),
Tim Van den Langenbergh,
Tony Edwardson,
[Tushar Dave](https://www.linkedin.com/in/tushardavebioinformatics/),
[Valerio Paolini](https://www.linkedin.com/in/valeriopaolini/),
Wolfgang Biker,
Zak Zebrowski,

Daniel Maldonado,
Ralph Schuler,

Jiří Pavlovský

## Comments

I am using dancer framework for croping face from image, for crop i am using python opencv. when i was calling opencv from dancer error came like "RuntimeError: module compiled against API version 9 but this version of numpy is 4". i don't know how to fix this case.can you help me? Thanks in advance.

<hr>

how to handle double button in a form for POST method.


