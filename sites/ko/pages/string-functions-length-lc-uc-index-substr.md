---
title: "문자열 함수: length, lc, uc, index, substr"
timestamp: 2013-04-17T14:45:56
tags:
  - length
  - lc
  - uc
  - index
  - substr
  - scalar
published: true
original: string-functions-length-lc-uc-index-substr
books:
  - beginner
author: szabgab
translator: keedi
---


[Perl 사용 지침서](/perl-tutorial)중 이번에는
Perl이 제공하는 문자열을 조작 함수에 대해 배워봅니다.


## lc, uc, length

<b>lc</b>와 <b>uc</b>는 원래의 문자열을 각각 소문자나 대문자로
변환하는 간단한 함수입니다.
<b>length</b> 함수는 주어진 문자열의 문자 개수를 반환합니다.

다음 예제를 살펴보겠습니다.

```perl
use strict;
use warnings;
use 5.010;

my $str = 'HeLlo';

say lc $str;      # hello
say uc $str;      # HELLO
say length $str;  # 5
```


## index

<b>index</b> 함수는 인자로 두 문자열을 인자로 받은 후
첫 번째 문자열에서 두 번째 문자열이 처음으로 나타나는 위치를 반환합니다.

```perl
use strict;
use warnings;
use 5.010;

my $str = "The black cat jumped from the green tree";

say index $str, 'cat';             # 10
say index $str, 'dog';             # -1
say index $str, "The";             # 0
say index $str, "the";             # 26
```

첫 번째 호출에서 문자열 "cat"은 10번째 문자에서부터
일치하므로 `index`는 10을 반환합니다.
두 번째 호출에서 문자열 "dog"은 일치하는 곳이 없기 때문에
`index`는 일치하는 위치가 없음을 의미하는 -1을 반환합니다.

세 번째 호출에서 문자열 "The"는 첫 번째 문자열의 시작 부분부터
일치하므로 `index`는 0을 반환합니다.

네 번째 호출에서 문자열 "the"가 정확하게 일치하는 위치를 반환합니다.
그러므로 "the"와 "The"는 다르다는 점을 유의하세요.

`index()` 함수는 단어를 찾는 것이 아니라 문자열을 찾기 때문에
"e "와 같은 문자열을 넣어도 원하는 위치를 찾아냅니다.

```perl
say index $str, "e ";              # 2
```

`index()` 함수는 세 번째 매개변수를 사용해서
검색을 시작할 위치를 지정할 수도 있습니다.

So as we found "e " to start at the 2nd character of the first string,
그래서 첫 번째 문자열에서 "e " 문자열을 두 번째 문자 위치에서 찾은 것 처럼
"e " 문자열이 또 다른 곳에 존재하는지 확인하기 위해 검색을 시작할 지점을
세 번째 문자 위치 이후로 조정할 수 있습니다.

```perl
say index $str, "e ";              # 2
say index $str, "e ", 3;           # 28
say index $str, "e", 3;            # 18
```

공백 문자 없이 "e"를 찾으면 다른 결과가 나온다는 점을 유의하세요.

마지막으로 <b>rindex</b> (오른쪽 index) 함수가 있습니다.
rindex 함수는 문자열의 오른쪽 끝에서 검색을 시작합니다.

```perl
say rindex $str, "e";              # 39
say rindex $str, "e", 38;          # 38
say rindex $str, "e", 37;          # 33
```

## substr

기사에 나오는 함수 중 가장 흥미로운 함수는 바로 `substr` 함수입니다.
기본적으로 substr() 함수는 index() 함수와 정반대입니다.
index() 함수는 <b>주어진 문자열이 어디있는지</b> 알려주는 반면,
substr() 함수는 <b>주어진 위치의 부분 문자열</b>을 반환합니다.

보통 `substr` 함수는 3개의 매개변수를 받습니다.
첫 번째 매개변수는 문자열입니다.
두 번째 매개변수는 0을 기준으로 하는 위치로 <b>오프셋</b>이라고도 합니다.
세 번째 매개변수는 추출하고 싶은 부분 문자열의 <b>길이</b>입니다.

```perl
use strict;
use warnings;
use 5.010;

my $str = "The black cat climbed the green tree";

say substr $str, 4, 5;                      # black
```

substr 함수는 0을 기준으로 위치를 지정하므로 오프셋 4에 해당하는 문자는 b 입니다.

```perl
say substr $str, 4, -11;                    # black cat climbed the
```

세 번째 매개변수(길이)로 음수를 사용할 수도 있습니다.
이 경우 음수는 원래 문자열의 오른쪽 끝에서 부터 포함하지 않을
문자열의 개수를 의미합니다.
따라서 앞의 예제의 경우 왼쪽에서 4번째 위치와
오른쪽에서 11번째 위치 사이의 문자열을 반환합니다.

```perl
say substr $str, 14;                        # climbed the green tree
```

세 번째 매개변수(길이)를 생략할 수도 있는데, 이 경우
시작 지점에서 문자열의 끝까지 모든 문자를 반환합니다.

```perl
say substr $str, -4;                        # tree
say substr $str, -4, 2;                     # tr
```

오프셋 위치에도 음수를 사용할 수 있는데,
앞의 예제의 경우 오른쪽 끝에서 4번째 위치에서 시작한다는 뜻입니다.
이것은 오프셋 값으로 `length($str)-4`로 설정하는 것과 동일합니다.

## 문자열의 일부를 치환하기

마지막 예제는 제법 파격적입니다.
지금까지 `substr`의 모든 예제는 부분 문자열을 반환하고
원래의 문자열은 온전하게 보존했습니다.
이번 예제에서 substr은 여전히 동일한 방식으로 값을 반환하지만
이번에는 substr이 원래의 문자열의 내용을 변경하기까지합니다!

`substr()` 함수의 반환값은 항상 처음의 세 매개변수가 결정합니다.
하지만 다음 예제에서 substr은 4개의 매개 변수를 가지고 있습니다.
이 경우 원래의 문자열에서 선택된 부문 문자열은 네 번째 매개변수에
해당하는 문자열로 치환됩니다.

```perl
my $z = substr $str, 14, 7, "jumped from";
say $z;                                                     # climbed
say $str;                  # The black cat jumped from the green tree
```

따라서 `substr $str, 14, 7, "jumped from"`은 <b>climbed</b>를
반환하지만, 네 번째 매개변수로 인해 원래의 문자열은 변경됩니다.
