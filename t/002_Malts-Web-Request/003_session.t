#!perl -w
use strict;
use Test::More;

use Malts::Web::Request;

subtest 'testing session' => sub {
    my $req = Malts::Web::Request->new({
        'psgix.session' => { name => 'hisaichi' },
        'psgix.session.options' => {},
    });
    is $req->session->get('name'), 'hisaichi';
};

# 順番が変わる
subtest 'session error' => sub {
    my $req = Malts::Web::Request->new({});
    eval { $req->session };
    ok $@;
    like $@, qr/you must use Plack::Middleware::Session/;

    $req = Malts::Web::Request->new({'psgix.session' => { name => 'hisaichi' }});
    eval { $req->session };
    ok $@;
    like $@, qr/you must use Plack::Middleware::Session/;

    $req = Malts::Web::Request->new({'psgix.session.options' => {}});
    eval { $req->session };
    ok $@;
    like $@, qr/you must use Plack::Middleware::Session/;
};

done_testing;
