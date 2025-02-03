---
title: "Sudoku in Perl"
timestamp: 2018-10-27T22:30:01
tags:
  - Games::Sudoku::Component
published: true
author: szabgab
archive: true
---


What if you ran out of the Sudoku boards in the paper and would like to create your own? No problem
[Kenichi Ishigaki (aka charsbar)](http://d.hatena.ne.jp/charsbar/) has created a module called
[Games::Sudoku::Component](https://metacpan.org/pod/Games::Sudoku::Component) that will generate
a Sudoku board for you.

Not only that, it will also solve it for you.


Here is a run-down on how it works and then we'll have some ideas on how to use it.

## Using Games::Sudoku::Component, the main module

This seems like the easiest way to create  Sudoku and to solve it.

{% include file="examples/sudoku_component.pl" %}

We load the [Games::Sudoku::Component](https://metacpan.org/pod/Games::Sudoku::Component) module and call the `new`
method to create an instance. We can pass the size of the sides of the square. The generate object already has an empty Sudoku.
The `as_string` method will generate this output:

```
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0
```

Then we call the `generate` method and pass the number of blank spot we'd like to have. This will generate a random Sudoku.
Every time we run this script we get a different set of numbers and a different starting point.

```
0 8 0 2 1 0 0 7 0
2 0 0 0 0 3 0 0 0
0 9 0 6 0 0 0 3 8
0 3 1 0 0 0 0 4 0
0 4 0 0 0 6 0 0 0
5 7 8 3 0 1 0 2 9
7 1 0 0 0 0 0 5 0
0 2 0 1 3 0 0 0 0
4 6 0 0 0 0 0 8 0
```

Then we can call the `solve` method that will fill in the empty spaces:

```
3 8 4 2 1 9 5 7 6
2 5 6 8 7 3 4 9 1
1 9 7 6 5 4 2 3 8
6 3 1 9 2 7 8 4 5
9 4 2 5 8 6 3 1 7
5 7 8 3 4 1 6 2 9
7 1 3 4 6 8 9 5 2
8 2 9 1 3 5 7 6 4
4 6 5 7 9 2 1 8 3
```

Actually, after I looked at the source of the module I found out that the `generate` method first calls the `solve` method that creates a full board and then there is a `make_blank` method of the Controller that will remove the appropriate number of values from the square so we have enough blanks to solve.

One more important method I found is the `load` method. It can get the name of a file that contains a Sudoku board that looks like the one `as_string` printed. So we could save a board and then restore it later using the `load` method.

As I could see from the source I cannot do much more with this object, unless I am willing to poke in the internals of the class.

If I need more flexibility I seem to need to use the Controller directly.

## Using Games::Sudoku::Component::Controller

In the previous example we used the main module that in turn uses the 
[Games::Sudoku::Component::Controller](https://metacpan.org/pod/Games::Sudoku::Component::Controller)
to do the heavier lifting. In this example we are going to use the Controller directly.

{% include file="examples/sudoku_controller.pl" %}

After loading the Controller module we can create an instance using the `new` method. This will create an empty board of the given size. You can put them any number that is the square of a whole number. 9 is the default.

Then we call `solve` that will fill the whole board with numbers.

Finally we call the `make_blank` method and tell it how many numbers to remove.

In order to see the values in specific cells we can use 

`$c->table->cell(1, 2)->value;` construct passing the row and column numbers that start from 1.


In order to set the value of one of the cells we can use the same method and pass it a number.
There is certain level of validation when setting a value. It cannot be below 0 or above the max number, but in can be 1.5
and it can be a number that contradicts the board.

At least that's what I observed. Looking at the source code again, it seems there is some validation going on so I am not sure if this is just a bug or if I am misunderstanding something.


