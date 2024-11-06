---
title: "Moose를 사용한 객체 지향 펄"
original: object-oriented-perl-using-moose
timestamp: 2015-07-24T01:45:00
tags:
  - OOP
  - Moose
  - object oriented
  - class
  - object
  - instance
  - constructor
  - getter
  - setter
  - accessor
published: true
books:
  - moose
author: szabgab
translator: johnkang
---


앞으로 펄에서 어떻게 객체지향 프로그래밍을 하는지 소개 하려 합니다.
간단한 예제를 통해 시작 할것이며 하나씩 하나씩 확장해 나가려 합니다.
처음은 Moose를 사용 하지만 다른 방법으로 클래스를 생성하는법도 배우게 될 것입니다.


## Moose의 생성자

Person `클래스`를 사용하는 간단한 스크립트를 작성하면서 시작해 보겠습니다.
아직 어떤 특별한것도 하지 않았습니다. 단지 모듈을 로딩하고 `인스턴스`를 생성하기위해
`생성자(constructor)`를 호출 하였습니다.

```perl
use strict;
use warnings;
use v5.10;

use Person;
my $teacher = Person->new;
```

somedir/bin/app.pl 에 저장 하세요

여러분이 위와 같은 방법으로 이미 다른 모듈들을 사용해 본적이 있기 때문에
위의 코드가 새롭지는 않을것 입니다. 우리의 초점은 어떻게 Person 클래스가
구현 되었느냐 입니다.

```perl
package Person;
use Moose;

1;
```

이게 전부 입니다.

이 코드는 somedir/lib/Person.pm 에 저장되어 있습니다.

`클래스`를 생성하기 위해 필요한 것은 클래스 이름을 이용하여 `package`를
생성하는 것입니다. 그리고 `use Moose;` 라인을 추가하고
파일의 마지막에 참 값을 적어주고 package 이름과 동일한 .pm 확장자를
가진 파일을 생성하면 됩니다(대소문자 구분).

Moose를 로딩하면 `use strict` 와 `use warnings` 이 자동으로 설정 됩니다.
편리해 보이지만 Moose를 이용한 코딩이 아닐때 이 두 플라그마의 설정을 빼먹을 수도 있기
때문에 주의 해야 합니다.



Moose를 로딩하면 `new` 라는 기본 생성자가 자동으로 추가 됩니다.

As a side note, it is not a requirement in Perl that the constructor will be called
new, but in most cases that's what the author chooses anyway.
참고로, 펄에서 생성자는 반드시 new 일 필요는 없습니다.
그렇지만 어쨋든 모듈 저자들이 많이 사용하는 방법 입니다.

## 속성(attribute)과 접근자(accessor)

비어 있는 클래스는 그다지 흥미롭지 않습니다.
좀 더 살을 붙여 보겠습니다.

```perl
use strict;
use warnings;
use v5.10;

use Person;
my $teacher = Person->new;

$teacher->name('Joe');
say $teacher->name;
```

이 코드에서는 `객체(object)` 를 생성한 뒤, 문자열을 파라미터로 취하는 "name" `메소드` 를
호출 하였습니다. 이는 이름이 'Joe'가 되는 클래스의 "name" `속성`을 설정 하는것 입니다.
이 메소드는 각각의 속성을 설정 하기 때문에 `설정자(setter)` 라고 불립니다.

그런다음 같은 메소드를 다시 호출합니다. 이번엔 어떤 인자도 전달 되지 않았습니다.
이는 이전에 저장된 값을 가져옵니다. 이 메소드는 값을 획득하기 때문에 `획득자(getter)` 라고 불립니다.

이경우엔 `획득자`와 `설정자`는 같은 이름을 가지고 있지만
이 둘은 같은 필요는 없습니다.

일반적으로 `획득자`와 `설정자`는 `접근자` 라고 불립니다.

다음은 새로운 클래스를 구현하고 있습니다:

```perl
package Person;
use Moose;

has 'name' => (is => 'rw');

1;
```

새로운 부분인 `has 'name' => (is => 'rw');` 는 

"Person 클래스는 `has(가지다)` `'name'`라 불리는 속성을
그것 `is(은)` `r`읽을수 있고 `w`쓸수 있는"

이는 설정자(쓰기)와 획득자(읽기) 둘다 사용 가능한   "name" 이라 불리는 메소드를
자동으로 생성 합니다.

## 코드 실습

실습을 위해 "somedir" 이라는 이름의 디렉토리를 생성하고 그 안에 "lib" 이라는 서브디렉토리를
생성합니다. "bin" 이라는 이름의 서브디렉토리 또한 생성 하고 person.pl 의 이름으로 스크립트를 생성합니다.

여러분은 이제 아래와 같은 파일을 가지게 됩니다.

```
somedir/lib/Person.pm
somedir/bin/person.pl
```

터미널(Windows에서는 cmd)을 열고, "somedir"로 이동한 다음
`perl -Ilib bin/person.pl`를 입력 합니다.

(MS Windows에서 실습하는 독자는 아마도 역슬래쉬: \ 를 사용해야 할 수도 있습니다.)

## 생성자 파라미터

다음 스크립트에서는 키-값 쌍을 생성자에 전달 합니다.
속성의 상응 하는 이름과 그에 상응하는 값 입니다.

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $teacher = Person->new( name => 'Joe' );
say $teacher->name;
```

이 코드도 이미 우리가 작성한 모듈과 잘 동작합니다.

이렇게 Person 모듈의 아무런 수정없이, 생성자를 사용하여 속성에 초기값을
설정 할 수 있습니다.

Moose는 객체가 생성되는 동안 모든 `member`(속성의 또다른 이름) 가 전달되는것을
자동적으로 수용 합니다.

