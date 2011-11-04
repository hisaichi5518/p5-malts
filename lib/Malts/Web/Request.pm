package Malts::Web::Request;
use strict;
use warnings;
use parent 'Plack::Request';

sub args {
    my $self = shift;
    $self->env->{'malts.routing_args'};
}

1;
__END__

=encoding utf8

=head1 NAME

Malts::Web::Request - Malts用のRequestクラス

=head1 SYNOPSIS

    use Malts::Web::Request;
    my $env = {PATH_INFO => '/'};
    my $req = Malts::Web::Request->new($env);
    $req->path_info;

=head1 DESCRIPTION

L<Plack::Request>を継承している。

=head1 METHODS

=head2 C<< $req->args -> HashRef >>

    $req->args;

C<$env->{'malts.routing_args'}>を返す。

=head1 SEE ALSO

L<Plack::Request>

=cut
