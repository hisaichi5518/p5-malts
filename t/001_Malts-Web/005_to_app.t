#!perl -w
package TestApp::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);
use Malts::Hook;

# startupの後に実行される
hook->set(before_dispatch => sub {
    my ($c, $res) = @_;
    if ($c->{body} && $c->{body} eq 'ok') {
        $$res = $c->create_response(200, [], [$c->{body}]);
    }
});


# after_dispatchの場合、$resはレスポンスオブジェクトなのに注意
hook->set(after_dispatch => sub {
    my ($c, $res) = @_;
    $res->header('X-Malts-Test' => 'ok') if $res->body->[0] eq 'ok';
});

sub startup {
    my $c = shift;
    $c->{body} = 'ok';
}

# $c->{body}がokなのでbefore_dispatchがresponseオブジェクトを作成
# dispatchががなくても動く。

package TestApp1::Web;
use parent -norequire, 'TestApp::Web';

# hookは実行されるが、bodyがokではないのでdispatchが必要。
sub startup {}
sub dispatch {
    my ($c) = @_;
    if (!$c->request->env->{'malts.error_test'}) {
        return $c->create_response(200, [], ['TestApp1']);
    }
}

package TestApp2::Web;
use parent "Malts::Web";

package main;
use strict;
use warnings;
use Test::More;

subtest 'testing to_app' => sub {
    my $app = TestApp::Web->to_app;
    isa_ok $app, 'CODE';
    is_deeply $app->({}), [200, ['X-Malts-Test' => 'ok'], ['ok']];

    my $c = Malts->context;
    is $c->{body}, 'ok';
};

subtest 'dispatch' => sub {
    my $app = TestApp1::Web->to_app;
    isa_ok $app, 'CODE';
    is_deeply $app->({}), [200, [], ['TestApp1']];
};

subtest '$env is required' => sub {
    my $app = TestApp::Web->to_app;
    eval{ $app->() };
    ok $@;
    like $@, qr/\$env is required/;
};

subtest 'no response' => sub {
    my $app = TestApp1::Web->to_app;
    eval{ $app->({'malts.error_test' => 1}) };
    ok $@;
    like $@, qr/You must create a response/;
};

subtest 'Please inherited the Malts' => sub {
    eval{ TestApp2::Web->to_app };
    ok $@;
    like $@, qr/Please inherited the 'Malts' in/;
};

done_testing;
