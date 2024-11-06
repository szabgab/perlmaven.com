---
title: "Perl에서 경고메시지를 가로채어 저장하기"
timestamp: 2013-05-18T20:00:00
tags:
  - warnings
  - state
  - __WARN__
  - %SIG
  - $SIG{}
  - local 
published: true
original: how-to-capture-and-save-warnings-in-perl
books:
  - advanced
author: szabgab
translator: gypark
---


Perl 스크립트나 모듈을 작성할 때, 항상 경고 출력 옵션(warnings)을 켜 두는 것이 권장되지만,
당신은 당신의 고객들에게 그런 경고들이 보이는 것을 원하지는 않을 것입니다.

한편으로는 코드의 시작 부분에 <b>use warnings</b>를 넣어 안전망을 설치하길 원하겠지만,
한편으로 생각하면 경고문이 고객들의 화면에 나타났을 때, 대부분의 경우 그들은 그 경고문을 가지고
무엇을 해야 할지 모를 것입니다. 당신이 운이 좋다면 그들이 놀라는 정도로 끝나겠지만 만일
운이 나쁘다면 그들이 직접 문제를 해결하려고 할 것입니다...
(지금 다른 Perl 프로그래머들을 떠올리고 있는 건 아닙니다.)

또 한편 당신은 출력되는 경고들을 저장해 두었다가 나중에 분석하고 싶어할지도 모릅니다.


더 나아가서, 다양한 곳에서 `use warnings`도 없고 쉬뱅라인에 `-w`도 쓰지 않은
다수의 Perl 스크립트들이 이미 존재하고 있습니다. 이 코드들에 `use warnings`를 추가하면
무수한 경고문이 생성될 것입니다.

물론 장기적인 해결책은 그 경고문들 모두가 나타나지 않도록 수정하는 것이지만
당장은 무엇을 해야 할까요?

심지어 장기적인 관점에서도, 완전히 버그가 전혀 없는 코드를 만들 수 없는 것과 같이,
당신의 응용프로그램이 절대로 경고문을 띄우지 않을 거라고 확신할 수는 없습니다. 아닌가요?

<b>하지만 경고문이 화면에 출력되기 전에 가로챌 수는 있습니다.</b>

## 시그널

Perl에는 `%SIG`라는 내장 해시가 있고, 이 해시의 각 키는 당신이 사용하는 운영체제에서
제공하는 시그널들의 이름입니다. 이 해시의 각 값은 해당되는 시그널이 도착했을 때
호출되는 서브루틴들입니다(좀 더 구체적으로는, 서브루틴의 레퍼런스들입니다).

운영체제에서 제공하는 표준 시그널 외에, Perl에서는 두 개의 내부 "시그널"이
추가되어 있습니다. 그 중 하나는 `__WARN__`이라 불리고 코드 어딘가에서
`warn()` 함수를 호출할 때 생성됩니다. 다른 하나는 `__DIE__`이며
`die()`를 호출할 때 생성됩니다.

이 기사에서는 이걸 가지고 경고문을 어떻게 다룰 수 있을지 알아보겠습니다.

## 익명 서브루틴

`sub { }`는 익명 서브루틴, 즉 이름은 없고 몸체만 있는 서브루틴입니다.
(지금 든 예에서는 몸체, 즉 블럭마저 비어 있습니다만, 하려는 말이 뭔지는 아셨을 겁니다.)

## 경고를 가로채어서 - 아무 일도 하지 않기

다음과 같은 코드를 추가한다면:

```perl
  local $SIG{__WARN__} = sub {
     # here we get the warning
  };
```

코드 어디에선가 경고가 발생할 때 아무 일도 하지 않도록 할 수 있습니다. 기본적으로 모든 경고를
감춰버리게 되는 겁니다.

## 경고를 가로채어서 - 예외(exception)로 변환하기

다음과 같이 할 수도 있습니다:

```perl
  local $SIG{__WARN__} = sub {
    die;
  };
```

이제는 경고가 발생할 때마다 die()를 호출하게 되고, 이 말은 모든 경고를 예외로 변환한다는 말입니다.

경고 메시지를 보존하고 싶다면 다음과 같이 작성할 수 있습니다:

```perl
  local $SIG{__WARN__} = sub {
    my $message = shift;
    die $message;
  };
```

익명 서브루틴의 첫번째 인자로 (또한 유일한 인자로) 실제 경고 메시지가 전달됩니다.

## 경고를 가로채어 - 로그로 기록하기

중간에서 무언가를 하고자 할 수도 있습니다:

경고를 뜨지 않게 하고 저장해 두었다가 나중에 조사할 수 있습니다:

```perl
  local $SIG{__WARN__} = sub {
    my $message = shift;
    logger($message);
  };
```

logger()는 당신이 구현한 로거라고 가정합니다.

## 로그 남기기

아마도 당신의 응용프로그램에는 이미 로그를 남기는 기능이 있을 겁니다.
만일 없다면, 추가해 넣는 것이 좋을 것입니다.
직접 추가하지 못하더라도, 운영체제가 제공하는 로그 기록 기능을 사용할 수도 있습니다.
Linux에는 syslog가, MS 윈도우에는 이벤트 로거가 있습니다. 다른 운영체제에도
이러한 로그 기록 기능이 내장되어 있을 거라 확신합니다.

우리의 예문에서는 아이디어를 보여주는 차원에서 직접 만든 간단한 logger()를
사용하기로 합니다.

## 경고를 가로채어 로그를 남기는 전체 예제

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;

  local $SIG{__WARN__} = sub {
    my $message = shift;
    logger('warning', $message);
  };

  my $counter;
  count();
  print "$counter\n";
  sub count {
    $counter = $counter + 42;
  }


  sub logger {
    my ($level, $msg) = @_;
    if (open my $out, '>>', 'log.txt') {
        chomp $msg;
        print $out "$level - $msg\n";
    }
  }
```

위 코드는 log.txt 파일에다 다음과 같은 문장을 덧붙일 것입니다:

```perl
  Use of uninitialized value in addition (+) at code_with_warnings.pl line 14.
```

`$counter` 변수와 `count()` 서브루틴은 그저 경고를 생성하기 위한 부분입니다.

## warn 핸들러 안에서 발생하는 경고

다행스럽게도, __WARN__ 핸들러 내부의 코드가 수행되는 도중에는 자동으로 이 핸들러가
비활성화됩니다. 따라서 핸들러 내부에서 발생하는 경고로 인하여 무한 루프에 빠지는 일은
없습니다.

perldoc perlvar에서 __WARN__에 대한 더 상세한 내용을 읽을 수 있습니다.

## 중복 경고 피하기

동일한 경고가 매우 빈번하게 발생하여 로그 파일을 중복된 내용으로 가득 채울 수
있습니다. 캐시와 유사한 기능을 간단히 사용하여 동일한 경고가 중복되는 것을 막을 수
있습니다.

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;


  my %WARNS;
  local $SIG{__WARN__} = sub {
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };

  my $counter;
  count();
  print "$counter\n";
  $counter = undef;
  count();

  sub count {
    $counter = $counter + 42;
  }

  sub logger {
    my ($level, $msg) = @_;
    if (open my $out, '>>', 'log.txt') {
        chomp $msg;
        print $out "$level - $msg\n";
    }
  }
```

보다시피, `$counter` 변수를 `undef`으로 재설정한 후
`count()` 함수를 다시 호출함으로써 동일한 경고를 다시 발생시키고 있습니다.

또한 `__WARN__`을 핸들링하는 서브루틴을 살짝 복잡해진 형태로 수정하였습니다:

```perl
  my %WARNS;
  local $SIG{__WARN__} = sub {
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };
```

로거를 호출하기 전에, 메시지 문자열이 `%WARNS` 해시에 들어있는지를 확인합니다.
들어있지 않다면, 해시에 추가한 후에 logger()를 호출합니다. 이미 들어있다면, 바로 return을
호출하여 이 이벤트가 두 번 이상 기록되는 일이 없도록 합니다.

동일한 아이디어가 
[중복 원소가 없는 배열](/unique-values-in-an-array-in-perl)을
만들려고 할 때 쓰였던 걸 기억할지도 모르겠습니다.

## 이 local은 뭔가요?

위에서 봤던 예제에서, `local` 함수를 사용하여 핸들러의 효과를
지역적으로 한정했습니다. 엄격하게 말하면 이 예제에서는 그럴 필요가 없었습니다.
왜냐하면 핸들러를 등록하는 이 코드가 메인 스크립트의 첫번째 부분으로 들어가 있고,
이 경우 전역 스코프에 적용되어도 효과가 동일하기 때문입니다.

그렇지만, 이런 형태로 쓰는 것에 익숙해지는 게 낫습니다. (제게 지적해 준 Peter Rabbitson에게 감사합니다)

이 코드를 모듈 안에서 사용할 경우, `local`은 우리가 변경한 것이 적용되는 범위를
제한하는 중요한 역할을 합니다. 특히나 당신이 이 코드를 배포할 경우 더욱 중요합니다.
지역화하지 않을 경우 이 변경 효과가 전체 응용프로그램에 적용되어 버릴 것입니다.
`local`은 그 효과가 코드를 감싸고 있는 블럭 안에 국한되도록 제한합니다.

## %WARNS 해시를 전역 변수로 쓰지 않기

Perl 5.10 또는 그 이후 버전을 사용한다면 이 코드를 더 개선하여
전역 변수 %WARNS를 사용하지 않도록 할 수 있습니다.
그러기 위해서는 스크립트 시작 부분에 `use v5.10;`라고 적어 주고,
익명 서브루틴 안에서 `state` 키워드를 사용하여 변수를 선언합니다.

```perl
  #!/usr/bin/perl
  use strict;
  use warnings;

  use v5.10;

  local $SIG{__WARN__} = sub {
      state %WARNS;
      my $message = shift;
      return if $WARNS{$message}++;
      logger('warning', $message);
  };
```

[state 키워드](https://perlmaven.com/what-is-new-in-perl-5.10--say-defined-or-state)에 대해 더 자세한 내용을 읽을 수 있습니다.

(`state`의 사용을 떠올리게 해 준 Joel Berger에게 감사합니다.)

