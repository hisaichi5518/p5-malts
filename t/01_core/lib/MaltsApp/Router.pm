use strict;
use warnings;

package MaltsApp::Router;
use parent qw(Malts);

sub to_app {
    my ($self) = @_;
    return sub {
        local $INC{'MaltsApp/Router/Controller/Root.pm'} = __FILE__;
        $self->SUPER::to_app->(@_);
    };
}

package MaltsApp::Router::Dispatcher;
use Malts::Web::Router::Simple;

get  '/get'  => sub { $_[0]->render_string(200, 'get!')  };
put  '/put'  => sub { $_[0]->render_string(200, 'put!')  };
del  '/del'  => sub { $_[0]->render_string(200, 'del!')  };
post '/post' => sub { $_[0]->render_string(200, 'post!') };

any [qw/GET POST/], '/any' => sub {
    $_[0]->render_string(200, 'any!');
};

get '/hash' => {controller => 'Root', action => 'index'};
get '/str'  => 'Root#index';
get '/args/:name' => 'Root#args';

package MaltsApp::Router::Controller::Root;

sub index {
    my ($self, $c) = @_;
    $c->render_string(200, 'Root#index');
}

sub args {
    my ($self, $c) = @_;
    $c->render_string(200, $c->args->{name});
}

1;
