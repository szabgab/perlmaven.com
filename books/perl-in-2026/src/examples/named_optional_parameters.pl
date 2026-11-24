use v5.44;
no warnings "experimental::signature_named_parameters";

sub run(:$cmd, :$hostname = "localhost") {
    say "Running '$cmd' on '$hostname'";
}

run(cmd => "ls");
run(cmd => "cat", hostname => "animals.com");
run(hostname => "animals.com", cmd => "dog");
