package Malts::Setup::Template;
use strict;
use warnings;
use Plack::Util;

sub new {
    my ($class, %args) = @_;
    my $name = $args{name} || 'Default';
    my $self = bless {name => $name}, $class;

    $self->{class} = Plack::Util::load_class($self->name, 'Malts::Setup::Template');
    $self->{files} = $self->build_files($self->class->distribution);

    return $self;
}

sub build_files {
    my ($self, $content) = @_;

    my @data = split /^@@\s+(.+?)\s*\r?\n/m, $content;
    shift @data; # trailing whitespaces

    my $all = {};
    while (@data) {
        my ($name, $content) = splice @data, 0, 2;
        $all->{$name} = $content;
    }

    return $all;
}

sub name  { shift->{name}  }
sub class { shift->{class} }
sub files { shift->{files} }

1;
__END__

=head1 METHODS

=head2 C<< $class->new(%args) >>

=head2 C<< $self->build_files($content) >>

=head2 C<< $self->name >>

=head2 C<< $self->class >>

=head2 C<< $self->files >>

=cut
