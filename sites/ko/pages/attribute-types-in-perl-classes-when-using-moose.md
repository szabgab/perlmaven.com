---
title: "Moose에서의 속성값 자료형"
original: attribute-types-in-perl-classes-when-using-moose
timestamp: 2015-07-24T06:13:10
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
  - attribute
published: true
books:
  - advanced
  - moose
author: szabgab
translator: johnkang
---


간단한 펄 스크립트에서 우리는 보통 변수의 자료형에 대해서 크게 신경 쓰지 않습니다.
그렇지만 프로그램은 계속 커져가기 때문에 자료형 시스템(type system)은 프로그램의
정확도를 증가 시킬수 있습니다.

Moose는 여러분에게 각 속성들의 자료형을 정의 하게 하고 설정자(setter)를 통해 강요 되어 집니다.


Moose의 첫번째 연재
[Moose를 사용한 객체 지향 펄](/object-oriented-perl-using-moose),
의 다음으로 여러분은 Moose의 자료형확인시스템에 익숙해 지는것이 좋을것 입니다.

## Int 자료형 설정

아래는 우리의 첫번째 예제 입니다:

```perl
use strict;
use warnings;
use v5.10;

use Person;

my $student = Person->new( name => 'Joe' );
$student->year(1988);
say $student->year;
$student->year('23 years ago');
```

Person 모듈(클래스)을 로딩한 후 클래스의 "new" 생성자를 호출함으로써 $student 객체를
생성 합니다.
그런다음 "year" 접근자(accessor)를 호출하고 값을 1988로 설정 합니다. 값을 출력한 후
값을 "23 years ago"로 설정 하려고 합니다.

이 모듈에는 2개의 속성이 있습니다. "year" 속성은 `Int` 자료형의 `isa` 항목을
가지고 있습니다. 이때문에 Moose가 생성한 설정자는 값의 자료형을 정수로 제한 할 것입니다.

```perl
package Person;
use Moose;

has 'name' => (is => 'rw');
has 'year' => (isa => 'Int', is => 'rw');

1;
```

위의 모듈을 "somedir/lib/Person.pm" 에 저장하고 스크립트를 "somedir/bin/app.pl" 에 저장합니다.
그리고 "somedir" 디렉토리 내에서 "perl -Ilib bin/app.pl" 과 같이 실행 합니다.

1988을 출력한 이후 아래의 에러를 확인하게 됩니다.

```
Attribute (year) does not pass the type constraint because:
   Validation failed for 'Int' with value "23 years ago"
       at accessor Person::year (defined at lib/Person.pm line 5) line 4
   Person::year('Person=HASH(0x19a4120)', '23 years ago')
       called at bin/app.pl line 13
```

이 에러 메세지는 Moose가 문자열 "23 years ago"를 정수형 자료로써 허용하지 않았다는 것을 나타냅니다.

## 자료형 제한으로써 또 다른 클래스

[default type constraints](https://metacpan.org/pod/Moose::Util::TypeConstraints#Default-Type-Constraints) 외에도
Moose는 어떠한 클래스라도 자료형 제한으로써 사용 할 수 있습니다.

예를 들자면 "birthday" 속성은 반드시 DateTime 객체가 되게끔 선언 할수 있습니다.

```perl
package Person;
use Moose;

has 'name'     => (is => 'rw');
has 'birthday' => (isa => 'DateTime', is => 'rw');

1;
```

아래의 예제를 실행 해보세요.

```perl
use strict;
use warnings;
use v5.10;

use Person;
use DateTime;

my $student = Person->new( name => 'Joe' );
$student->birthday( DateTime->new( year => 1988, month => 4, day => 17) );
say $student->birthday;
$student->birthday(1988);
```

보시는 바와 같이 첫번째 "birthday" 설정자의 호출은 괄호안에서 생성된 DateTime 객체를
취합니다. 문제 없이 잘 동작합니다. 두번째 호출에서는 1988의 값을 전달 받고 위에서 보았던
에러와 유사한 예외상황이 발생 됩니다.

```
Attribute (birthday) does not pass the type constraint because:
    Validation failed for 'DateTime' with value 1988
       at accessor Person::birthday (defined at lib/Person.pm line 5) line 4
    Person::birthday('Person=HASH(0x2143928)', 1988)
       called at bin/app.pl line 14
```

