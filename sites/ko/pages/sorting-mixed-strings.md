---
title: "혼합된 문자열의 정렬"
timestamp: 2014-04-13T10:00:00
tags:
  - sort
  - $a
  - $b
  - cmp
  - <=>
  - substr
published: true
original: sorting-mixed-strings
books:
  - beginner
author: szabgab
translator: gypark
---


문자열로만 또는 숫자로만 구성된 [배열을 정렬하는 것](https://perlmaven.com/sorting-arrays-in-perl)은
`sort` 함수를 사용하여 쉽게 할 수 있습니다.
하지만 만일 문자열을 정렬하고자 하는데 그 문자열의 일부분을 구성하는 숫자들을 기준으로
정렬하고 싶다면 어떻게 해야 할까요?

예를 들어서, `foo_11 bar_2 moo_3`와 같은 배열이 있다고 할 때, 이 안의 숫자들을 기준으로
정렬하려면 어떻게 해야 할까요?


단순히 `sort`를 호출하면 이 값들을 문자열 정렬을 할 것입니다. 우리는 숫자값 부분을
추출할 수 있어야 합니다.

```perl
use strict;
use warnings;
use 5.010;

my @x = qw(foo_11 bar_2 moo_3);
say join " ", sort @x;
```

```
bar_2 foo_11 moo_3
```

## substr을 사용하여 숫자 추출하기

문자열 내에 있는 숫자들을 사용하여 문자열을 비교하기 위해서는 이 숫자들을 추출해내야 합니다.
위의 예제를 보면 각 문자열들은 <b>문자 4개 다음에 숫자</b>가 오는 형태로 구성되었다고 가정할 수 있습니다.
이 경우 우리는 [substr](/string-functions-length-lc-uc-index-substr)을 사용하여
이 숫자 부분을 추출할 수 있습니다:

```perl
use strict;
use warnings;
use 5.010;

my @x = qw(foo_11 bar_2 moo_3);

my @y = sort { substr($a, 4) <=> substr($b, 4)  } @x;

say join " ", @y;
```

정확한 결과가 나옵니다:

```
bar_2 moo_3 foo_11
```

만일 숫자 앞뒤에 임의의 문자들이 올 수 있다면 어떻게 해야 할까요?

## 정규표현식을 사용하여 숫자 추출하기

예를 들어 문자열이 다음과 같다면:

```perl
my @x = qw(foo_11 bar_2_bar text_3);
```

앞서 보았던 방법을 쓰면, `Argument "2_bar" isn't numeric in numeric comparison (<=>)`와 같은 경고를
여러번 보게 될 것입니다.

정규표현식을 사용하여 문자열의 일부를 추출할 수 있습니다. 다만 이를 위해서는 리스트 문맥을 만들어야 합니다.
따라서 아래 표현식에서는 `($number)`를 괄호 안에 넣었습니다.

```perl
use strict;
use warnings;
use 5.010;

my $str = 'bar_2_bar';
my ($number) = $str =~ /(\d+)/;
say $number;
```

이 코드는 `2`를 출력합니다.

불행하게도 `<=>` 연산자는 좌변과 우변 모두 스칼라 문맥을 생성합니다.

그러면 어떻게 스칼라 문맥에서 값을 추출해낼 수 있을까요? 이것은 
[배열 슬라이스](https://perlmaven.com/perl-split)를 즉석으로 만들어서
해결할 수 있습니다.

```perl
my ($number) = $str =~ /(\d+)/;

my $number = ($str =~ /(\d+)/)[0];
```

이것을 적용하면 다음과 같습니다:

```perl
use strict;
use warnings;
use 5.010;

my @x = qw(foo_11 bar_2_bar text_3);
say join " ", sort @x;

my @y = sort { ($a =~ /(\d+)/)[0] <=> ($b =~ /(\d+)/)[0] } @x;

say join " ", @y;
```

결과는 다음과 같습니다:

```
bar_2_bar text_3 foo_11
```

## 숫자가 없는 경우

[Octavian Rasnita](http://www.linkedin.com/in/octavianrasnita) 씨가 지적한 대로,
만일 문자열 중에 숫자가 없는 문자열이 있다면, 
`Use of uninitialized value in numeric comparison` 경고가 잔뜩 나올 것입니다.
문자열 내에 숫자가 없는 경우는 0을 사용하기로 합시다:

```perl
my @y = sort { (($a =~ /(\d+)/)[0] || 0) <=> (($b =~ /(\d+)/)[0] || 0) } @x;
```


## 속도

그분은 또한 정규식 엔진은 "느리고" [Schwartzian transform](https://perlmaven.com/how-to-sort-faster-in-perl)을
사용하여 속도를 향상시킬 수 있다고 지적해주었습니다.
그에 따르면 배열에 원소가 5개 이상 있다면, Schwartzian 변환이 더 빠릅니다.
원소가 20개라면 단순한 정렬보다 두 배 빠를 것입니다.

그분의 해답은 다음과 같이 생겼습니다:

```perl
my @y = map { $_->[1] }
        sort { $a->[0] <=> $b->[0] }
        map { [ ($_ =~ /(\d+)/)[0] || 0, $_ ] } @x;
```

일반적인 경우 저는 이런 "너무 이른 최적화(premature optimization)"에 반대하는 편입니다.
저는 어떤 최적화를 적용하기 전에 일단 응용프로그램을 완성하고 나서, 그 코드를
[Devel::NYTProf](https://metacpan.org/pod/Devel::NYTProf) 모듈을 사용하여
평가하는 것을 권장합니다. 이 모듈은 특정한 코드가 프로그램의 전체 성능에 큰 영향을 주는지
여부를 보여줍니다. 만일 큰 영향이 없다면, 저는 느리지만 가독성 있는 쪽을 남겨두려 합니다.

그러나 이번 경우는 원래의 버전(특히나 디폴트로 0을 설정하기로 한 버전)이 Schwartzian 변환을
쓴 버전에 비해 특별히 가독성이 높은 것 같지도 않습니다. 왜냐하면 비교를 위해 값을 얻어내는
식 자체가 복잡하기 때문이죠. 원래의 버전에서는 그 식이 두 번 나옵니다.
Schwartzian 변환을 쓸 경우 한 번만 나옵니다.

어쩌면 아래처럼, 복잡한 식을 서브루틴에 옮기면 가독성이 더 좋을 수 있습니다:

```perl
my @y = sort { getnum($a) <=> getnum($b) } @x;

sub getnum {
   my $v = shift;
   return( ($v =~ /(\d+)/)[0] || 0);
}
```


## Hiding the sort in a sub

Octavian씨가 제게 보내준 또 하나의 해결책은 별도의 서브루틴을 써서 정렬의 상세 내용을 감추는 것입니다:

```perl
my @y = sort by_number @x;

sub by_number {
    my ( $anum ) = $a =~ /(\d+)/;
    my ( $bnum ) = $b =~ /(\d+)/;
    ( $anum || 0 ) <=> ( $bnum || 0 );
}
```

이 방법의 장점은 동일한 정렬 방법을 여러 곳에서 사용할 수 있다는 것입니다.
구현을 한번만 하고, 이 서브루틴의 이름을 통해 정렬방식을 잘 보여준다면,
대부분의 사람들은 구현 내용을 보지도 않을 것입니다. 서브루틴들의 보편적인
특성이지요.
