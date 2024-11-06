---
title: "펄의 패키지, 모듈, 배포본, 네임스페이스"
timestamp: 2015-01-25T12:00:00
tags:
  - package
published: true
original: packages-modules-and-namespace-in-perl
books:
  - advanced
author: szabgab
translator: gypark
---


경험 많은 펄 개발자들은 `패키지`, `모듈`, `배포본`,
`심볼 테이블`, `릴리즈`, `네임스페이스` 등의 용어를
자유롭게 사용합니다. 가끔은 이 단어를 쓸 곳에 저 단어를 대신 쓰기도 합니다.
그러다보면 각 용어들의 차이가 희미해지기도 하며, 그래서 혼동스러울 수도
있습니다. 특히 펄 경력이 10년 미만인 사람들 사이에서 더 그런 경향이 있습니다.

이것들을 명확히 해봅시다.


간단히 설명하자면:

* <b>릴리즈(release)</b>는 보통 CPAN에 (PAUSE를 통해서) 업로드된 압축 파일(tar.gz나 zip)을 의미합니다. 예: Some-Thing-1.01.ta.gz
* <b>배포본(distribution)</b>은 종종 <b>릴리즈</b>와 동일한 의미로 쓰이고, 아니면 어떤 소프트웨어의 모든 릴리즈 버전을 통틀어 가리키기도 합니다.
* <b>네임스페이스(namespace)</b>는 식별자(변수나 함수들)를 담는 컨테이너입니다. 네임스페이스는 Some::Thing의 형식으로 되어 있습니다.
* <b>심볼 테이블(symbol-table)</b>은 어떤 네임스페이스의 식별자들이 저장되어 있는 장소입니다. 기본적으로는 <b>심볼 테이블</b>을 <b>네임스페이스</b>와 동등하게 생각할 수 있습니다.
* <b>패키지(package)</b>는 펄에서 새로운 네임스페이스로 전환하게 하는 키워드입니다. 때때로 어떤 <b>배포본</b>의 특정한 <b>릴리즈</b>를 가리켜서 <b>패키지</b>라고 하기도 하지만, 이것은 어떤 <b>릴리즈</b>에 속한 파일들을 하나의 파일로 압축할 때 영어 단어 <b>package(포장)</b>을 떠올리기 때문입니다.
* <b>모듈(module)</b>은 어떤 패키지(네임스페이스)의 이름이며, 그 이름에 해당하는 파일에 저장되어 있습니다. (Some/Thing.pm 파일 안에 저장된 Some::Thing 패키지(네임스페이스)가 모듈입니다.) 하지만 "모듈"이라고 말할 때 전체 배포본을 가리키는 경우도 있습니다.

## 상세한 내용

펄 코드는 모든 부분이 어떤 네임스페이스에 속해 있습니다. 다음과 같은 간단한 스크립트를 실행해도:

```perl
use warnings;

$x = 2;
```

[Name "main::x" used only once: possible typo at ... line ...](/name-used-only-once-possible-typo)와
같은 경고가 뜹니다.

저 경고 메시지에 있는 `main`이 현재 스크립트의 네임스페이스이며, 따라서 현재
변수의 네임스페이스이기도 합니다. 저 네임스페이스는 묵시적으로 지정되었습니다.
따로 명시해 주지 않는 이상은 자동으로 `main` 네임스페이스에 속하게 됩니다.

물론 우리는 [언제나 use strict를 써야 한다](/strict)는 것을 압니다.
그러니 코드에 추가하겠습니다:

```perl
use strict;
use warnings;

$x = 2;
```

이제는 [Global symbol "$x" requires explicit package name at ... line ...](/global-symbol-requires-explicit-package-name)라는 에러가 뜹니다.
이 에러 메시지에는 `package`라는 단어가 나옵니다.
이 에러는 보통은 우리가 변수를 쓰기 전에 `my`로 선언하지 않았다는 것을
알려줍니다만, 실제 에러 메시지를 보면 의미가 다소 다릅니다. 역사적인 이유로,
저 에러는 변수를 사용하는 또다른 방법을 알려주고 있습니다. 그 방법이라는 것은
이 변수가 속한 패키지(네임스페이스)의 이름을 명시하는 것입니다.

다음과 같이 쓰면 잘 동작합니다:

```perl
use strict;
use warnings;

$main::x = 42;
print "$main::x\n";  # 42
```


```perl
use strict;
use warnings;

my $x = 23;
$main::x = 42;

print "$main::x\n";  # 42
print "$x\n";        # 23
```

이것은 매우 혼란스럽습니다. `$x`라는 변수가 두 개 있는 걸로 보입니다.
실제로 이 두 변수는 서로 다른 변수입니다. `$main:x`는 
[패키지 변수](https://perlmaven.com/package-variables-and-lexical-variables-in-perl)이고,
`$x`는 [렉시컬 변수](https://perlmaven.com/package-variables-and-lexical-variables-in-perl)입니다.

대부분의 경우는 `my`로 선언한 렉시컬 변수를 사용하며, 네임스페이스는
함수들을 구분할 때만 씁니다.

## package 키워드를 사용하여 네임스페이스 전환 - 함수의 경우

```perl
use strict;
use warnings;
use 5.010;

sub hi {
    return "main";
}

package Foo;

sub hi {
    return "Foo";
}

say main::hi();   # main
say Foo::hi();    # Foo
say hi();         # Foo

package main;

say main::hi();   # main
say Foo::hi();    # Foo
say hi();         # main
```

이 코드에서는 `package` 키워드를 사용하여 기본 네임스페이스인 `main` 네임스페이스에서
`Foo` 네임스페이스로 전환하고 있습니다.
두 네임스페이스에 각각 `hi()` 함수가 정의되었습니다. 각 함수는 자신이 속한
네임스페이스의 이름을 반환합니다.

그 다음 이 함수들을 세 번 호출합니다. 함수 이름 전체가 적혔을 때는 출력은 그 함수의
이름에 맞추어 나옵니다. `main::hi()`는 언제나 "main"을 반환하고,
`Foo::hi()` 함수는 언제나 "Foo"를 반환합니다.
네임스페이스 부분을 생략하고 `hi()`를 호출할 경우는, 현재 네임스페이스에 속한
함수를 호출하게 됩니다. 처음 `hi()`를 호출할 때는 "Foo" 네임스페이스가 현재의 네임스페이스였고,
따라서 "Foo"가 반환됩니다. 그 다음 다시 `package main;`를 써서 "main" 네임스페이스로
다시 전환하였고, 여기서 `hi()`를 호출하면 "main"이 반환됩니다.

## 네임스페이스(패키지)와 모듈

`package` 키워드를 하나의 파일 안에서 몇 번이든 사용하여 여러 개의 네임스페이스를
생성할 수 있습니다만, 이것은 아무래도 혼동을 야기하게 됩니다. 따라서 권장되지 않습니다.
(특별한 경우에나 사용됩니다.)

심지어 [Perl::Critic](https://metacpan.org/pod/Perl::Critic)의 정책 중에는
[Modules::ProhibitMultiplePackages](https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitMultiplePackages)가 있어서
이런 경우를 감지해 알려주기도 합니다. 다음과 같이 사용할 수 있습니다:

```
$ perlcritic --single-policy Modules::ProhibitMultiplePackages script.pl 
Multiple "package" declarations at line 19, column 1.  Limit to one per file.  (Severity: 4)
```

[한 번에 한 가지 정책씩 검사하기](https://perlmaven.com/perl-critic-one-policy)도
읽어보세요.

여기서는 <b>Foo</b> 네임스페이스를 foo.pl 파일에 옮기고, `require`를 써서 불러올 수 있습니다.
하지만 이것은 구식 방법이며, 파일의 경로를 알려주어야 해서 불편합니다.
그보다는 <b>Foo</b> 네임스페이스의 코드를 `Foo.pm` 파일에 옮기는 것이
훨씬 낫습니다.

메인 스크립트는 다음과 같이 구성됩니다:

```perl
use strict;
use warnings;
use 5.010;

sub hi {
    return "main";
}

use Foo;

say main::hi();   # main
say Foo::hi();    # Foo
say hi();         # main
```

Foo.pm은 다음과 같이 작성합니다:

```perl
package Foo;
use strict;
use warnings;
use 5.010;

sub hi {
    return "Foo";
}

say main::hi();   # main
say Foo::hi();    # Foo
say hi();         # Foo

1;
```

눈여겨 볼 부분은
메인 스크립트에는 (hi 서브루틴 정의 다음 부분에) `use Foo;` 구문이 쓰이고 있고,
Foo.pm의 윗부분에는 통상의 use 구문들이 있으며, Foo.pm의 마지막에는 
`1;`이라는 라인이 추가되었다는 것입니다.

Foo.pm 파일 안에서 `package` 키워드를 사용하여 "Foo" `네임스페이스`를
정의하고 있는 것을 `모듈`이라고 부릅니다.

## 경고

`use Foo;` 구문이 Foo.pm 파일을 찾으려면 이 파일이 `@INC` 배열에 들어있는
디렉토리들 중 한 곳에 있어야 합니다.
가장 간단하게는 Foo.pm 파일을 `현재 작업 디렉토리`, 즉 스크립트를 실행하는 시점에
우리가 작업을 하고 있던 그 디렉토리에 두면 됩니다.
파일을 찾지 못하면 
[Can't locate Foo.pm in @INC (you may need to install the Foo module) (@INC contains: ...](/cant-locate-in-inc)
에러가 나며, 이를 해결하기 위해서는
[@INC의 값을 변경](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)해야
됩니다.

이 예문은 다소 억지로 꾸미다보니, `use Foo;` 구문이 메인 스크립트에서
`sub hi`를 정의한 부분보다 뒤에 와야만 합니다. 그래야 Foo.pm 파일이 로드될 때
그 안에서 `main::hi()`를 호출하는 부분이 제대로 수행됩니다.
만일 `use` 구문을 `sub hi` 정의보다 먼저 쓴다면 다음과 같은
런타임 예외가 발생할 것입니다:

```
Undefined subroutine &main::hi called at Foo.pm line 10.
Compilation failed in require at script.pl line 5.
BEGIN failed--compilation aborted at script.pl line 5.
```

