use strict;
use warnings;

package HelloMalts::Web;
use parent qw(Malts Malts::Web);

sub dispatch {
    my $self = shift;
    $self->create_response(200, [], ['Hello Malts!']);
}

=pod

MaltsとMalts::Webを継承している。

dispatchでresponseを返すようにしているので高速に動作するがほぼ何も出来ない。

dispatchをもっと拡張する場合は、routes.psgiを参照する。

=cut

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloMalts::Web->to_app;
};

__END__

=pod

=head1 NAME

hello.psgi - Malts最小構成

=cut
