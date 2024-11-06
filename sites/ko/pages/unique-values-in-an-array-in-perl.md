---
title: "배열에서 고유 값들만 남기기"
timestamp: 2013-05-19T12:00:00
tags:
  - unique
  - uniq
  - distinct
  - filter
  - grep
  - array
  - List::MoreUtils
  - duplicate
published: true
original: unique-values-in-an-array-in-perl
books:
  - beginner
author: szabgab
translator: gypark
---


[펄 튜토리알](/perl-tutorial)의 이번 내용은 어떻게 <b>배열에서 고유한 값들만 남도록</b>
할 수 있는가입니다.

Perl 5에는 배열에서 중복된 값을 걸러내는 내장 함수는 없지만, 여러가지 방법으로 해결할 수 있습니다.


## List::MoreUtils

상황에 따라서 다르겠지만, 아마 가장 간단한 방법은
CPAN에 있는 [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils)
모듈이 제공하는 `uniq` 함수를 사용하는 것입니다.

```perl
use List::MoreUtils qw(uniq);

my @words = qw(foo bar baz foo zorg baz);
my @unique_words = uniq @words;
```

다음은 전체 예제 코드입니다:

```perl
use strict;
use warnings;
use 5.010;

use List::MoreUtils qw(uniq);
use Data::Dumper qw(Dumper);

my @words = qw(foo bar baz foo zorg baz);

my @unique_words = uniq @words;

say Dumper \@unique_words;
```

결과는 다음과 같습니다:

```
$VAR1 = [
        'foo',
        'bar',
        'baz',
        'zorg'
      ];
```

재미있게도 이 모듈에는 `distinct`라는 함수도 있는데, 이 함수는 결국
`uniq` 함수의 또다른 이름일 뿐입니다.

이 모듈을 사용하려면 CPAN을 통해 설치를 해야 합니다.

## 직접 만든 uniq

어떤 이유에서든 위의 모듈을 설치할 수 없다면, 또는 모듈을 로드하는
오버헤드가 너무 크다고 생각한다면, 동일한 일을 하는 매우 짧은 표현식이
있습니다:

```perl
my @unique = do { my %seen; grep { !$seen{$_}++ } @data };
```

이것은, 모르는 사람들에게는 신비스럽게 보일 수 있습니다.
그러니 `uniq` 서브루틴을 따로 만들어서, 코드의 다른 부분에서는
이 서브루틴을 사용하는 것을 권장합니다:

```perl
use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);

my @words = qw(foo bar baz foo zorg baz);

my @unique = uniq( @words );

say Dumper \@unique_words;

sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}
```

## 직접 만든 uniq 상세한 설명

위의 예제를 이렇게 끝내버리고 가자니 아깝습니다. 좀 더 설명해볼까 합니다.
더 쉬운 형태부터 시작해 봅시다:

```perl
my @unique;
my %seen;

foreach my $value (@words) {
  if (! $seen{$value}) {
    push @unique, $value;
    $seen{$value} = 1;
  }
}
```

여기서는 통상적인 `foreach` 루프를 사용하여 원 배열의 원소들을 하나씩
순회하고 있습니다. 또한 `%seen` 해시를 사용하고 있는데,
해시의 멋진 점은 해시의 키들은 <b>중복되지 않는다</b>는 점입니다.

처음 시작할 때는 해시는 비어 있기 때문에, 첫번째 "foo"를 만났을 때 `$seen{"foo"}`는
아직 존재하지 않고, 그 값은 `undef`이며 이 값은 Perl에서는 거짓으로 간주됩니다.
이것은 아직 "foo"란 값을 본 적이 없다는 뜻이고, 고유한 값들을 저장하기 위해 마련한
`@uniq` 배열의 제일 뒤에 이 값을 추가합니다.

또한 `$seen{"foo"}`의 값을 1로 설정합니다. 사실 Perl에서 "참"으로 간주되는
값이라면 뭐든 상관없습니다.

다음번에 동일한 문자열을 만나게 되면, 이미 `%seen` 해시 안에는
그 키가 있고, 그 키에 대응되는 값은 참이고, 따라서 `if` 조건을
만족시키지 못하며, 결국 결과 배열에 그 값을 중복해서 `push`하지
않게 됩니다.

## 직접 만든 uniq 짧게 줄이기

먼저 1을 할당하던 `$seen{$value} = 1;` 부분을 증가연산자를 쓰도록
`$seen{$value}++`으로 고칩니다. 모든 양수는 다 참으로 평가되므로
이렇게 고쳐도 앞에서 본 해결책과 동작 원리는 달라지지 않습니다. 그러나 이렇게 고치면
"봤다는 표시"를 하는 부분을 `if` 조건 안에 삽입할 수 있습니다.
이 때 후위 증가 연산자(전위 증가 연산자가 아니라)를 써야 한다는 것이 중요합니다.
그래야 일단 조건식을 평가한 이후에 증가 연산이 수행되게 됩니다.
어떤 값을 처음 만났을 때는 조건식이 참이 되고, 그 이후부터는 거짓이 될 것입니다.

```perl
my @unique;
my %seen;

foreach my $value (@data) {
  if (! $seen{$value}++ ) {
    push @unique, $value;
  }
}
```

처음보다 짧아졌지만, 좀 더 개선할 수 있습니다.

## grep을 사용하여 중복된 값 걸러내기

Perl의 `grep` 함수는 Unix의 유명한 grep 명령을 일반화한 것입니다.

이것은 기본적으로 [필터](https://perlmaven.com/filtering-values-with-perl-grep)입니다.
우변에 배열을, 블럭 안에 표현식을 적으면, `grep` 함수는 배열의 원소를 하나씩 꺼내어
[Perl의 디폴트 스칼라 변수](https://perlmaven.com/the-default-variable-of-perl)인
`$_`에 넣고, 블럭 내의 코드를 실행합니다.
블럭의 실행 결과가 참이 되면 이 원소는 통과하고, 거짓이 된다면 이 원소는 걸러집니다.

이 원리를 이용하여 다음과 같은 표현식을 만듭니다:

```perl
my %seen;
my @unique = grep { !$seen{$_}++ } @words;
```

## 'do' 또는 'sub'로 감싸기

마지막으로 할 일은, 위의 두 구문을 `do` 블럭 안에 넣거나

```perl
my @unique = do { my %seen; grep { !$seen{$_}++ } @words };
```

또는, 더 좋은 방법은, 용도를 나타내는 이름을 붙여서 함수로 만드는 것입니다:

```perl
sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}
```

## 직접 만든 uniq - 2라운드

Prakash Kailasa가 uniq를 구현하는 더 짧은 형태를 제시했습니다.
Perl 버전이 5.14 또는 그 이후 버전이어야 하며, 원소들의 순서를 보존할 필요가 없는 경우에
사용할 수 있습니다.

인라인 코드로는:

```perl
my @unique = keys { map { $_ => 1 } @data };
```

서브루틴으로 만든다면:

```perl
my @unique = uniq(@data);
sub uniq { keys { map { $_ => 1 } @_ } };
```

이 표현식을 분해해 봅시다:

`map`을 쓰는 문법은 `grep`과 유사합니다: 블럭과 배열(또는 값들의 리스트)을 받습니다.
map은 배열의 각 원소를 순회하면서, 블럭을 실행하고 그 결과를 왼쪽으로 전달합니다.

위와 같은 경우, 배열의 모든 원소값에 대하여 map은 그 값과 그 뒤를 이어 1을 전달합니다.
fat comma라고도 불리는 `=&gt;`는 결국 콤마임을 기억하세요.
@data가 ('a', 'b', 'a')였다면, 다음 식은 ('a', 1, 'b', 1, 'a', 1)을 반환할 것입니다.

```perl
map { $_ => 1 } @data
```

저 식을 해시에 할당한다면, 원래의 데이타값들은 키가 되고, 각 키에 대응되는 값은 1인 해시를 얻게 됩니다.
다음의 코드를 실행해보면:

```perl
use strict;
use warnings;

use Data::Dumper;

my @data = qw(a b a);
my %h = map { $_ => 1 } @data;
print Dumper \%h;
```

이런 결과를 얻게 됩니다:
```
$VAR1 = {
          'a' => 1,
          'b' => 1
        };
```

만약, 위 식을 해시에 할당하는 대신 중괄호로 둘러싸면, 익명 해시의 레퍼런스를 얻을 수 있습니다.

```perl
{ map { $_ => 1 } @data }
```

직접 해 보면:

```perl
use strict;
use warnings;

use Data::Dumper;
my @data = qw(a b a);
my $hr = { map { $_ => 1 } @data };
print Dumper $hr;
```

해시의 내용을 출력할 때 키들의 순서는 달라질 수 있지만, 그 외에는 앞의 코드에서와 동일하게 출력될 것입니다.

마지막으로, Perl 5.14부터는 `keys` 함수를 해시 레퍼런스에 대해서도 호출할 수 있습니다.
따라서 다음과 같이 쓸 수 있고:

```perl
my @unique = keys { map { $_ => 1 } @data };
```

`@data`에서 고유한 값들을 얻을 수 있습니다.


## 실습

다음 파일이 주어졌을 때 고유값들을 출력해보세요:

input.txt:

```
foo Bar bar first second
Foo foo another foo
```

다음과 같이 출력되어야 합니다:

```
foo Bar bar first second Foo another
```

## 실습 2

이번에는 대소문자를 구분하지 않고 중복되는 것을 걸러봅시다.

다음과 같이 출력되어야 합니다:

```
foo Bar first second another
```


