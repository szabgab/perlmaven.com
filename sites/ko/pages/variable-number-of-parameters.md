---
title: "Perl 서브루틴의 가변 길이 파라메터"
timestamp: 2013-07-04T01:00:00
tags:
  - sub
  - @_
published: true
original: variable-number-of-parameters
books:
  - beginner
author: szabgab
translator: gypark
---


Perl에서 서브루틴의 파라메터를 정의하는 기능이 내장되어 있지는 않지만, 그 덕에 임의의 갯수의 파라메터를
함수로 전달하는 것이 쉬워집니다.

그래서 `sum` 같은 함수를 작성하는 게 아주 수월해집니다.


```perl
#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

say sum(3, 7, 11, 21);

my @values = (1, 2, 3);
say sum(@values);

sub sum {
    my $sum = 0;
    foreach my $v (@_) {
        $sum += $v;
    }
    return $sum;
}
```

이 예제에서, 처음에는 네 개의 숫자를 `sum` 서브루틴에 전달했고, 다음에는 세 개의 숫자가
들어 있는 배열 하나를 전달했습니다.

이 서브루틴은 인자들을 기본 `@_` 변수에 받게 됩니다.
이번 경우에는 함수가 매우 단순하기 때문에 받은 값들을 프라이빗 변수에 복사하지 않았습니다.
그저 `foreach` 루프를 사용하여 값들을 순회하며 각 값을 `$sum` 변수에 더해나갑니다.

`return`은 `$sum`의 값을 호출한 쪽에게 전달할 것입니다.

## 프라이빗 배열

`@_` 변수의 내용을 서브루틴 안에서 선언된 프라이빗 변수에 복사할 수도 있었습니다, 이번
예제에서 그럴 필요는 없었지만요.

```perl
sub sum {
   my @values = @_;
   ...
```


## 두 개 이상의 배열을 전달하기

불행하게도, 다음 예제처럼 두 개의 배열을 함수에 전달하려고 한다면, 문제에 빠지게 됩니다.

```perl
my @good = ('Yoda', 'Luke', 'Leia')
my @evil = ('Darth Vader', 'Emperor')
print award(@good, @evil), "\n";
```

이 서브루틴은 `@_` 배열 안에 모든 값들 ('Yoda', 'Luke', 'Leia', 'Darth Vader', 'Emperor')이
들어 있는 것을 보게 되고, 어느 값들이 첫번째 배열에서 왔고 어느 값들이 두번째 배열에서 왔는지를
알 수 있는 쉬운 방법은 없습니다. 이 문제를 해결하기 위해서는 레퍼런스에 대해 알아야 합니다.

[Perl Maven Pro](https://perlmaven.com/pro) 구독자들은
[함수에 두 개의 배열을 전달하는 법](https://perlmaven.com/passing-two-arrays-to-a-function)에
대한 기사를 볼 수 있습니다.

