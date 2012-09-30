use strict;
use warnings;

package MaltsApp::Router;
use parent qw(Malts);

sub to_app {
    my ($class) = @_;
    return sub {
        local $INC{'MaltsApp/Router/Controller/Root.pm'}  = __FILE__;
        local $INC{'MaltsApp/Router/Dispatcher.pm'}       = __FILE__;

        $class->SUPER::to_app->(@_);
    };
}

package MaltsApp::Router::Dispatcher::Mount;
use Malts::Web::Router::Simple;
$INC{'MaltsApp/Router/Dispatcher/Mount.pm'} = __FILE__;

get '/' => sub {
    my ($c) = @_;
    $c->render_string(200, 'mount!!');
};

get '/mount' => sub {
    my ($c) = @_;
    $c->render_string(200, 'mount!!!');
};

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

get '/bridge'      => ['Root#auth' => 'Root#index'];
get '/bridge/fail' => ['Root#fail' => 'Root#index'];

get '/captures/:test/*.*' => 'Root#index';

mount '/mount/:id' => 'Mount';
auto_mount;

package MaltsApp::Router::Controller::Root;

sub auth {
    my ($class, $c) = @_;
    return; # なにもせず次のactionへ行く
}

sub fail {
    my ($class, $c) = @_;

    return $c->render_string(403, 'fail') if 1;

    return
}

sub index {
    my ($class, $c) = @_;
    $c->render_string(200, 'Root#index');
}

sub args {
    my ($class, $c) = @_;
    $c->render_string(200, $c->args->{name});
}

1;
