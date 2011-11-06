use strict;
use warnings;

package HelloRoutes::Web;
use parent qw(Malts Malts::Web);

sub startup {
    my $self = shift;
    HelloRoutes::Web::Dispatcher->dispatch($self) or $self->not_found;
}

=pod

dispatch()を実行する。

=cut

package HelloRoutes::Web::Dispatcher;
use Malts::Web::Router::Simple::Declare;

get '/' => 'Root#index';

=pod

routesを指定する。get, post, put, deleteがある。

=cut

package HelloRoutes::Web::Controller::Root;
# HACK for Plack::Util::load_class()
$INC{'HelloRoutes/Web/Controller/Root.pm'} = __FILE__;

sub begin {
    my ($self, $c) = @_;
}

sub end {
    my ($self, $c) = @_;
}

sub index {
    my ($self, $c) = @_;
    $c->ok('Hello Router::Simple World');
}

=pod

begin・endメソッドは特別であり、そのメソッドが存在している場合に限り、actionが実行される前と後に実行される。

begin, endが存在していなくてもエラーはでない。

=cut

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloRoutes::Web->to_app;
};

__END__

=pod

=head1 NAME

routes.psgi - ルーティングを試す

=cut
