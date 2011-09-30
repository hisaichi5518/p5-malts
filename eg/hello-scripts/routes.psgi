package HelloRoutes::Web::Controller::Root;
use strict;
use warnings;

# HACK for Plack::Util::load_class()
$INC{'HelloRoutes/Web/Controller/Root.pm'} = __FILE__;

sub begin {
    my ($self, $c) = @_;
    # actionが実行される前に何か処理を加えたい場合ここに追加する。
    # このメソッドは削除しても正常に動作する。
}

sub end {
    my ($self, $c) = @_;
    # actionが実行された後に何か処理を加えたい場合ここに追加する。
    # このメソッドは削除しても正常に動作する。
}

sub index {
    my ($self, $c) = @_;
    $c->ok('Hello Router::Simple World');
}

package HelloRoutes::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);

sub startup {
    my $self = shift;
    my $r = $self->routes('RSimple');
    $r->connect('/' => {controller => 'Root', action => 'index'});
};

package main;
use strict;
use warnings;

use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloRoutes::Web->to_app;
};
