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

subtest 'testing session error' => sub {
    my $req = Malts::Web::Request->new({});
    eval { $req->session };
    ok $@;
};

done_testing;
