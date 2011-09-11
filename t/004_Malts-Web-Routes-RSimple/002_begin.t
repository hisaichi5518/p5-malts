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

sub begin {
    my ($self, $c) = @_;
    $c->request->env->{done_begin} = 1;
}

sub end {
    my ($self, $c) = @_;
    $c->request->env->{done_end} = 1;
}

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

subtest 'testing dispatch' => sub {
    my $t = test_app({PATH_INFO => '/'});
    ok $t->request->env->{done_begin};
    ok $t->request->env->{done_end};
};

sub test_app {
    my $env = shift;
    my $t = TestApp::Web->new(
        html_content_type => 'text/html; charset=UTF-8',
    );
    $t->create_request($env);
    $t->startup;
    $t->routes->dispatch($t);
    return $t;
}

done_testing;
