use strict;
use warnings;

package HelloApp::Router;
use parent qw(Malts);

package HelloApp::Router::Dispatcher;
use Malts::Web::Router::Simple;

get '/' => sub {
    my ($c) = @_;
    $c->render_string(200, 'ok!');
};

package main;
HelloApp::Router->to_app;

__END__

=pod

=head1 NAME

routes.psgi - Router::Simpleを使ったルーティング例

=cut
