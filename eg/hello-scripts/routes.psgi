package HelloRoutes::Web::Controller::Root;
use strict;
use warnings;

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

package HelloRoutes::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);

sub startup {
    my $self = shift;
    my $r = $self->routes('RSimple');
    $r->connect('/' => {controller => 'Root', action => 'index'});
}

=pod

ルーティングする。仕様変更の可能性がある。

=cut

package main;
use strict;
use warnings;

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
