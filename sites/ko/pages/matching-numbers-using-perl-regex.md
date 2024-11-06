---
title: "Perl 정규표현식을 사용하여 숫자 추출하기"
timestamp: 2014-05-20T14:00:00
tags:
  - ^
  - +
  - "[]"
  - "*"
published: true
original: matching-numbers-using-perl-regex
author: szabgab
translator: gypark
---


다음과 같은 내용의 파일이 있습니다:

```
Usage:524944/1000000 messages
```

어떻게 하면 두 개의 수를 추출해서 나중에 처리할 수 있을까요?


정규식을 살펴봅시다:

저 문자열은 "Usage:"로 시작하므로, 정규식도 다음과 같이 시작할 것입니다:

```perl
/Usage:/
```

Perl 5에서 콜론은 특수 문자가 아니기 때문에 :를 따로 이스케이프할 필요는 없습니다.

만일 이 부분이 문자열의 시작 부분에 있다는 걸 알고 있고, 또한 반드시 시작 부분에 있어야만 한다면
명시적으로 `^`을 앞에 넣어서 표현해주어야 합니다.

```perl
/^Usage:/
```

이 조건이 반드시 필요하진 않은 듯 하니 여기서는 일단 빼겠습니다.

이 문자열의 그 다음 부분에는 어떤 수가 오는데, 어떤 숫자든 올 수 있다고 가정해도 될 것 같습니다.
`\d`은 하나의 숫자에 매치되며, `+` 수량자가 붙으면
<b>하나 또는 그 이상의 숫자들</b>을 의미하게 됩니다.

```perl
/Usage:\d+/
```

여기까지는 좋습니다만, 우리는 이 수를 추출했다가 재사용하고자 하므로, 그 수에 매치되는
정규식을 괄호 안에 넣겠습니다:

```perl
/Usage:(\d+)/
```

이제 다음과 같은 코드를 만들 수 있습니다:

```perl
my $str = 'Usage:524944/1000000 messages';
if ( $str =~ /Usage:(\d+)/) {
   my $used = $1;
   # 이제 $used 변수에는 524944가 들어 있음
}
```

그 다음은 `/`에 매치할 차례입니다. 슬래시는 정규표현식의 구분자이기 때문에
정규식 내에서 사용하려면 이스케이프해주어야 합니다:

```perl
/Usage:(\d+)\//
```

썩 좋아보이지 않습니다. 다행히도 우리는 `m` 연산자(matching을 의미합니다)를
사용하여 Perl 5에서 정규식의 구분자를 다른 것으로 바꿀 수 있습니다.
이렇게 하면 슬래시가 아닌 다른 문자를 사용할 수 있습니다. 저는 개인적으로
중괄호 쌍을 쓰는 것을 선호하는데, 가독성이 좋아지기 때문입니다:

```perl
m{Usage:(\d+)/}
```

원본 문자열의 / 뒤에는 여러 자리의 숫자로 이루어진 또다른 수가 나오고 있고 우리는 이것도
추출하려고 합니다:

```perl
m{Usage:(\d+)/(\d+)}
```

이 뒤에는 스페이스 하나와 'messages'라는 단어가 나옵니다.

```perl
m{Usage:(\d+)/(\d+) messages}
```

그 뒤에 아무 것도 나오지 않는다는 것을 확실히 하고 싶으면 정규식의 끝에
`$`을 붙일 수 있습니다:

```perl
m{Usage:(\d+)/(\d+) messages$}
```

이렇게 하면, "Usage:524944/1000000 messages sent"와 같은 문자열은 매치되지 않을 것입니다.

앞서 보았던 예문으로 돌아가서, 앞에도 `^`를 붙일 수 있습니다:

```perl
m{^Usage:(\d+)/(\d+) messages$}
```

이것은 "Usage"의 앞이나 "messages"의 뒤에 아무 것도 없어야만 매치될 것입니다. 이것은 상황에
따라 좋을 수도 있고 아닐 수도 있습니다. 저는 굳이 그런 제약을 붙일 건 없다고 생각하므로
이 마지막 예문에서는 빼겠습니다:

```perl
my $str = 'Usage:524944/1000000 messages';
if ( $str =~  m{Usage:(\d+)/(\d+) messages} ) {
   my ($used, $total) = ($1, $2);
   # here we will have the 524944 in the $used variable
   # and 1000000 in $total.
}
```

## 유연성 추가

여기에서 어느 정도의 유연성이 필요할지는 잘 모르겠습니다.
아마 두번째 수 뒤에 있는 스페이스는 여러 개일 수도 있습니다. 어쩌면 탭이 쓰였을지도 모릅니다.
이런 걸 허용하기 위해서, 하나 또는 그 이상의 공백을 의미하는 `\s+`을 쓸 수도 있습니다.

```perl
m{^Usage:(\d+)/(\d+)\s+messages$}
```

어쩌면 :과 첫번째 수 사이에도 공백이 있을지 모릅니다. 이것을 허용하기 위해서
`\s*`을 써줄 수 있습니다. `*`은 <b>0개 또는 그 이상</b>을 의미합니다.

```perl
m{^Usage:\s*(\d+)/(\d+)\s+messages$}
```

이 정규식을 더욱 읽기 편하게 만들기 위해서 `x` 변경자를 뒤에 추가할 수 있습니다.
그러면 정규식에 공백이나 주석문을 넣어서 정규식을 더 읽기 좋게 만들 수 있습니다:

```perl
m{^Usage:
  \s*
  (\d+)/(\d+)    # used / total
  \s+messages
 $}x
```


## 데이타가 달라지는 경우

여기까지 아주 훌륭합니다만, 어느 시점에 입력이 좀 달라졌습니다. 이제 문자열이
다음과 같이 생겼습니다:

```
Usage:524,944 of 1,000,000 messages
```

우리가 만든 정규식을 수정하는 대신, 처음부터 만들어봅시다. 이번에는 처음부터
/x 옵션을 사용하여 정규식에 여백을 더 넣겠습니다.

앞부분은 아까와 같고, 콜론 뒤에 스페이스가 올 수 있도록 하겠습니다:

```perl
/^Usage:\s*/x
```

그 다음은 숫자와 쉼표로 구성된 부분이 있습니다. 따라서 하나의 숫자 또는 쉼표에 매치되는
캐릭터 클래스 `[\d,]`를 만들고, 그 캐릭터 클래스에 `+` 수량자를 적용합니다:

```perl
/^Usage:\s*
   [\d,]+
/x
```

우리는 그 수를 추출하고 싶으니 괄호에 넣고, 명확히 보이라고 주석문을 추가합니다.

```perl
/^Usage:\s*
   ([\d,]+)     # used
/x
```

이 숫자 뒤에는 스페이스가 하나 있는데 /x 변경자 때문에 perl은 정규식 안에 있는
스페이스들을 무시할 것입니다. 우리는 여기서 스페이스와 탭 두 가지 다 허용하기
위해서 "of" 좌우에 ` ` 대신에 `\s`을 사용합니다.

```perl
/^Usage:\s*
   ([\d,]+)      # used
   \s+of\s+
/x
```

이 뒤에는 또다시 쉼표가 포함된 숫자가 옵니다: 

```perl
/^Usage:\s*
   ([\d,]+)      # used
   \s+of\s+
   ([\d,]+)      # total
/x
```

그 뒤에는 다시 공백문자(또는 공백문자들)와 "messages"라는 단어가 옵니다: 

```perl
/^Usage:\s*
   ([\d,]+)      # used
   \s+of\s+
   ([\d,]+)      # total
   \s+messages
/x
```

이 정규식을 `if` 구문에 사용할 수 있습니다: 

```perl
my $str = 'Usage:524,944 of 1,000,000 messages';
if ($str =~ /^Usage:\s*
            ([\d,]+)      # used
            \s+of\s+
            ([\d,]+)      # total
            \s+messages
           /x) {
  my ($used, $total) = ($1, $2);
  ...
}
```

끝으로, 저 숫자들을 숫자로 사용하고 싶다면
치환 연산을 두 번 사용하여 쉼표를 제거할 수 있습니다:

```perl
$used =~ s/,//g;
$total =~ s/,//g;
```


## 다른 방법

위 코드는 제대로 동작합니다만, 다른 방법으로 정규식을 쓸 수도 있습니다. Perl의 모토처럼
어떤 일을 하는데는 여러 방법이 있습니다. (TMTOWDI - There's More Than One Way To Do It) 다음 예를 봅시다:

```perl
if (my ($used, $total) = $str =~ /^Usage:\s*
            ([\d,]+)      # used
            \s+of\s+
            ([\d,]+)      # total
            \s+messages
           /x) {
  ...
}
```

이 코드에서는 `=~`의 특성을 이용했는데, [리스트 문맥](/scalar-and-list-context-in-perl)에서
캡처용 괄호가 있다면, 이 괄호에 의해 추출된 문자열들로 이루어진 리스트를 반환한다는 특성입니다.
따라서 `$1`과 `$2` 변수를 따로 쓰지 않고 곧바로 `$used`와 `$total`에
값을 넣을 수 있습니다.

## 이름을 붙여 추출하기

perl 5.10 또는 그 이후 버전을 쓰는 사람들이 할 수 있는 또다른 방법은 캡처 그룹에 이름을
붙이는(Named Capture) 것입니다. 
[Tim Heaney (oylenshpeegul)](http://oylenshpeegul.typepad.com/)씨가 만든
예문입니다:

```perl
#!/usr/bin/env perl

use v5.010;
use strict;
use warnings;

my $str = 'Usage:524944/1000000 messages';

# The manual way.
if ( $str =~ m{Usage:(\d+)/(\d+) messages} ) {
    my ($used, $total) = ($1, $2);
    say "$used $total";
}

# The one-line less way:
if (my ($used, $total) = $str =~ m{Usage:(\d+)/(\d+) messages}) {
    say "$used $total";
}

# Named captures:
if ($str =~ m{Usage:(?<used>\d+)/(?<total>\d+) messages} ) {
    say "$+{used} $+{total}";
}
```

## 유니코드로 된 숫자들

[Nick Patch](http://nickpatch.net/)씨는 `\d`가 유니코드 상의 어떤 숫자에도
매치된다는 점을 언급하는 게 중요하다고 생각했습니다.

```perl
# the number 3 in eight different numeral systems
perl -Mutf8 -E 'say "٣३၃៣๓໓᠓௩" =~ /^\d+$/ ? "yes" : "no"'
yes
```

또한 [Regexp::Common](http://metacpan.org/pod/Regexp::Common)
모듈은 유니코드나 쉼표 등의 문제를 신경쓰지 않고 수를 찾아내는
훌륭한 방법을 제공합니다.

```perl
use Regexp::Common qw( number );

$str =~ / Usage: \s* ( $RE{num}{int}{-sep=>',?'} ) /x;
```


## 출처

[원래의 질문](http://mail.pm.org/pipermail/pdx-pm-list/2012-February/006339.html)은
[Portland Perl Mongers](http://pdx.pm.org/) 메일링 리스트에
[Russell Johnson](http://dimstar.net/)씨가 올린 글입니다.

