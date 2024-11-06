---
title: "Perl에서 큐 사용하기"
timestamp: 2013-05-20T18:00:00
tags:
  - push
  - shift
  - queue
  - array
  - last
  - FIFO
published: true
original: using-a-queue-in-perl
books:
  - beginner
author: szabgab
translator: gypark
---


큐를 유용하게 사용할 수 있는 다양한 응용프로그램들이 있습니다.

예를 들어 각 디렉토리 안에 서브디렉토리들이 존재하는 복잡한 디렉토리 구조를
다루어야 할 때가 있습니다.

빌드 시스템을 다루는데 각 유닛들은 의존성 목록이 있고 당신은 모든 의존성 트리를
순회할 필요가 있을지 모릅니다.

좀 덜 고통스러운 예를 든다면, 치과 진료를 기다리는 환자들을 다루는 대화형
응용프로그램을 작성하고 있을지도 모릅니다.

어느 경우에나, 큐를 사용하면 정말 멋지게 동작할 것입니다.


## 큐란 무엇인가?

큐는 기본적으로 아이템들의 리스트입니다. 새 아이템이 들어올 때는 리스트의 마지막에 추가됩니다.
큐가 "앞으로 전진"할 때, 리스트의 첫번째 아이템이 제거되고 나머지 아이템 전부는 "앞으로 이동"합니다.

컴퓨터 과학 분야에는 다양한 표준 자료 구조들이 있습니다. 큐를 추상적으로 기술한다면
[FIFO - 선입선출(First In First Out)](http://en.wikipedia.org/wiki/FIFO)
이라고 할 수 있습니다.
큐에 첫번째로 들어온 것이 첫번째로 나갈 것입니다.

Perl에서는, 통상적인 배열에 `push`와 `shift` 함수를 사용하여 큐를 구현할 수 있습니다.
이 함수들에 대해 다시 보고 싶다면 [push와 shift에 관한 기사](https://perlmaven.com/manipulating-perl-arrays)를
확인하세요.

예를 보겠습니다:

```perl
#!/usr/bin/perl
use strict;
use warnings;

my @people = ("Foo", "Bar");
while (@people) {
    my $next_person = shift @people;
    print "$next_person\n"; # do something with this person

    print "Type in the names of more people:";
    while (my $new = <STDIN>) {
        chomp $new;
        if ($new eq "") {
            last;
        }
        push @people, $new;
    }
    print "\n";
}
```

여기서는 `@people` 배열을 사용하여 큐를 유지합니다. 처음에 두 개의 원소가 있습니다.
이후 큐를 다루는 부분은 모두 [while 루프](https://perlmaven.com/while-loop) 안에 있습니다.
이 루프는 큐에 이름이 들어 있는 동안 반복됩니다.

(혹시 모르실지 몰라서 말씀드리자면, `while ()` 루프의 조건과 같은
[스칼라 컨텍스트](https://perlmaven.com/scalar-and-list-context-in-perl)에서
사용될 경우, 배열은 자신의 크기, 즉 현재 들어 있는 원소의 갯수를 반환합니다.
배열이 비었다면 이 값은 0이 될 테고 0은 [거짓](/boolean-values-in-perl)으로
간주됩니다. 원소가 있다면 배열의 크기는 양수가 되고 Perl에서 이것은
[참](/boolean-values-in-perl)으로 간주됩니다.)

루프 안에서 첫번째로 하는 일은 `shift` 함수를 사용하여 큐에서 첫번째 원소를 가져오는
것입니다. 이 원소는 치과의사에게 진료를 받을 다음 환자의 이름입니다. 그 다음 하는 일은
`진료($next_person);`여야겠지만, 일단 여기서는 단지 이름만 출력하도록 했습니다.

진료가 끝나면 큐에 추가할 대기자가 있는지 확인해야 합니다.
여기서는 또다른 `while` 루프를 사용하여 구현하였습니다.
사용자가 이름을 하나씩 입력하는 동안 기다립니다.
입력 뒤에 붙은 뉴라인 문자를 제거하고, 입력이 빈 문자열인지 아닌지를 확인합니다.
입력이 비었다면, 사용자가 아무 이름도 넣지 않고 ENTER를 눌렀다는 뜻이고, 그러면
`last`를 호출합니다. 그러면 안쪽 루프를 종료하고 `print "\n";` 행을 수행하게
됩니다. 그러고나면 다음 환자를 진료하는 바깥쪽 `while 루프`의 시작 부분으로 되돌아갑니다.
만일 사용자가 어떤 이름을 입력했다면, 그 이름이 `@people` 배열의 끝에 <b>push</b>되며,
이는 큐의 뒷부분에 추가된다는 얘기입니다. 이후 안쪽 루프에서 다시 다른 이름이 입력되기를 기다릴
것입니다.

진료할 수 있는 속도보다 더 많은 환자가 오고 있다면 큐는 점점 자라날 것입니다.
그러나 일정 시간동안 아무도 오지 않는다면, 큐에 있는 환자 모두를 진료하게 되고,
배열이 비었을 때 메인 while 루프는 종료될 것입니다.

## 추상화된 구현

다음 코드는 아직 구현되어 있지는 않은
[함수들](https://perlmaven.com/subroutines-and-functions-in-perl)을
사용하여 같은 코드를 좀 더 추상적으로 만들어본 것입니다.

```perl
#!/usr/bin/perl
use strict;
use warnings;

my @queue = accept_new_to_queue();
while (@queue) {
    my $next_item = shift @queue;
    handle_item($next_item);

    push @queue, accept_new_to_queue()
}

sub accept_new_to_queue {
    ...
}
sub handle_item {
    ...
}
```


## 병렬(parallel) 처리 또는 비동기(asynchronous) 처리

위 구현은 간단한 경우에는 잘 동작하겠지만, 큰 문제점이 있습니다.
`accept_new_to_queue()`와 `handle_item()`이 블로킹(blocking) 함수라는 점입니다.
다시 말해서, 어떤 아이템을 처리하는 동안은 큐에 다른 아이템들을 넣을 수 없습니다.
디렉토리 트리나 의존성 목록을 처리하는 경우는 괜찮겠지만, 치과에서 환자 한 명이
진료를 받고 있는 동안에 도착한 다른 사람들은 대기실에조차 들어갈 수 없다면 그들은
당황스러워할 것입니다.

따라서 `accept_new_to_queue()`와 `handle_item`이 <b>"가상적으로는 동시에"</b>
수행될 수 있도록 병렬적 또는 비동기적으로 일을 처리할 방법이 필요합니다.
가상적으로라고 쓴 이유는 정말로 두 함수가 동시에 실행될 필요는 없기 때문입니다.
그저, 마치 그런 것처럼 보이기만 하면 됩니다.

최신 컴퓨터들과 같은 멀티 CPU 또는 하다못해 멀티 코어 시스템이라면,
이론적으로는 코드의 여러 부분을 정말로 동시에 병렬적으로 수행할 수 있을 것입니다.
이를 위한 두 개의 주된 해결책은 <b>스레딩(threading)</b>과 <b>포킹(forking)</b>입니다.
많은 프로그래밍 언어에서 스레딩이 더 선호되지만, Perl에서는 많은 이들이 포킹을 사용합니다.
이렇게 하려면, CPAN에서 [Parallel::ForkManager](https://metacpan.org/pod/Parallel::ForkManager)
모듈을 살펴보셔야 할 겁니다.

비동기 또는 이벤트-드리븐 Perl 프로그래밍을 위해서는,
[POE](https://metacpan.org/pod/POE)를 살펴보시는 게 좋을 겁니다.

다른 기사에서, 각 경우에 대한 예를 살펴보도록 하겠습니다.


