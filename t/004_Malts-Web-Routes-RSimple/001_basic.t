#!perl -w
package TestApp::Web::Controller::Root;
use strict;
use warnings;
# HACK for Plack::Util::load_class()
$INC{'TestApp/Web/Controller/Root.pm'} = 1;

sub index {
    my ($self, $c) = @_;
    $c->ok('ok');
}

package TestApp::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);

sub startup {
    my $self = shift;
    my $r = $self->routes('RSimple');
    $r->connect('/' => {controller => 'Root', action => 'index'});
}

package main;
use strict;
use warnings;

use Test::More;

subtest 'testing routes' => sub {
    my $t = TestApp::Web->new;
    ok !$t->routes;
};

subtest 'testing dispatch' => sub {
    my $psgi_app = psgi_app({PATH_INFO => '/'});
    is $psgi_app->[0], 200;
    is_deeply $psgi_app->[2], ['ok'];
};

subtest 'testing routing args' => sub {
    my $env = {PATH_INFO => '/'};
    my $psgi_app = psgi_app($env);
    ok my $args = $env->{'malts.routing_args'};
    is_deeply $args, {controller => 'Root', action => 'index'};
};

subtest 'testing not found' => sub {
    my $psgi_app = psgi_app({PATH_INFO => '/404'});
    is $psgi_app->[0], 404;
    is_deeply $psgi_app->[2], ['404 Not Found!'];
};

sub psgi_app {
    my $env = shift;
    my $t = TestApp::Web->to_app;
    $t->($env);
}

done_testing;
