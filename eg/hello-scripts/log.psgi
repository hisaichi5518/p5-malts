use strict;
use warnings;

package HelloLog::Web;
use parent qw(Malts Malts::Web);
use Log::Minimal;

sub dispatch {
    my $self = shift;
    infof('hello logging!');
    $self->create_response(200, [], ['Hello Log::Minimal World!']);
}

=pod

Maltsは内部でLog::Minimalを使用している。なのでアプリ側でもLog::Minimalを使用するのが望ましい。

Log::Minimalをについては、 C<perldoc Log::Minimal> を参照する。

=cut

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal";
    HelloLog::Web->to_app;
};

__END__

=pod

=head1 NAME

log.psgi - Log::Minimalを使用してログを取る。

=cut
