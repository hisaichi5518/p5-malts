use strict;
use warnings;

package TestApp;

package TestApp::Web;

use parent qw(Malts Malts::Web);

sub dispatch {
    TestApp::Web::Dispatcher->dispatch(@_)
        or $_[0]->create_response(404, [], ['404 Not Found!']);
}

package TestApp::Web::Dispatcher;
use Malts::Web::Router::Simple;

get  '/get' => 'Root#index';
post '/post' => 'Root#index';
put  '/put' => 'Root#index';
del  '/del' => 'Root#index';
get  '/500' => {controller => 'Root', action => 'action_500'};

get '/code' => sub {
    my $c = shift;
    $c->create_response(200, [], ['index!']);
};

my $r = router->submapper('/submapper', {controller => 'Root'});
$r->connect('/name', {action => 'index'}, {method => 'GET'});

package TestApp::Web::Controller::Root;
$INC{'TestApp/Web/Controller/Root.pm'} = __FILE__;

sub index {
    $_[1]->create_response(200, [], ['index!']);
}

sub action_500 {}

1;
