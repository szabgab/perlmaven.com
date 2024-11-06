---
title: "펄을 사용하여 파일에 있는 문자열을 어떻게 치환 하는가"
timestamp: 2013-06-04T14:00:00
tags:
  - open
  - close
  - replace
  - File::Slurp
  - read_file
  - write_file
  - slurp
  - $/
  - $INPUT_RECORD_SEPARATOR
published: true
original: how-to-replace-a-string-in-a-file-with-perl
books:
  - beginner
author: szabgab
translator: johnkang
---


축하합니다!  당신의 신생기업 "start-up"이 정말 큰 대기업 "Large Corporation"에 인수 되었습니다. 이제 README.txt 에 있는 <b>Copyright Start-Up</b> 을 <b>Copyright Large Corporation</b> 으로 치환 해야 합니다.


## File::Slurp

[File::Slurp](https://metacpan.org/pod/File::Slurp)을 설치 할수 있고 파일이 너무 커서 컴퓨터 메모리에 적재 할 수 없는 상황이 아니라면, 다음은 해결책이 될 수 있습니다. 

```perl
use strict;
use warnings;

use File::Slurp qw(read_file write_file);

my $filename = 'README.txt';

my $data = read_file $filename, {binmode => ':utf8'};
$data =~ s/Copyright Start-Up/Copyright Large Corporation/g;
write_file $filename, {binmode => ':utf8'}, $data;
```

File::Slurp의 <b>read_file</b> 함수는 파일 전체를 읽어들여 하나의 스칼라변수에 담을 것입니다. 파일이 너무 크지 않은 것으로 간주 합니다.

유니코드 문자들을 정확하게 다루기 위해 `binmode => ':utf8'`를 설정했고 <b>전역적</b>으로 기존 텍스트를 새로운 텍스트로 치환 하기 위해 <b>/g</b> 변경자가 정규표현식 치환에 사용 되었습니다.

유니코드 문자열들을 정확하게 다루기 위해 다시 `binmode => ':utf8'` 를 이용하여 똑같은 파일에 변경된 컨텐츠를 저장 하였습니다.

## 순수 펄로 파일 내용 치환 하기

만약 File::Slurp 모듈을 설치 할수 없다면 File::Slurp의 제한된 기능을 갖는 함수를 만들수 있습니다. 이런 경우에는 파일을 유니코드 모드로 여는 파라미터를 전달 하지 않는 것을 제외 하고는 main 코드의 몸체 부분은 거의 똑같습니다. 유니코드 모드로 파일을 여는 부분을 함수 자체에 작성 하였습니다. 파일을 <b>오픈</b>하기 위해 어떻게 했는지는 호출 하는 부분에서 확인 할 수 있습니다.

```perl
use strict;
use warnings;

my $filename = 'README.txt';

my $data = read_file($filename);
$data =~ s/Copyright Start-Up/Copyright Large Corporation/g;
write_file($filename, $data);
exit;

sub read_file {
    my ($filename) = @_;

    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;;
    close $in;

    return $all;
}

sub write_file {
    my ($filename, $content) = @\_;

    open my $out, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;

    return;
}
```

`read_file` 함수에서 `$/` 변수 ($INPUT_RECORD_SEPARATOR) 를 `undef` 로 설정 하였습니다. 이것은 흔히 <b>slurp mode</b> 로써 참조 되어지는 부분으로 쓰입니다. 이는 펄의 "read-line" 연산자(<>) 에게 파일의 모든 내용을 읽어 좌항의 스칼라 변수에 할당 하라고 알려 줍니다:`my $all = <$in>;`. `$/` 변수를 설정 할때 `$/` 변수가 닫는 블럭을 나갈때 원래의 값으로 복구 될수 있도록 `local` 키워드도 사용했습니다.

`write_file` 함수는 더 이해 하기 쉽습니다. 단순히 main 코드의 몸체를 이전의 해결책과 유사하게 만들기위해 write_file 함수를 작성했습니다. 
