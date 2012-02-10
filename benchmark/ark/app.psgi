package MyApp;
use Ark;

package MyApp::Controller::Root;
use Ark 'Controller';

sub default :Path('/') {
    my ($self, $c) = @_;
    $c->response->body('ok');
}

package main;
use strict;
use warnings;

my $app = MyApp->new;
$app->setup;

$app->handler;
