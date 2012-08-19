use strict;
use warnings;
use Test::More;

my $app = do {
    package MyApp::Web;
    use parent 'Malts';
    use Text::Xslate;
    __PACKAGE__->load_plugins('Web::CSRFDefender');

    my $view;
    sub view {
        $view ||= Text::Xslate->new(
            path => [{
                'form' => '<form action="http://example.com/" method="POST"></form>',
            }]
        );
    }

    sub dispatch {
        shift->render_string(200, 'ok');
    }

    __PACKAGE__->to_app;
};

sub request {
    my $env = shift;
    my ($app, $c) = MyApp::Web->boostrap;
    ok $c->create_request($env);
    return $c;
}

subtest 'testing get csrf_token' => sub {
    my $c = request({
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->csrf_token, 'hisaichi';
};

subtest 'return random string if can not get csrf_token' => sub {
    my $c = request({
        'psgix.session' => {},
        'psgix.session.options' => {},
    });
    is length($c->csrf_token), 16;
};

subtest 'testing session error' => sub {
    my $c = request({});
    eval { $c->csrf_token };
    ok $@;
    like $@, qr/psgix\.session/;
};

subtest 'testing validate_csrf' => sub {
    my $c = request({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hisaichi',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 1;
};

subtest 'testing validate_csrf error' => sub {
    my $c = request({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hogehoge',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 0;

    $c = request({
        REQUEST_METHOD => 'POST',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 0;

    $c = request({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hogehoge',
        'psgix.session' => {},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 0;
};

subtest 'html filter' => sub {
    my $c = request({
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    like $c->render(200, 'form')->body->[0], qr/value="hisaichi"/;
    like $c->render_string(200, '<form></form>')->body->[0], qr/value="hisaichi"/;
};

subtest 'after_dispatch: error check' => sub {
    my $app = MyApp::Web->to_app();
    # POSTの場合、セッションとパラメータが一緒か自動で確認
    my $res = $app->({
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
        'QUERY_STRING' => 'csrf_token=chigauchigau',
        'REQUEST_METHOD' => 'POST',
    });

    is $res->[0], 403;
};

subtest 'after_dispatch: success!' => sub {
    my $app = MyApp::Web->to_app();
    # POSTの場合、セッションとパラメータが一緒か自動で確認
    my $res = $app->({
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
        'QUERY_STRING' => 'csrf_token=hisaichi',
        'REQUEST_METHOD' => 'POST',
    });

    is $res->[0], 200;
};

done_testing;

__END__

=pod

C<psgix.session>とC<psgix.session.options>は、sessionで使うため必須。

=cut
