use strict;
use warnings;

package MaltsApp::Plugin;
use parent qw(Malts);
use MaltsApp::Plugin::Tests;
use Test::More;

__PACKAGE__->load_plugins(
    '+MaltsApp::Plugin::Test1', # add_hooks
);

__PACKAGE__->load_plugins(
    '+MaltsApp::Plugin::Test2',                # 設定がないか
    '+MaltsApp::Plugin::Test3' => {name => 3}, # 設定が読み込まれているか
    '+MaltsApp::Plugin::Test2',                # 設定がないか
    '+MaltsApp::Plugin::Test4' => {name => 4}, # 設定が読み込まれているか
);

__PACKAGE__->load_plugins(
    '+MaltsApp::Plugin::Test5' # add_method
);

package MaltsApp::Plugin::Dispatcher;
use Malts::Web::Router::Simple;
use Test::More;

get '/run_hooks' => sub {
    my $c = shift;
    $c->run_hooks('run_test');

    note 'M::M::P::Test1';
    is $c->{hook_count}, 2;
    $c->render_string(200, 'ok');
};

get '/add_method' => sub {
    my $c = shift;
    can_ok $c, 'test5';
    $c->render_string(200, 'ok');
};

1;
