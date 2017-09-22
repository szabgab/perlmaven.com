#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

=head1 NAME

Rex::Commands::MD5 - Calculate MD5 sum of files (Perl Maven edition)

=head1 DESCRIPTION

This is a modified version of the original module with the same name,
used for benchmarking demonstration on Perl Maven site.

With this module you calculate the md5 sum of a file.

This is just a helper function and will not be reported.

=head1 SYNOPSIS

 my $md5 = md5($file);

=head1 EXPORTED FUNCTIONS

=cut

package Rex::Commands::MD5;

use strict;
use warnings;

# VERSION

use Rex::Logger;
require Rex::Commands;
use Rex::Interface::Exec;
use Rex::Interface::File;
use Rex::Interface::Fs;
use Rex::Helper::Path;
use Rex::Helper::Run;

require Rex::Exporter;
use base qw(Rex::Exporter);
use vars qw(@EXPORT);

@EXPORT =
  qw(md5 md5sum md5_current_no_script md5_current md5_new_binmode_method md5_new);

=head2 md5($file)

This function will return the MD5 checksum (hexadecimal) for the given file.

 task "md5", "server01", sub {
   my $md5 = md5("/etc/passwd");
 };

=cut

sub md5sum {
  my ($file) = @_;
  my $exec = Rex::Interface::Exec->create;

  return split( /\s/, $exec->exec("md5sum '$file'") );
}

sub md5_current_no_script {
  my ($file) = @_;

  my $script =
    qq|perl -e 'use Digest::MD5; my \$ctx = Digest::MD5->new; open my \$fh, "<", \$ARGV[0]; binmode \$fh; while(my \$line = <\$fh>) { \$ctx->add(\$line); }; print \$ctx->hexdigest . "\n";' "$file"|;

  return i_run "$script";
}

sub md5_current {
  my ($file) = @_;

  my $script = q|
        use Digest::MD5;
        my $ctx = Digest::MD5->new;
        open my $fh, "<", $ARGV[0];
        binmode $fh;
        while(my $line = <$fh>) {
          $ctx->add($line);
        }
        print $ctx->hexdigest . "\n";
        |;

  my $rnd_file = get_tmp_file;

  my $fh = Rex::Interface::File->create;
  $fh->open( ">", $rnd_file );
  $fh->write($script);
  $fh->close;

  my $md5 = i_run "perl $rnd_file '$file'";
  Rex::Interface::Fs->create->unlink($rnd_file);
  return $md5;
}

sub md5 {
  my ($file) = @_;

  my $fs = Rex::Interface::Fs->create;
  if ( $fs->is_file($file) ) {

    Rex::Logger::debug("Calculating Checksum (md5) of $file");

    my $exec = Rex::Interface::Exec->create;
    my $md5;

    my $uname_cmd = $exec->can_run( ["uname"] );
    my ( $os, $md5_cmd );

    if ($uname_cmd) {
      $os = $exec->exec("$uname_cmd -s");
    }
    else {
      $os = "Unknown";
    }
    if ( $os =~ /bsd|darwin/i ) {
      $md5 = $exec->exec("/sbin/md5 -q '$file'");
    }
    else {
      $md5_cmd = $exec->can_run( ["md5sum"] );
      if ($md5_cmd) {
        ($md5) = split( /\s/, $exec->exec("$md5_cmd '$file'") );
      }
      else {

        my $script = q|
        use Digest::MD5;
        my $ctx = Digest::MD5->new;
        open my $fh, "<", $ARGV[0];
        binmode $fh;
        while(my $line = <$fh>) {
          $ctx->add($line);
        }
        print $ctx->hexdigest . "\n";
        |;

        my $rnd_file = get_tmp_file;

        my $fh = Rex::Interface::File->create;
        $fh->open( ">", $rnd_file );
        $fh->write($script);
        $fh->close;

        if ( Rex::is_local() && $^O =~ m/^MSWin/ ) {
          $md5 = $exec->exec("perl $rnd_file \"$file\"");
        }
        else {
          $md5 = i_run "perl $rnd_file '$file'";
        }

        unless ( $? == 0 ) {
          Rex::Logger::info("Unable to get md5 sum of $file");
          die("Unable to get md5 sum of $file");
        }

        Rex::Interface::Fs->create->unlink($rnd_file);
      }
    }

    Rex::Logger::debug("MD5SUM ($file): $md5");
    $md5 =~ s/[\r\n]//gms;
    return $md5;

  }
  else {

    Rex::Logger::debug("File $file not found.");
    die("File $file not found");

  }
}

sub md5_new {
  my ($file) = @_;

  my $exec = Rex::Interface::Exec->create;

  my $command =
      'perl -MDigest::MD5 -e \'open my $fh, "<", "'
    . $file
    . '" or die "Cannot open '
    . $file
    . '"; binmode $fh; print Digest::MD5->new->addfile($fh)->hexdigest;\'';

  my $md5 = $exec->exec($command);
  chomp $md5;

  return $md5;
}

sub md5_new_binmode_method {
  my ($file) = @_;

  my $exec = Rex::Interface::Exec->create;

  my $command =
      'perl -MDigest::MD5 -e \'open my $fh, "<", "'
    . $file
    . '" or die "Cannot open '
    . $file
    . '"; $fh->binmode; print Digest::MD5->new->addfile($fh)->hexdigest;\'';

  my $md5 = $exec->exec($command);
  chomp $md5;

  return $md5;
}

1;
