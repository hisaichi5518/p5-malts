#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::Web;
use Test::More;

my $t = TestApp::Web->new;
my $res_class = 'Malts::Web::Response';

subtest 'testing new response' => sub {
    my $res = $t->new_response();
    isa_ok $res, $res_class;

    $res = $t->new_response(200);
    isa_ok $res, $res_class;
    is $res->status, 200;

    $res = $t->new_response(200, []);
    isa_ok $res, $res_class;

    $res = $t->new_response(200, [], 'ok');
    isa_ok $res, $res_class;
    is $res->body, 'ok';

    $res = $t->new_response(200, [], ['ok']);
    isa_ok $res, $res_class;
    is_deeply $res->body, ['ok'];
};

subtest 'testing create_response' => sub {
    my $res = $t->create_response(200, [], ['ok']);
    isa_ok $res, $res_class;
    is $res->status, 200;
    is_deeply $res->body, ['ok'];
};

done_testing;
