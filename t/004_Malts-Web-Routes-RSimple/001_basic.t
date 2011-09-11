#!perl -w
package TestApp;
use strict;
use warnings;
use parent 'Malts';

package TestApp::Web::Controller::Root;
use strict;
use warnings;
# HACK
$INC{'TestApp/Web/Controller/Root.pm'} = 1;

sub index {
    my ($self, $c) = @_;
    $c->ok('ok');
}

package TestApp::Web;
use strict;
use warnings;

use parent -norequire, 'TestApp';
use parent 'Malts::Web';
use Class::Method::Modifiers::Fast qw(after);

after startup => sub {
    my $self = shift;
    my $r = $self->routes('RSimple');
    $r->connect('/' => {controller => 'Root', action => 'index'});
};

package main;
use strict;
use warnings;

use Test::More;

subtest 'testing routes' => sub {
    my $t = TestApp::Web->new;
    ok !$t->routes;
};

subtest 'testing dispatch' => sub {
    # 初期設定でtext/html; charset=UTF-8がセットされる
    my $t = TestApp::Web->to_app;
    my $psgi_app =  $t->({PATH_INFO => '/'});
    is_deeply $psgi_app->[2], ['ok'];
};

done_testing;
