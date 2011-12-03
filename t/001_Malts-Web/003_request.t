#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::Web;
use Test::More;

my $t = TestApp::Web->new;
my $req_class = 'Malts::Web::Request';

subtest 'testing dont have request'=> sub {
    my $req = $t->request;
    ok !$req;

    $req = $t->req;
    ok !$req;
};

subtest 'testing new_request' => sub {
    my $req = $t->new_request({ PATH_INFO => '/' });
    isa_ok $req, $req_class;
    ok !$t->request;
};

subtest 'testing create request' => sub {
    my $req = $t->create_request({PATH_INFO => '/'});
    isa_ok $req, $req_class;
    ok $t->request;
    isa_ok $t->request, $req_class;
};

subtest 'testing return error if not defined $env' => sub {
    eval { $t->new_request() };
    ok $@;
    like $@, qr/\$env is required/;

    eval { $t->create_request() };
    ok $@;
    like $@, qr/\$env is required/;
};

done_testing;
