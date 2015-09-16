
sub field {
   my ($self, $value) = @_;
   if (@_ == 2) {
       my $old = $self->{field};
       $self->{field} = $value;
       return $old;
   }
   return $self->{field};
}


