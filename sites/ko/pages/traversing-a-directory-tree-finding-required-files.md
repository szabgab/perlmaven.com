---
title: "디렉토리 트리를 순회하면서 필요한 파일들 찾기"
timestamp: 2013-08-06T02:00:00
tags:
  - File::Find::Rule
  - map
published: true
original: traversing-a-directory-tree-finding-required-files
author: szabgab
translator: gypark
---


며칠 전 한 독자분이 제게 요청한 것을 여러분과 공유하고 싶습니다. 일단 제가 받은 이메일을
보여드리고, 문제를 정리하고, 코드를 좀 살펴본 다음 해결책을 제시하도록 하겠습니다.

개인 정보 보호를 위해서 그 분의 성함을 Foo Bar로 바꾸었습니다.


## 요구사항: 폴더들 속에서 파일을 찾아라

Gabor씨 안녕하세요,

저는 Perl 초보입니다. 저는 윈도우 플랫폼에서 디렉토리와 서브디렉토리에서 파일들을 검사하고
싶습니다. 어떻게 할 수 있을지 설명해주시겠습니까?

폴더 구조는 다음과 같습니다. 각 폴더에는 .pdf 파일들이 들어 있습니다.
제게는 pdf 파일 목록이 있고, 이 파일들이 dir1과 그 서브디렉토리들 안에 있는지 체크하고 싶습니다.

```
                                dir1
                                 |
                                 |
                  -----------------------------------------------
                  |           |            |         |          |
                 dir2        dir3         dir4      dir5       dir6
                  |                        |
                  |                        |
       ----------------------         -------------- 
       |                    |         |            |
     dir7                  dir8      dir9         dir10
```

현재 저는 모든 pdf 파일을 별개의 폴더에 직접 복사한 후 아래의 스크립트를 사용하여 검사하고 있습니다만,
수작업을 하지 않고 메인 폴더에서 검색할 수 있었으면 좋겠습니다.

답장 부탁드리겠습니다. 감사합니다.

제가 사용하던 스크립트입니다:

```perl
print "Enter the file name:";
my $file=<>;
chomp($file);

open(OUT,$file) || die ("Could not open $file file.");

open(MYOP,">final.txt") || die ("Could not open $data file.");

print MYOP "Below files are not exist in the Dir:\n";

while ( $myfile = <OUT> )
{
print "Your File is:$myfile\n";

my $name = "C:/Users/foobar/files/$myfile";

#print "Full Path is $name\n";

chomp($name);
if ( -e "$name" )

#if ( -e "$file" )
{
    print "File exists!\n";
}
else
{
    chomp($myfile);
    print MYOP $myfile."\n"
}
}
```


----
안녕히 계세요

   Foo Bar

## 문제 이해하기

제일 먼저, 디렉토리 구조를 아스키 아트로 만들어낸 것과 이미 동작하고 있는 스크립트를 적어준 것에
대해 Foo Bar씨를 칭찬해야 할 것 같습니다. 그 스크립트에는 문제점들이 있긴 하지만요. 많은 사람들이
문제를 직접 해결하려는 노력 없이 질문을 하고는 합니다. 많은 경우에는 심지어 문제를 이해하지도
못한 상태로 말이죠.

여기 보면 여러 파일들의 목록이 적힌 입력 파일이 하나 있고

```
a.pdf
b.pdf
c.pdf
```

어떤 디렉토리 구조가 있습니다.

우리는 이 목록에 있는 파일들 중에 이 디렉토리 구조 안에서 찾지 못한 파일들의 명단을 만들어야 합니다.

우리는 두 가지 방향으로 진행할 수 있습니다.

1. 먼저 주어진 디렉토리 구조 안에 있는 파일들의 목록을 생성하고, 그 목록을 주어진 목록과 비교할 수
있습니다. 이를 위해서는 존재하는 파일들의 목록을 메모리에 보관하고 있어야 하며, 우리 컴퓨터의 메모리보다
목록이 더 크다면 문제가 될 것입니다.

2. 주어진 목록에 있는 각 파일에 대해서 디렉토리 구조 안을 검색할 수도 있습니다. 이 방법은
한번에 하나의 파일명만 메모리에 보관하면 되지만, 각각의 파일에 대해서 디렉토리 구조를 순회해야
합니다. 이것은 오랜 시간이 소요될 것이고, 특히 찾아볼 파일의 갯수가 많다면 더욱 그렇습니다.

첫번째 방법을 구현한 것을 살펴봅시다. [File::Find::Rule](https://metacpan.org/pod/File::Find::Rule)
모듈을 사용하여 파일 시스템을 순회하고 파일들의 이름을 수집하도록 하겠습니다.

```perl
use strict;
use warnings;

use File::Find::Rule;
use File::Basename qw(basename);

my $path = "C:/Users/foobar/files/dir1";
my $report = 'final.txt';
my $expected = <STDIN>;
chomp $expected;

open(my $fh, '<', $expected) or die "Could not open '$expected' $!\n";
open(my $out, '>', $report) or die "Could not open '$report' $!\n";

my @full_pathes = File::Find::Rule->file->name('*.pdf')->in($path);
my @files = map { lc basename $_ } @full_pathes;
my %file = map { $_ => 1 } @files;

print $out "Below files do not exist in the Dir ($path):\n";
while (my $name = <$fh>) {
    chomp $name;
    if ($file{lc $name}) {
        print "$name found\n";
    } else {
        print $out "$name\n";
    }
}
close $out;
close $fh;
```

먼저 사용자에게 예상되는 목록이 담긴 파일의 이름을 요청합니다. 그 다음, 파일 이름들을 수집하기 전에
먼저 예상되는(또는 요구되는?) 파일명의 목록이 담긴 파일과 보고서를 작성할 파일을 먼저 엽니다.
이렇게 해서 이 두 명령 중 하나라도 실패할 경우 디렉토리 트리 전체를 검사하는 시간 낭비를 피하게 됩니다.

`File::Find::Rule->file->name('*.pdf')->in($path);` 호출은
`*.pdf` 와일드카드에 일치하면서 `$path`의 서브디렉토리 내에 있는 파일들의
목록을 만듭니다.

유일한 문제는 윈도우에서 파일명은 대소문자를 구분하지 않는데 File::Find::Rule의 와일드카드 매칭은
대소문자를 구분하는 것 같다는 점입니다. 따라서 위 코드는 확장자가 `.pdf`인 파일들만 찾고
확장자가 `.Pdf`인 파일은 찾지 못할 것입니다. 이 문제는 `->name('*.[pP][dD][fF]')`처럼
적음으로써 쉽게 해결할 수 있습니다. 이렇게 하면 세 글자 모두 대소문자에 무관하게 찾을 것입니다.

[File::Find::Rule](https://metacpan.org/pod/File::Find::Rule)에 의해 반환된 파일 목록에는
각 파일의 전체 경로명이 들어 있는데, 우리는 파일명 부분만 필요합니다. 그래서 목록의 각 명단에 대하여
`basename()`을 수행한 후에 새 배열 `@files`를 만들었습니다. 이를 위해
[map](https://perlmaven.com/transforming-a-perl-array-using-map)을 사용하였습니다.
또한 각각의 파일명에 대해 `lc()`를 적용하여 파일명을 소문자 문자열로 변환하였습니다.
소문자로 변환하는 작업은 중요한데, 윈도우에서 파일명은 대소문자 구분을 하지 않는데 Perl 내의 문자열은
대소문자를 구분하기 때문입니다. 이 스크립트가 리눅스/유닉스에서 실행된다면 대소문자에 대한 문제들은
더 따져봐야 합니다.

존재하는 파일 목록을 만드는 마지막 단계는 파일들의 이름을 키로 하고
거기 대응되는 값은 똑같이 `1`로 되어 있는 `%file` 해시를 만드는 것입니다.
이 해시는 어떤 파일이 디렉토리 구조 안에서 발견되었는지를 쉽게 체크할 수 있게 도와줄 것입니다.

이제 입력 파일의 항목들을 순회하면서, 개행문자를 `chomp`로 잘라내고, 그 항목을 소문자로만 이뤄지게
변환한 것이 `%file` 해시 안에 존재하는지를 검사합니다. 해시 안에 있다면, 그 파일이 디렉토리 구조
안에 있다는 것을 알 수 있습니다. 해시에 없다면 보고서 파일에 추가합니다.

