---
title: "Exercise: improve the color selector - video"
timestamp: 2015-05-24T10:01:30
tags:
  - exercise
published: true
books:
  - beginner_video
author: szabgab
---


Exercise: improve the color selector



There are several parts of this exercise:

* Currently the color selector shows menu items numbered from 0. Change it so the displayed numbers will start at 1 but that it will still work correctly.
* Currently the user can give any value on the command line. Incluing "nonsense". Check that the given value
      is indeed one of the possible values hard-coded in the script. Report an error and quit if it isn't.
* Allow the user to supply a flag called --force If this flag is present allow any value as a color. Even "nonsense".
* Read the names of the valid colors from the colors.txt file.
* Allow the user to supply a --file flag as in "--file mycolor.txt" and take the name of the file with the colors from there.

