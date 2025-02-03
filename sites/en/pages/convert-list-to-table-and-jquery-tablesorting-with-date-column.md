---
title: "Convert list to table and add jQuery tablesorting with Date column"
timestamp: 2016-09-23T08:30:01
tags:
  - Tablesorter
  - jQuery
published: true
books:
  - dancer2
  - javascript
  - jquery
author: szabgab
archive: true
---


Now that in the list of items we also show the dates, it start to look like a mess.
It also provides an opportunity to see how to sort the displayed data.

We originally used an unordered list `ul` to display the items and each
item was a list item `li`, but this kind of data really hands itself to
be in a `table`. Even if HTML tables are not popular these days.

Actually I wonder if there is a `div`-based solution for this, that provides
some extra flexibility.


## Change HTML to be a table

The first step we need to do is to convert the unordered list to a table.
For that we change the Handlbars template in `clients/v2.html` to this:

```html
<script id="show-items-template" type="text/x-handlebars-template">
<table id="items-table" class="tablesorter">
    <thead>
    <tr><th>Item</th><th>Date</th><th>X</th></tr>
    </thead>
    <tbody>
{{#each data.items}}
    <tr><td>{{ text }}</td><td>{{ date }}</td><td><button class="delete" data-id="{{ _id.$oid }}">x</a></td></tr>
{{/each}}
    </tbody>
</table>
</script>
```

We don't have to change anything else in the application. We already have all the necessary
data in the template.

[commit: convert list to table ](https://github.com/szabgab/D2-Ajax/commit/c90812b18cb5d3e77cf80f93724021ab05320016)

## Add jQuery Tablesorter

The next step is to add a jQuery plugin that will make it easy to sort the table.
We are going to use the [Tablesorter](http://tablesorter.com/).

We visit the
[GitHub repository of Tablesorter](https://github.com/christianbach/tablesorter)
and download the necessary files from there. Specifically we download the
`jquery.tablesorter.min.js` file to the `public/javascripts` directory
of our project. That's where we have the `jquery.js` already.

```
cd public/javascripts/
wget https://raw.githubusercontent.com/christianbach/tablesorter/master/jquery.tablesorter.min.js
```

Then we include it <b>under</b> the inclusion of jQuery itself in the `clients/v2.html` file:

```html
<script type="text/javascript" src="../public/javascripts/jquery.tablesorter.min.js"></script>
```

We need to amend the table to let tablesorter know which one to sort. We add both an id and a class
to the `table` in the Handlebars template we just added:

```html
<table id="items-table" class="tablesorter">
```

Finally we need to run the `tablesorter`. We need to do this every time
after the table is created, so we do it in the `show_items()` function in `clients/v2.js`
We add the following line:

```javascript
$("#items-table").tablesorter();
```

If we reload the page now we are going to see something like this:

<img src="/img/dancer2_ajax_table.png" />

It looks a bit better than earlier, but nothing indicates that I can actually click on the
words in the title. But I can and clicking on "Item" really sorts the table and clicking on
it again reverses the order.
On the other hand clicking on "Date" sorts the table at most once, but then it won't
reverse the order.

So this is a partial solution.


[commit: add jquery.tablesorter to sort the table](https://github.com/szabgab/D2-Ajax/commit/ff0c56d6ac5b6bebfbd93c0c1575d2c53041c37b)

## Add jquery.tablesorter themes

The tablesorter plugin of jQuery supplies two "themes" to make the table look nicer,
even if we are not using any HTML/CSS frameworks.

In order for this to work I've downloaded the `themes` directory from
[GitHub](https://github.com/christianbach/tablesorter) and copied
it to te `public` directory of the project.

Then I included the stylesheet in the `clients/v2.html</h> file:

```html
<link rel="stylesheet" href="../public/themes/blue/style.css" type="text/css" media="print, projection, screen" />
```

[commit: add jquery.tablesorter themes](https://github.com/szabgab/D2-Ajax/commit/bb0a6cc7b380955dc2e4cefbaaae45ab9ca34037)


## jQuery Tablesorter and Date fields

Even though the documentation of Tablesorter claims they can recognize the
column types and make the sort work accordingly, for some reason the sorting
by the "Date" column did not work well.

The solution, I saw in the code of [MetaCPAN](https://metacpan.org/)
involves a bit of configuration.

First we add a class and a data entry to the `td` element
that shows the date. (This way we'll have the date both as the text
of the HTML and as an attribute. The reason for this duplication it that
we might want to add some additional markup to the HTML part and thus
we should not rely on it holding the exact date.)

```
class="date" sort="{{ date }}"
```

The second step is that we add some configuration to the `tablesorter`
function. Specifically we declare how the text should be extracted from the
various columns. We check if the current `td` has an attribute called
"sort". If it does not have we return the HTML part of the current `td`
elements.

Then, if the elements has a class called "date", we take the value of
the "sort" attribute, create a JavaScript `Date` object and return
the result of the `getTime` method of the object:

```javascript
var cfg = {
    textExtraction: function(node) {
        var $node = $(node);
        var sort = $node.attr("sort");
        if (!sort) { return $node.text(); }
        if ($node.hasClass("date")) {
            return (new Date(sort)).getTime();
        } else {
           return sort;
       }
   }
};
$("#items-table").tablesorter(cfg);
```

This already allow us to sort the table at the "Date" column.

[commit: fix the tablesorting by the Date column](https://github.com/szabgab/D2-Ajax/commit/b1f4798a0a6d466cae2aa45e83bee5fed4f1b7b4)
