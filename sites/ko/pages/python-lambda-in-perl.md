---
title: "Perl에서 Python의 람다처럼 익명 함수를 만드는 법"
timestamp: 2014-01-09T14:00:00
tags:
  - lambda
  - sub
published: true
original: python-lambda-in-perl
author: szabgab
translator: gypark
---


Python에는 `lambda`라는 도구가 있어서 익명 함수를 즉석으로 생성할 수 있게 해줍니다.


다음 예제에서 `make_incrementor` 함수는 새로운 익명 함수를 반환합니다.

## Python에서 lambda 사용하기 

```python
def make_incrementor(n):
    return lambda x: x + n

f3 = make_incrementor(3)
f7 = make_incrementor(7)

print(f3(2))    #  5
print(f7(3))    # 10
print(f3(4))    #  7
print(f7(10))   # 17
```

## Perl에서 익명 함수 사용하기

```perl
use strict;
use warnings;
use 5.010;

sub make_incrementor {
    my ($n) = @_;
    return sub {
        my ($x) = @_;
        return $x + $n; 
    }
}

my $f3 = make_incrementor(3);
my $f7 = make_incrementor(7);

say $f3->(2);    #  5
say $f7->(3);    # 10
say $f3->(4);    #  7
say $f7->(10);   # 17
```

이 코드에서, `make_incrementor`에 대한 호출이 종료된 후에도 변수 `$n`는 살아 있게 됩니다.
왜냐하면 `make_incrementor`에서 반환한 익명 함수에서 그 변수를 참조하고 있기 때문입니다.

`$f3`와 `$f7`는 `make_incrementor`에 의해 생성되고 반환된 익명 함수를 가리키는
레퍼런스입니다. 이 변수들의 내용을 `say $f3`를 사용해서 출력해 보면 `CODE(0x7fe9738032b8)`
같은 내용을 얻을 것이고, 이를 통해 정말로 실행 코드에 대한 레퍼런스임을 확인할 수 있습니다.

이 변수를 디레퍼런스하려면 다음과 같이 씁니다: `$f3->(2)`

## 지역 변수를 추가로 쓰지 않는 Perl 코드

```perl
sub make_incrementor {
    my ($n) = @_;
    return sub { $n + shift }
}
```

앞서 보았던 `make_incrementor` 구현 대신 이 코드를 사용할 수도 있습니다.
