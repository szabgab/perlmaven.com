#!/usr/bin/perl
use warnings;
use strict;

package racoon;
use base qw( Bot::BasicBot );
our %memory;

sub save_memory{

   my $mem_file = shift;
   my $key = shift;
   my $value = shift;
   
   open my $fh, ">>", $mem_file;
   
   print $fh "$key:$value\n";
   
   close $fh;
   return 1;
}

sub load_memory{
   my $mem_file = shift;
   open my $fh, "<", $mem_file;

   while (<$fh>){
      
      my ($key, $value) = split /:/, $_;
      $memory{$key} = $value;     
           
   }

   close $fh;
   return 1;
}

sub said {
   my ($self, $message) = @_;
   
   if($message->{address} eq 'racoon' or 
      $message->{address} eq 'msg')  {
      load_memory("memory.txt");
   
      if ($message->{body} =~ /(.+) is (.+)/ ) {
        
        
        save_memory("memory.txt", $1, $2);
        load_memory("memory.txt");
        
        return "The key '$1' is stored with value '$2'";
      
         
      }
      
      foreach ( keys %memory) {
      
         if ($message->{body} =~ /$_/i) {
         
            return $memory{$_};
      
         }
      
      }
   }
}

# help text for the bot
sub help { "Bot of #minix, always read to help you!" }

# Create an instance of the bot and start it running. Connect
# to the main perl IRC server, and join some channels.
racoon->new(
   server => 'irc.freenode.net',
   channels => [ '#minix' ],
   nick => 'racoon',
)->run();
