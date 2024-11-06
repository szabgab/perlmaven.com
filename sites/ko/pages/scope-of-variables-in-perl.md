---
title: "Perl에서의 변수 영역"
timestamp: 2013-04-28T02:09:21
tags:
  - my
  - scope
published: true
original: scope-of-variables-in-perl
books:
  - beginner
author: szabgab
translator: yongbin
---


Perl에는 두 가지 변수 선언 형식이 있습니다. 그중 한 가지는 `use vars` 생성자나, `our` 함수를 이용해서 선언하는 패키지 전역변수 선언입니다. 최근 더 활발하게 사용되는 다른 한가지는 my를 이용해서 변수를 어휘영역(렉시컬 영역)에 선언하는 것입니다.

만약 내가 `my`로 변수를 선언한다면 코드에서 어디까지 내가 선언한 변수가 보이고 어디부터 그 변수를 잃어버릴까요? 다음 예제들을 통해 내가 선언한 변수의 <b>영역</b>이 어떻게 되는지 살펴봅시다.


## 블록 속에서 선언된 경우

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $email = 'foo@bar.com';
    print "$email\n";     # foo@bar.com
}
# print $email;
# $email does not exists
# Global symbol "$email" requires explicit package name at ...
```

위 코드에서 우리는 중괄호로 감싼 익명 블록 안에서 `$email` 이라는 새로운 변수를 선언했습니다. 이 변수는 변수가 선언된 시점부터 블록이 끝나는 시점까지 존재합니다. 따라서 닫는 중괄호 이후부터는 존재하지 않습니다. 위 예제에서 주석 처리된 아래의 출력문을 실행시키면 다음과 같은 컴파일 오류를 만나게 될 것입니다. ['Global symbol "$email" requires explicit package name at ....'](https://perlmaven.com/global-symbol-requires-explicit-package-name)

다시 말해 <b>my로 선언된 모든 변수는 블록 영역 안에만 존재</b>합니다.

## 블록 전에 선언된 경우

아래 코드에서 변수 `$lname`은 코드 맨 앞에 선언되었습니다. 이제 이 변수는 이 파일내에서 어디에서건 접근할 수 있습니다. 심지어는 새로운 블록 안에서도 접근이 가능하며 그 블록이 함수 선언이라고 해도 문제가 되지 않습니다. 만약 블록 전에 선언된 변수의 값을 블록 안에서 변경한다면 블록의 끝과 상관없이 해당 변경이 남은 코드에 반영됩니다.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $lname = "Bar";
print "$lname\n";        # Bar

{
    print "$lname\n";    # Bar
    $lname = "Other";
    print "$lname\n";    # Other
}
print "$lname\n";        # Other
```


## 블록 속에서 다시 선언된 경우

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname = "Foo";
print "$fname\n";        # Foo

{
    print "$fname\n";    # Foo

    my $fname  = "Other";
    print "$fname\n";    # Other
}
print "$fname\n";        # Foo
```
이 경우에도 `$fname` 변수가 코드의 서두에 선언되어있습니다. 앞서 살펴본 것 처럼 `$fname` 변수는 파일 안에서 어디서나 접근이 가능합니다. 하지만 <b>만약에 블록 영역에서 동일 이름의 변수를 지역적으로 선언할 경우 이미 선언된 변수는 잠시 감춰지고 새롭게 선언한 내용이 해당 블록 영역 안에서 보이게 됩니다.</b>

블록 안에서 이미 밖에 선언된 변수와 동일한 이름의 변수를 `my` 로 선언하면 그 변수는 이전 변수는 잠시 감춰지고 새롭게 정의한 변수는 블록이 끝날때까지 유효합니다. 닫는 중괄호를 만나 블록이 끝나면, 블록 안에서 정의되었던 `$fname` 변수는 사라지고 먼저 선언되었던 `$fname` 변수가 다시 연결됩니다. 이 특성은 우리가 이미 선언된 변수를 침범할 가능성에 대해서 걱정할 필요없이 손쉽게 제한된 영역에 새로운 변수를 선언할 수 있기 때문에 아주 중요합니다.

## 분리된 블록 영역

분리된 블록영역에서 새롭게 정의된 변수는 서로 영향을 주지 않기 때문에 얼마든지 같은 이름으로 선언할 수 있습니다.

```perl
#!/usr/bin/perl
use strict;
use warnings;

{
    my $name  = "Foo";
    print "$name\n";    # Foo
}
{
    my $name  = "Other";
    print "$name\n";    # Other
}
```

## 파일에서 package 선언

이번 예제는 조금 심화된 내용이지만, 많은 사람이 변수의 영역과 관련해 쉽게 착각하는 내용이기 때문에 특별히 여기서 다룹니다.

Perl에서는 단일 파일 안에서도 `package` 예약어를 통해서 <b>이름공간</b>들을 변경할 수 있습니다. 우리는 일견 package로 이름 공간을 변경하면 변수 영역이 구분될 것으로 추측하기 쉽습니다. 하지만 예상과는 다르게 패키지 선언은 <b>변수영역을 분리하지 않습니다</b>. 위 예제를 살펴보면 서두에 선언한 `$fname`은 묵시적으로 선언된 <b>main 패키지</b> 이름 영역에 존재합니다. 이 변수는 이 파일 안에 정의된 다른 이름 공간에서도 접근 가능합니다.

만약 `$lname` 변수가 'Other' 이름영역에서 선언된다면, 마찬가지로 이 변수도 선언된 시점 이후로 접근 가능하며 다시 `main` 이름 공간으로 전환해도 마찬가지로 접근 가능합니다. 우리가 기대하는 이름 공간의 분리는 `Other 패키지`를 다른 <b>파일</b>에서 선언했을 때 일어납니다.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my $fname  = "Foo";
print "$fname\n";    # Foo

package Other;
use strict;
use warnings;

print "$fname\n";    # Foo
my $lname = 'Bar';
print "$lname\n";    # Bar


package main;

print "$fname\n";    # Foo
print "$lname\n";    # Bar
```