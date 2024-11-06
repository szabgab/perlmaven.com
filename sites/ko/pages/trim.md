---
title: "trim - Perl로 문자열의 앞뒤 공백 문자 제거하기"
timestamp: 2013-04-17T10:01:01
tags:
  - trim
  - ltrim
  - rtrim
published: true
original: trim
books:
  - beginner
author: szabgab
translator: keedi
---


어떤 다른 언어에서는 문자열의 시작 부분이나 끝 부분의 스페이스나 탭 문자를
제거할 수 있는 <b>ltrim</b>이나 <b>rtrim</b> 함수가 있습니다.
때로는 양쪽 끝 모두의 공백 문자를 제거하는 <b>trim</b> 함수를 제공하기도 합니다.

Perl에는 그런 간단한 함수가 없지만
(비록 이 기능을 구현한 수많은 CPAN 모듈이 있다는 것을 확신하지만요)
단순한 정규표현식을 이용해서 간단히 해결할 수 있습니다.

실제로 이것은 무척 간단하며 [bikeshedding](https://en.wikipedia.org/wiki/Parkinson%27s_law_of_triviality)의 훌륭한 주제 중 하나입니다.


## 왼쪽 끝 잘라내기

<b>ltrim</b> 또는 <b>lstrip</b>은 문자열의 왼쪽에 있는 공백 문자를 제거합니다.

```perl
$str =~ s/^\s+//;
```

문자열의 시작 부분에서 `^`은 1개 이상의 공백 문자(`\s+`)를 선택한 후
선택한 부분을 빈 문자열로 치환합니다.

## 오른쪽 끝 잘라내기

<b>rtrim</b> 또는 <b>rstrip</b>은 문자열의 오른쪽에 있는 공백 문자를 제거합니다.

```perl
$str =~ s/\s+$//;
```

1개 이상의 공백 문자(`\s+`)를 문자열의 끝 부분(`$`)까지 선택한 후
선택한 부분을 빈 문자열로 치환합니다.

## 양쪽 끝 모두 잘라내기

<b>trim</b>은 양쪽 끝에 있는 공백 문자를 제거합니다.

```perl
$str =~ s/^\s+|\s+$//g
```

앞에서 살펴본 두 정규 표현식을 교대 마크(alternation mark `|`)를 이용해서 합치고,
치환 명령의 끝에 `/g`를 추가해서 치환이 <b>전역</b>적(반복해서)으로 실행되도록 합니다.

## 함수로 숨기기

앞에서 처리한 명령을 일일이 보고 싶지 않다면 여러분의 코드에 다음 함수를 추가하세요.

```perl
sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
```

그리고는 이렇게 사용하면 됩니다.

```perl
my $z = " abc ";
printf "<%s>\n", trim $z;   # <abc>
printf "<%s>\n", ltrim $z;  # <abc >
printf "<%s>\n", rtrim $z;  # < abc>
```


## String::Util

정말, 정말로 앞에서 본 코드를 복사하고 싶지 않다면 늘 그렇듯 모듈을 설치하세요.

예를 들면 [String::Util](https://metacpan.org/pod/String::Util)
모듈은 `trim` 함수를 제공하며, 다음 예제처럼 사용할 수 있습니다.

```perl
use String::Util qw(trim);

my $z = " abc ";
printf "<%s>\n", trim $z;               # <abc>
printf "<%s>\n", trim $z, right => 0;   # <abc >
printf "<%s>\n", trim $z, left  => 0;   # < abc>
```

By default it trims on both sides and you have to turn off trimming.
기본적으로 trim 함수는 양쪽의 공백 문자열을 모두 제거하므로
제거하고 싶지 않은 쪽은 옵션을 이용해 꺼줘야합니다.
개인적으로는 여러분만의 `ltrim` 함수와 `rtrim`
함수를 갖는 편이 명확할 것 같습니다.

## Text::Trim

또 다른 모듈인 [Text::Trim](https://metacpan.org/pod/Text::Trim)은
세 개의 함수를 모두 제공합니다.
하지만 trim은 Perl스러운 방법으로 사용할 수 있는데 이것은 조금 위험할 수 있습니다.

trim을 호출하고 호출한 결과 값을 print 구문에서 사용하거나 변수에 할당하면
공백 문자를 제거한 문자열을 반환하며 원래의 문자열은 그대로 유지합니다.

```perl
use Text::Trim qw(trim);

my $z = " abc ";
printf "<%s>\n", trim $z;  # <abc>
printf "<%s>\n", $z;       # < abc >
```

반대로 빈 문맥(VOID context)에서 trim을 호출하면,
즉 trim 함수의 반환값을 사용하지 않으면, trim 함수는 마치
[chomp](https://perlmaven.com/chomp) 함수처럼 매개변수 자신을 변경합니다.

```perl
use Text::Trim qw(trim);

my $z = " abc ";
trim $z;
printf "<%s>\n", $z;       # <abc>
```
