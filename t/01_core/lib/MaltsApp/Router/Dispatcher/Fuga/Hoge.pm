package MaltsApp::Router::Dispatcher::Fuga::Hoge;
use strict;
use warnings;
use Malts::Web::Router::Simple;

get '/' => sub {
    my ($c) = @_;
    $c->render_string(200, 'fuga hoge!!');
};

1;
