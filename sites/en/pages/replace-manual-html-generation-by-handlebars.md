---
title: "Replace manual HTML generation by the use of Handlebars"
timestamp: 2016-09-09T07:20:01
tags:
  - Handlebars
published: true
books:
  - dancer2
  - javascript
  - handlebars
author: szabgab
archive: true
---


## Move JavaScript to its own file

Before we go on, let's make a small, but important adjustment. Up till now we had our
JavaScript code embedded in the HTML page. That worked, but it is much cleaner if we
put the JavaScript code in a separate file and then include it using the `src`
attribute of the `script` element:

```html
<script src="v2.js"></script>
```

And `v2.js` contains the entire JavaScript code we had within the `script` tags.


[commit: move all the JavaScript to a separate file ](https://github.com/szabgab/D2-Ajax/commit/4023d42cc4c1032f7909f26a58bf1e257c1a2364)

## Handlebars

[Handlebars](http://handlebarsjs.com/) is a templating system for JavaScript.
It can be used both in the browser and in Node.js on the server.
For an introduction see the [Handlebars Tutorial](https://code-maven.com/handlebars) I wrote.

Templates make it easier to generate and maintain HTML code. Just as on the server we use them if we create HTML pages
(e.g. in Perl you might use [Template Toolkit](http://www.template-toolkit.org/) ). This eliminates the tedious
and error-prone concatenation of html-snippets as strings.

We are going to use templates embedded into the default HTML file, because if we wanted to use
[dynamically loaded and cached templates](https://code-maven.com/handlebars-with-dynamically-loaded-template)
we would need a server for the client code as well, and for now we are loading it from the disk.

First of all, we need to include the JavaScript code that implements Handlebars. We include it
from the CDN:

```
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.3/handlebars.min.js"></script>
```

This is the template we created:

```html
<script id="show-items-template" type="text/x-handlebars-template">
{{#each data.items}}
* {{ text }} <button class="delete" data-id="{{ _id.$oid }}">x</a>
{{/each}}
</script>
```

Replacing the code that generated the HTML of the listing:

```javascript
html  = '<ul>';
for (i = 0; i < data["items"].length; i++) {
    html += '<li>' + data["items"][i]["text"] + '<button class="delete" data-id="' +  data["items"][i]["_id"]["$oid"]  + '">x</a></li>';
}
html += '</ul>';
```

by new code, that fetches the template from the HTML element and generates the HTML snippet.


```perl
var source   = document.getElementById('show-items-template').innerHTML;
var template = Handlebars.compile(source);
var html    = template({ data: data });
```

Then we can check if the page still works.

[commit: replace manual HTML generation by the use of Handlebars ](https://github.com/szabgab/D2-Ajax/commit/4378bd6eb85e0ca9dab462ff2f48d860ac863717)
