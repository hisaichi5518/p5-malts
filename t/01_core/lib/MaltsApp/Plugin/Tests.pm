use strict;
use warnings;

package MaltsApp::Plugin::Tests;

$INC{sprintf 'MaltsApp/Plugin/Test%s.pm', $_} = $_ for 1..7;

package MaltsApp::Plugin::Test1;
use Test::More;

sub init {
    my ($class, $c) = @_;

    $c->add_hooks(
        run_test => sub {
            my ($c) = @_;
            # 一番最初に実行されるhook
            ok !$c->{hook_count};
            $c->{hook_count}++;
        },
        run_test => sub {
            my ($c) = @_;
            $c->{hook_count}++;
        },
    );
}

package MaltsApp::Plugin::Test2;
use Test::More;

# load_pluginsした時、設定を渡さないプラグイン
sub init {
    my ($class, $c, $config) = @_;

    is_deeply $config, {};
}

package MaltsApp::Plugin::Test3;
use Test::More;

sub init {
    my ($class, $c, $config) = @_;

    is_deeply $config, {name => 3};
}

package MaltsApp::Plugin::Test4;
use Test::More;

sub init {
    my ($class, $c, $config) = @_;

    is_deeply $config, {name => 4};
}

package MaltsApp::Plugin::Test5;
use Test::More;

sub init {
    my ($self, $c) = @_;
    ok !$c->can('test5');
    $c->add_method(test5 => sub {});
}

package MaltsApp::Plugin::Test6;
use Test::More;

sub init {}

package MaltsApp::Plugin::Test7;
use Test::More;

sub init {}

1;
