use strict;
use warnings;

package HelloRoutes::Web;
use parent qw(Malts Malts::Web);

sub dispatch {
    my $self = shift;
    HelloRoutes::Web::Dispatcher->dispatch($self) or $self->create_response(404, [], ['Not Found!']);
}

=pod

dispatch()は必ずレスポンスオブジェクトを返す。返さない場合はエラーが発生する。

その逆を言うとdispatchがレスポンスオブジェクトを返せばいいだけなので、hello.psgiのようにレスポンスオブジェクトを返すだけやswitchを使って以下のような事も出来る。

    use 5.10.1;
    sub dispatch {
        my ($c) = @_;
        given ($c->req->path_info) {
            when ('/') {
                $c->create_response(200, [], ['ok']);
            }
            default {
                $c->create_response(404, [], ['404']);
            }
        }
    }

switchについては L<http://perldoc.perl.org/perlsyn.html#Switch-statements> を参照する。

=cut

package HelloRoutes::Web::Dispatcher;
use Malts::Web::Router::Simple;

get '/' => 'Root#index';

=pod

routesを指定する。get, post, put, deleteがある。

=cut

package HelloRoutes::Web::Controller::Root;
# HACK for Plack::Util::load_class()
# HelloRoutes/Web/Controller/Root.pmがあるならする必要はない。
$INC{'HelloRoutes/Web/Controller/Root.pm'} = __FILE__;

sub index {
    my ($self, $c) = @_;
    $c->create_response(200, [], ['Hello Router::Simple World']);
}

=pod

レスポンスオブジェクトを必ず返す。

=cut

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal";

    HelloRoutes::Web->to_app;
};

__END__

=pod

=head1 NAME

routes.psgi - Router::Simpleを使ったルーティング例

=cut
