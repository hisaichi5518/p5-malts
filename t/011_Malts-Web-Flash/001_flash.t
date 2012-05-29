#!perl -w
use strict;

package MyApp::Web;
use Malts::Web::Request;
use parent qw/Malts Malts::Web/;
use Malts::Web::Flash;
use Test::More;

sub dispatch {
    my ($c) = @_;
    $c->create_response(200, [], [$c]);
}

package main;
use Test::More;

subtest 'testing flash' => sub {
    my $c = c({
        'psgix.session' => {},
        'psgix.session.options' => {},
    });

    is $c->flash('notice'), undef;
    $c->flash(notice => 'notice');
    is $c->flash('notice'), 'notice';

    # あとで消えるかチェックするためset
    $c->flash(delete => 'yep');

    $c = c($c->req->env);
    # __flash_newは削除されて__flashになっている
    is $c->flash('notice'), 'notice';
    # 新しく追加
    $c->flash(notice2 => 'notice2');
    is $c->flash('notice2'), 'notice2';

    # 上書き
    $c->flash(notice => 'notice2');
    is $c->flash('notice'), 'notice2';

    $c = c($c->req->env);
    # 消えてるかのチェック
    is $c->flash('delete'), undef;

    # 上書きしたやつは消えてない
    is $c->flash('notice'), 'notice2';
};

subtest 'flash error' => sub {
    my $c = c({
        'psgix.session' => {},
        'psgix.session.options' => {},
    });
    eval { $c->flash };
    ok $@;
};

sub c {
    my $env = shift;
    my $res = MyApp::Web->to_app->($env);
    $res->[2]->[0];
}

done_testing;
