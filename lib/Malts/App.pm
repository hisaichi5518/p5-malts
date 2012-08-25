package Malts::App;
use strict;
use warnings;

my ($_apps, $_hooks, $_routers, $_current);

sub apps    { $_apps    ||= {} } # for debug
sub hooks   { $_hooks   ||= {} }
sub routers { $_routers ||= {} }

sub new {
    my ($class, %args) = @_;
    my $name = $args{name} or die q/can't find "name"/;
    my $self = bless \%args, $class;

    $_apps->{$name} = $self;
    return $self;
}

sub set_running_app {
    my ($class, $name) = @_;
    my $app = Malts::App->get($name);

    if (!$app) {
        $app = Malts::App->new(name => $name);
    }

    return Malts::App->current($app);
}

sub current {
    my ($class, $app) = @_;
    return $_current = $app if defined $app;
    return $_current;
}

sub get {
    my ($class, $name) = @_;
    return $_apps->{$name};
}


sub name {
    my ($self) = @_;
    $self->{name};
}

sub base_dir {
    my ($self) = @_;
    $self->{base_dir} ||= do {
        my $path = $self->name;
        $path =~ s!::!/!g;

        if (my $libpath = $INC{"$path.pm"}) {
            $libpath =~ s!(?:blib/)?lib/+$path\.pm$!!;
            File::Spec->rel2abs($libpath || './');
        }
        else {
            File::Spec->rel2abs('./');
        }
    };
}

1;
__END__

=encoding utf8

=head1 NAME

Malts::App -

=head1 SYNOPSIS

    my $app = Malts::App->set_running_app('MyApp');

=head1 METHODS

=head2 C<< $class->apps -> HashRef >>

=head2 C<< $class->hooks -> HashRef >>

=head2 C<< $class->routers -> HashRef >>

=head2 C<< $class->new -> Object >>

=head2 C<< $class->set_running_app -> Object >>

=head2 C<< $class->current -> Object >>

=head2 C<< $class->get -> Object >>

=head2 C<< $class->name -> Str >>

=head2 C<< $class->base_dir -> Str >>

=cut
