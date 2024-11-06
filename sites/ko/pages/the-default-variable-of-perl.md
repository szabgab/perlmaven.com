---
title: "펄의 기본변수 $_"
timestamp: 2013-06-09T17:10:00
tags:
  - Perl
  - $_
  - scalar
  - default
  - variable
  - topic
published: true
original: the-default-variable-of-perl
books:
  - beginner
author: szabgab
translator: johnkang
---


펄에는 `$_` 라고 불리는 좀 이상한 스칼라 변수가 있습니다.
`기본 변수` 또는 다른말로 <b>topic</b> 이라 합니다.

펄 에서 몇몇 함수들과 연산자들은 명확한 파라미터가 없을때 이 변수를 기본으로 사용 합니다.
전반적으로 실제 코드에서 이 기본 변수를 볼 수 없을 것이며,
`$_`의 핵심은
이 변수를 명확하게 사용할 필요가 없다는 것입니다.

사용해야 할때는 제외 하고 말이죠 :)


기본변수를 갖는다는건 정말로 엄청난 발상이지만,
부정확하게 사용한다면 코드의 가독성을 떨어뜨릴 수 있습니다.

아래의 스크립트를 확인 해보세요.

```perl
use strict;
use warnings;
use v5.10;

while (<STDIN>) {
   chomp;
   if (/MATCH/) {
      say;
   }
}
```

다음 아래는 위의 것과 완전히 동일 합니다.

```perl
use strict;
use warnings;
use v5.10;

while ($_ = <STDIN>) {
   chomp $_;
   if ($_ =~ /MATCH/) {
      say $_;
   }
}
```

필자는 결코 두번째 방법으로 작성하지 않을 것이며,
매우 간단한 스크립트나 코드의 엄격함이 요구되는 부분에서 아마도 첫번째 방법으로 작성 할 것 입니다.

설사 있더라도 말이죠.

`while` 반복문에서 볼 수 있듯이 파일 핸들로부터 내용을 읽어 들일때 심지어 표준입력 일지라도
명확하게 어떤 변수에 대입 하지 않는다면,
읽어 들인 줄은 `$_`에 대입 되어집니다.

`chomp()</h1>는 파라미터가 주어지지 않았다면 기본적으로 이 변수를 사용하여 동작합니다.

정규표현식 매치도 명확한 문자열, 심지어 `=~`연산자 없이도 작성 될 수 있습니다.
위와 같은방법으로 작성 된다면 정규표현식은 `$_`변수에 담겨진 내용에 매치를 수행 합니다.

마지막으로 `say()`도 파라미터가 주어지지 않는다면,
`print()`처럼 `$_`의 내용을 출력할 것 입니다

## split

`split`의 두번째 파라미터는 조각조각 나뉘어질 문자열 입니다.
만약 두번째 파라미터가 주어지지 않는다면, split은 `$_`의 내용을 조각낼 것 입니다.

```perl
my @fields = split /:/;
```

## foreach

만약 `foreach`의 iterator 변수의 이름을 제공해주지 않는 다면
`$_`를 사용 할 것입니다.

```perl
use strict;
use warnings;
use v5.10;

my @names = qw(Foo Bar Baz);
foreach (@names) {   # 변수를 $_ 에 할당 합니다.
    say;
}
```

## 조건에서의 대입

실수로 인한 `$_`의 묵시적인 사용예가 있습니다.

일부 숙련자들은 아래와 같은 유형의 코드를 의도적으로 사용 할 수 있습니다.
그렇지만 숙련되지 않은 프로그래머의 의해 이처럼 코드가 작성되는건 bug일 수 있습니다.

```perl
if ($line = /regex/) {
}
```

보이는 것 처럼, 정규표현식 연산자 : `=~` 대신에 대입 연산자 : `=`를 사용하였습니다.
이것은 실제로 다음과 똑같습니다.

```perl
if ($line = $_ =~ /regex/) {
}
```

이것은 `$_`의 내용을 먼저 취하고 해당 값에 패턴 매치를 수행 합니다.
그리고 그 결과를 `$line`에 대입 합니다. 그런다음 $line의 내용이 참인지 거짓인지 확인합니다.

## $_ 명확하게 사용하기

필자가 서두 에서 `$_` 을 명확하게 사용하지 않는 것을 추천 한다고 언급 했었습니다.

```perl
while (<$fh>) {
  chomp;
  my $prefix = substr $_, 0, 7;
}
```

`substr` 처럼 명확하게 `$_`을 써야 하는 구문을 사용하면
항상 더 의미있는 이름을 사용하는게 좋습니다.
더 많은 타이핑을 해야 한다고 해도 말이죠!

```perl
while (my $line = <$fh>) {
  chomp $line;
  my $prefix = substr $line, 0, 7;
}
```

안좋은 예

```perl
while (<$fh>) {
   my $line = $_;
   ...
}
```

이 코드는 `while` 구문과 파일핸들에 대한 읽기 연산자(우주선 연산자)
그리고 `$_`의 사이의 상호작용을 알지 못하는 사람에게 혼란을 줄 수 있습니다.

이 코드느 `$line`에 직접 대입하는 방법으로 좀 더 간결히 작성될 수 있습니다.

```perl
while (my $line = <$fh>) {
   ...
}
```

## 예외

반드시 `$_`을 명시적으로 사용해야 할 때도 있습니다.
[grep](https://perlmaven.com/filtering-values-with-perl-grep) 과
[map](https://perlmaven.com/transforming-a-perl-array-using-map) 연산자 그리고
또 다른 유사한 [any](https://perlmaven.com/filtering-values-with-perl-grep)와 같은 것들이 그러한 경우 입니다.


