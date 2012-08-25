use strict;
use warnings;

package HelloApp::Logger;
use parent qw(Malts);
use Log::Minimal;

sub dispatch {
    my $self = shift;
    infof('hello logging!');
    $self->render_string(200, 'ok!');
}

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal";
    HelloApp::Logger->to_app;
};

__END__

=pod

=head1 NAME

log.psgi - Log::Minimalを使用してログを取る。

=cut
