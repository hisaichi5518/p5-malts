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

get '/run_tests' => sub {
    my $c = shift;

    # run_hooks
    $c->run_hooks('run_test');
    is $c->{hook_count}, 2;
    my $codes = $c->get_hook_codes('run_test');
    is scalar(@$codes), 2;

    # add_method
    can_ok $c, 'test5';

    $c->add_hooks(run_test => sub {});
    $codes = $c->get_hook_codes('run_test');
    is scalar(@$codes), 3;

    $c->render_string(200, 'ok');
};

1;
