
sub field {
   my ($self, $value) = @_;
   if (@_ == 2) {
       $self->{field} = $value;
   }
   return $self->{field};
}

