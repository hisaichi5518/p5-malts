use strict;
use warnings;

package HelloLog::Web;
use parent qw(Malts Malts::Web);
use Log::Minimal;

sub startup {
    my $self = shift;
    infof('hello logging!');
    $self->ok('Hello Log::Minimal World!');
}

=pod

Maltsは内部でもLog::Minimalを使用している。なのでアプリ側でもLog::Minimalを使用するのが望ましい。

=cut

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal", autodump => 1;
    HelloLog::Web->to_app;
};

__END__

=pod

=head1 NAME

log.psgi - Log::Minimalを使用してログを取る。

=cut
