---
title: "Can't locate ... in @INC"
timestamp: 2013-08-19T01:00:00
tags:
  - warnings
  - @INC
published: true
original: cant-locate-in-inc
books:
  - beginner
author: szabgab
translator: gypark
---


Perl을 쓰면서 흔히 보게 되는 컴파일 에러 중 하나는 다음과 같은 것입니다:
`Can't locate Acme/NameX.pm in @INC (@INC contains: ... )`

Perl 버전 5.18부터는 다음과 같이 나올 것입니다:

`Can't locate Acme/NameX.pm in @INC (you may need to install the Acme::NameX module) (@INC contains: ... )`

매우 필요했던 개선이고, 사람들에게 올바른 방향을 제시해줄 것입니다.


경험 많은 펄 개발자들은 이게 무엇을 뜻하는지 이미 알고 있지만 경험이 적거나 없는 분들은
이해하지 못할 수 있습니다. 특히나 보통은 ... 자리에 디렉토리들의 목록이 길게 나열되어 있기
때문에 이런 어지러운 내용들 속에서 중요한 부분을 놓치게 됩니다.

이 에러가 의미하는 것은 여러분의 코드가 Acme::NameX 모듈을 로드하려고 했으나, 그것을
찾을 수 없었다는 것입니다.

여러분은 아마도 코드 어딘가에 `use Acme::NameX`나 `require Acme::NameX`를
넣었을 것입니다.

이 모듈을 로드하기 위해서, Perl은 `@INC`라 불리우는 Perl에 내장된 배열에 나열된
디렉토리들을 뒤지게 됩니다. 각 디렉토리에서 펄은 Acme라는 서브디렉토리가 있는지 찾아보고
그 서브디렉토리 안에 NameX.pm 파일을 찾게 됩니다.

그 파일을 찾을 수 없다면, 위와 같은 에러를 냅니다.

## 어째서 Perl이 모듈을 찾을 수 없는가?

모듈 이름에 오타가 났거나
(예를 들어 이번 경우에 모듈 이름이 Acme::Name이었을 수 있습니다),
Acme::Name 모듈이 설치되지 않았을 수 있습니다.

또한 모듈의 이름은 대소문자를 구분하는 것에 주의하세요.
따라서 여러분이 `use acme::name`라고 썼다면 Acme::Name 모듈을 찾지 못할 것입니다.
(윈도우에서는 찾을지 모르지만 그래도 제대로 동작하지 않을 것입니다)

지금 막 모듈을 설치했다면, 기본 경로가 아닌 곳에 설치되었거나, 설치에 실패한 것일 수도
있습니다.

여러분이 할 수 있는 것은 모듈을 설치할 때 나왔던 출력을 살펴보는 것입니다.
출력이 남아있지 않다면, 설치를 다시 시도해보면서 출력을 유심히 보도록 하세요.

출력에는 어느 부분에서 설치를 실패하는지, 만일 성공적으로 설치되었다면 어느 디렉토리에
설치되었는지 나올 것입니다.

그런 다음 설치된 장소가 `@INC`에 나열된 디렉토리들 중 하나인지 살펴봅니다.
@INC의 디렉토리 목록은 명령행에서 `perl -V`라고 입력해서 볼 수 있습니다.

만일 어떤 이유에서인지 기본 디렉토리가 아닌 곳에 모듈이 설치되었다면 여러 가지 방법으로
[@INC 배열을 변경](/how-to-change-inc-to-find-perl-modules-in-non-standard-locations)할
수 있습니다.

반면에 그 모듈이 여러분의 응용프로그램의 일부라면, 여러분은
[@INC를 스크립트 위치를 기준으로 상대 경로로 변경](https://perlmaven.com/how-to-add-a-relative-directory-to-inc)(pro 기사)하고자 할 수도 있습니다.

## Can't locate warning.pm in @INC

이런 에러 메시지의 아주 특별한 케이스는 Perl이 <b>warning</b> 모듈을 찾지 못하는 경우입니다.
(많은 사람들이 이걸 모듈이라 부르지 않고 프라그마라고 부릅니다만)

```
Can't locate warning.pm in @INC ...
```

이 아주 특별한 케이스를 저는 Perl을 초심자분들에게 가르칠 때 종종 보게됩니다. 제가 처음 가르치는 것은
언제나 `use warnings;`를 스크립트의 처음에 추가하라는 겁니다. 불행하게도 많은 경우
사람들은 끝에 <b>s</b>를 빼먹고 `use warning;`라고 작성합니다. 결국 간단한 오타의 문제입니다.

