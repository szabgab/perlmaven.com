---
title: "Parsing NaN in JSON - JavaScript and Perl"
timestamp: 2014-06-03T19:11:01
tags:
  - JSON
  - NaN
published: true
author: szabgab
---


The other day I was at a client where I had to read in large JSON files.
Besides the fact that it took half an hour to load each JSON file, sometime the whole script blew up with 
and error message like this one:

`malformed JSON string, neither tag, array, object, number, string or atom, at character offset 14 (before "NaN,\n  "other" : "n...")`

I did not understand why Perl cannot parse a JSON file created by Python?


The problem boiled down to having a `NaN` (not a number) value in the JSON string:

```perl
use strict;
use warnings;
use Data::Dumper;
use JSON;

my $str = <<'END';
{
  "field" : NaN,
  "other" : "name"
}
END

print Dumper JSON::decode_json $str;
```

Running this code will generate the exception
`malformed JSON string, neither tag, array, object, number, string or atom, at character offset 14 (before "NaN,\n  "other" : "n...")`

After reading a bit about the subject it turns out that `NaN` is not part of the [JSON specification](http://json.org/)
and it was a mistake to include it in the JSON file. Similarly `Infinite` and `-Infinite`


## NaN in JSON in JavaScript

The JSON parser of JavaScript cannot handle `NaN` either

This JavaScript code:

```
console.log( JSON.parse('{ "x" : NaN  }') );
```

will gives the follow error:

```
Uncaught SyntaxError: Unexpected token N 
```


In the other direction, if a JavaScript data structure has `NaN` in it as in the following example,
it will be encoded (stringified) to be `null`

```
console.log(JSON.stringify({ "x" : NaN }, undefined, 2));
```

```
{
  "x": null
} 
```

## null in JSON handled by perl

If the `NaN` value is correctly encoded in the JSON as `null` then the JSON parsers in perl
can also handle it, and it is converted into [undef](/undef-and-defined-in-perl)

```perl
use strict;
use warnings;
use Data::Dumper;
use JSON;

my $str = <<'END';
{
  "field" : null,
  "other" : "name"
}
END

print Dumper JSON::decode_json $str;
```

Results in the following output:

```
$VAR1 = {
          'other' => 'name',
          'field' => undef
        };
```

## Conclusion

The JSON parsers of Perl are correct in <b>not</b> parsing `NaN`.
The file created by the Python script was invalid.

## Comments

No - they are incorrect - I have a string this is JSON serialized, but it needs to be turned into actual JSON. NaN is a valid value. JavaScript is not a real programming language and I hope someone replaces it for the web soon.

