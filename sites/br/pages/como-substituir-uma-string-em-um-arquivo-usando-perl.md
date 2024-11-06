---
title: "Como substituir uma string em um arquivo usando Perl"
timestamp: 2013-04-29T06:50:10
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
translator: aramisf
---


Parabéns! Sua start-up acabou de ser comprada pela empresa Super Large.
Agora você precisa substituir <b>Copyright Start-Up</b> por <b>Copyright
Super Large</b> no arquivo README.txt


## File::Slurp

Se você puder instalar o <a
href="https://metacpan.org/pod/File::Slurp">File::Slurp</a> e se o arquivo
não for muito grande para ocupar a memória do seu computador, então esta pode
ser uma solução:

```perl
use strict;
use warnings;

use File::Slurp qw(read_file write_file);

my $filename = 'README.txt';

my $data = read_file $filename, {binmode => ':utf8'};
$data =~ s/Copyright Start-Up/Copyright Super Large/g;
write_file $filename, {binmode => ':utf8'}, $data;
```

A função `read_file` do File::Slurp vai ler o arquivo inteiro e colocar
o conteúdo em uma única variável escalar. Ela assume que o arquivo não é muito
grande.

Nós definimos `binmode => ':utf8'` para lidar corretamente com
caracteres Unicode.
Então uma substituição por regex é usada com o modificador `/g` para
trocar <b>globalmente</b> todas as ocorrências de texto antigo pelo texto
novo.

Então nós salvamos o conteúdo no mesmo arquivo, novamente usando `binmode
=> ':utf8'` para lidar corretamente com caracteres Unicode.

## Substituir o conteúdo com Perl puro

Se você não puder instalar File::Slurp você pode implementar uma versão
limitada de suas funções. Neste caso, o corpo principal do código é quase o
mesmo, exceto que não passamos os parâmetros para abrir o arquivo no modo
Unicode. Temos isto codificado nas próprias funções. Você pode ver como isto é
feito nas chamadas para o `open`.

```perl
use strict;
use warnings;

my $filename = 'README.txt';

my $data = read_file($filename);
$data =~ s/Copyright Start-Up/Copyright Super Large/g;
write_file($filename, $data);
exit;

sub read_file {
    my ($filename) = @_;

    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;

    return $all;
}

sub write_file {
    my ($filename, $content) = @_;

    open my $out, '>:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;

    return;
}
```

Na função `read_file` definimos a variável `$/` (que também é
chamada $INPUT_RECORD_SEPARATOR) para `undef`. Isto é o que geralmente
se refere ao <b>modo slurp</b>. Isto diz ao operador "read_line" do Perl para
ler todo o conteúdo do arquivo e armazenar na variável escalar ao lado
esquerdo da atribuição: `my $all = &lt;$in>;`. Nós usamos inclusive a
palavra reservada `local` quando definimos `$/`, assim, esta
mudança será revertida quando sairmos do bloco - neste caso,
uma vez que sairmos da função `read_file`.

A função `write_file` é muito mais imediata e nós a colocamos em uma
função apenas para fazer o corpo do código similar à solução anterior. 
