package HelloMalts::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);

sub startup {
    my $self = shift;
    $self->ok('Hello Malts!');
}

=pod

MaltsとMalts::Webを継承している。

startupでresponseを返すようにしているので高速に動作するがほぼ何も出来ない。

=cut

package main;
use strict;
use warnings;

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
