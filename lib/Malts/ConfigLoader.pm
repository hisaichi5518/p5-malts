package Malts::ConfigLoader;
use strict;
use warnings;

use File::Spec ();
use Carp ();

sub load {
    my $self = shift;
    my $fname = File::Spec->catfile(@_);
    my $config = do $fname or Carp::croak "Cannot load configuration file: $fname";
}

1;
__END__

=encoding utf8

=head1 NAME

Malts::ConfigLoader - config loader for malts.

=head1 METHODS

=head2 C<< $class->load(@paths) -> HashRef >>

    package MyApp;
    use parent 'Malts';

    sub config {
        my $self  = shift;
        my @paths = ($self->app->base_dir, 'config', 'config.pl');
        $self->{config} ||= Malts::ConfigLoader->load(@paths);
    }

=cut
