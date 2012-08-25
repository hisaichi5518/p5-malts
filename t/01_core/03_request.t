use strict;
use warnings;
use utf8;
use Test::More;
use Malts::Web::Request;
use Malts;
use Encode qw(encode_utf8);

subtest 'new' => sub {
    my $req = Malts::Web::Request->new({});
    isa_ok $req, 'Plack::Request';
};

subtest 'decode param' => sub {
    my $c = Malts->boostrap;
    my $req = Malts::Web::Request->new({
        QUERY_STRING => encode_utf8 "foo=日本語"
    });
    is $req->param('foo'), '日本語';
    is $req->param_raw('foo'), encode_utf8 '日本語';
};

subtest 'session' => sub {
    my $req = Malts::Web::Request->new({
        'psgix.session' => {},
        'psgix.session.options' => {},
    });

    isa_ok $req->session, 'Plack::Session';
};

subtest 'session error' => sub {
    my $req = Malts::Web::Request->new({});

    eval { $req->session };
    ok $@;
};

done_testing;
