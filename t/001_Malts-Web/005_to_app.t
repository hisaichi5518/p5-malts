#!perl -w
package TestApp::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);

sub startup {
    my $c = shift;
    $c->{body} = 'ok';
}

sub dispatch {
    my $c = shift;
    $c->create_response(200, [], ['ng']);
}

sub after_dispatch {
    my ($c, $res) = @_;
    die "cannot find response." if not defined $res;
    $res->body($c->{body});
}

package TestApp1::Web;
use parent -norequire, 'TestApp::Web';

sub dispatch {}
sub after_dispatch {}

package main;
use strict;
use warnings;
use Test::More;

subtest 'testing to_app' => sub {
    my $app = TestApp::Web->to_app;
    isa_ok $app, 'CODE';
    is_deeply $app->({}), [200, [], ['ok']];
};

subtest '$env is required' => sub {
    my $app = TestApp::Web->to_app;
    eval{ $app->() };
    ok $@;
};

subtest 'no response' => sub {
    my $app = TestApp1::Web->to_app;
    eval{ $app->({}) };
    ok $@;
    like $@, qr/You must create a response/;
};

done_testing;
