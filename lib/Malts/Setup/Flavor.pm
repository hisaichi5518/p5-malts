package Malts::Setup::Flavor;
use strict;
use warnings;
use Plack::Util;

sub new {
    my ($class, %args) = @_;
    my $name = $args{name} || 'Default';
    my $self = bless {name => $name}, $class;

    $self->{class} = Plack::Util::load_class($self->name, 'Malts::Setup::Flavor');
    $self->{files} = $self->class->build_files;

    return $self;
}

sub name  { shift->{name}  }
sub class { shift->{class} }
sub files { shift->{files} }

1;
__END__

=head1 METHODS

=head2 C<< $class->new(%args) >>

=head2 C<< $self->name >>

=head2 C<< $self->class >>

=head2 C<< $self->files >>

=cut
