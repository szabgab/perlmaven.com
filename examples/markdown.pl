use warnings;
use strict;
use feature 'say';

#use Text::Markdown qw(markdown);
use Text::MultiMarkdown qw(markdown);

my $text = <<ORIGINAL;
# Title

Some text

## Subtitle

* Unordered
* List
* Items


1. Ordered
1. List
1. Items


| name | number |
| ---- | ------ |
| Foo  | 1234   |
| Bar  |    4   |


<style>
table td + td {
    text-align: right;
}
</style>

ORIGINAL


my $html = markdown($text);

say $html;
