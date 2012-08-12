package Malts::ConfigLoader;
use strict;
use warnings;

use File::Spec ();
use Malts::App;
use Carp ();

sub load {
    my $self = shift;
    my $fname = File::Spec->catfile(@_);
    my $config = do $fname or Carp::croak "Cannot load configuration file: $fname";
}

1;
__END__
