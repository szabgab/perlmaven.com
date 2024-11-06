---
title: "Perl 배열과 해시에 대한 undef 호출"
timestamp: 2013-05-26T00:30:00
tags:
  - undef
  - delete
  - defined
published: true
original: undef-on-perl-arrays-and-hashes
books:
  - beginner
author: szabgab
translator: gypark
---


스칼라 변수에 대해 `undef`을 사용할 때는, 두 가지 방식으로 작성할 수 있고, 동일한 효과가 있습니다.

배열이나 해시에 대해 사용할 때는, 두 가지 방식의 결과가 다릅니다. 혼란스러운 부분을 명확히 해봅시다.


## 스칼라 변수에 대한 undef

다음 두 코드를 살펴봅시다:

첫번째는 `$x = undef;`입니다:

```perl
use strict;
use warnings;

my $x = 42;
$x = undef;

print defined $x ? 'DEFINED' : 'NOT';
```

두번째는 `undef $x;`입니다:

```perl
use strict;
use warnings;

my $x = 42;
undef $x;

print defined $x ? 'DEFINED' : 'NOT';
```

두 경우 다 "NOT"이 출력됩니다. `$x = undef`과 `undef $x`는 정확히 동일합니다.
이 둘은 또한 `$x = undef()`과 `undef($x)`와도 동일하므로, 괄호를 선호한다면
이렇게 쓸 수도 있습니다.

## 배열 원소에 대한 undef

`$names[1] = undef;`이 들어있는 다음 코드를 실행해봅시다:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my @names = qw(Foo Bar Baz);
$names[1] = undef;

print Dumper \@names;
```

다음과 같이 출력될 것입니다:

```
$VAR1 = [
          'Foo',
          undef,
          'Baz'
        ];
```

`$names[2] = undef;`을 `undef $names[2];`로 바꿔도 동일한 결과가 나옵니다.
이 두 가지는 동일하기 때문입니다.

## 배열에 대한 delete

`delete $names[2];` 형태의 코드는 폐지 예정이고 Perl 향후 버전에서는 제거될 수 있습니다.
배열의 세번째 요소(2번 인덱스)를 지우려면 `splice(@names, 2, 1)`를 사용하기 바랍니다.
[splice](https://perlmaven.com/splice-to-slice-and-dice-arrays-in-perl)에 관해 더 알아보세요.

## 배열에 대한 undef

이제 `undef @names;`를 호출하는 다음 코드를 써 봅시다.

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my @names = qw(Foo Bar Baz);
undef @names;

print Dumper \@names;
```

```
$VAR1 = [];
```

배열이 비워졌습니다.

`undef @names;` 대신에 `@names = ();`로 쓸 수도 있고, 결과는 동일하게 빈 배열을 얻게 됩니다.

반면에, `@names = undef;`처럼 쓰면 undef 원소 하나가 있는 배열이 남게 됩니다.

```
$VAR1 = [
          undef
        ];
```

이것은 <b>여러분이 원한 결과가 아닙니다</b>!


## 해시 원소에 대한 undef

다음 스크립트는 `$h{Foo} = undef;`를 사용하여 어떤 해시 키에 대응되는 값을 `undef`으로 설정합니다.

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %h = (Foo => 123, Bar => 456);
$h{Foo} = undef;

print Dumper \%h;
```

이 코드는 %h 해시의 키 Foo에 대응되는 값을 `undef`으로 설정합니다:

```
$VAR1 = {
          'Bar' => 456,
          'Foo' => undef
        };
```


`undef $h{Foo};` 역시 정확히 같은 일을 합니다.

## 해시 원소에 대한 delete

`undef`을 호출하는 대신에 `delete $h{Foo};`로 쓰면 해시에서 키와 값 둘 다를 제거합니다:

```
$VAR1 = {
          'Bar' => 456
        };
```

`delete`를 반대편에 쓰는 것은 전혀 의미가 없습니다: `$h{Foo} = delete;`는 문법 오류입니다.

## 전체 해시에 대한 undef

다음 코드에 있는 `undef %h;`를 봅시다:

```perl
use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %h = (Foo => 123, Bar => 456);
undef %h;

print Dumper \%h;
```

```
$VAR1 = {};
```

`undef %hl` 대신에 `%h = ()` 라고 쓰는 것 역시 위와 같이 해시를 빈 해시로 만듭니다.

반면에 `%h = undef;`는 옳지 않습니다. 이것은 다음과 같은 출력을 낼 것입니다:

```
Odd number of elements in hash assignment at files/eg.pl line 7.
Use of uninitialized value in list assignment at files/eg.pl line 7.
$VAR1 = {
          '' => undef
        };
```

다소 이상하게 보입니다. 무슨 일이 벌어졌냐 하면, 우리가 타이핑한 `undef`은 빈 문자열로 변환되었고, 이 때문에
[Use of uninitialized value in list assignment at ...](/use-of-uninitialized-value) 경고가
발생합니다. 이 빈 문자열이 해시 안에서 키가 됩니다.

그 다음으로 보면, 이 키에 대응되는 값이 없습니다. 이 때문에 <b>Odd number of elements in hash assignment</b> 경고가
뜹니다. 그리고 `undef`이 이 빈 문자열 키에 대응되는 값으로 할당됩니다.

어쨌거나, 이것은 <b>여러분이 원한 결과가 아닙니다</b>!

결론적으로, 단도직입으로 묻는다면 다음과 같이 답할 수 있습니다:

## Perl에서 배열과 해시를 리셋하려면?

```perl
@a = ();
%h = ();
```


## 해시 전체를 리셋하거나 키/값 쌍을 리셋하려면?

전체 해시 리셋:

```perl
%h = ();
```

키/값 쌍 제거:

```perl
delete $h{Foo};
```

어떤 키/값 쌍의 값만 제거:

```perl
$h{Foo} = undef;
```

