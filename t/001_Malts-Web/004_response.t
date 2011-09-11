#!perl -w
package TestApp;
use strict;
use warnings;
use parent 'Malts';

package TestApp::Web;
use strict;
use warnings;

use parent -norequire, 'TestApp';
use parent 'Malts::Web';

package main;
use strict;
use warnings;

use Test::More;

my $t = TestApp::Web->new;
my $res_class = 'Malts::Web::Response';

subtest 'testing dont have response' => sub {
    my $res = $t->response;
    ok !$res;
};

subtest 'testing new response' => sub {
    my $res = $t->new_response();
    isa_ok $res, $res_class;

    $res = $t->new_response(200);
    isa_ok $res, $res_class;

    $res = $t->new_response(200, []);
    isa_ok $res, $res_class;

    $res = $t->new_response(200, [], 'ok');
    isa_ok $res, $res_class;

    $res = $t->new_response(200, [], ['ok']);
    isa_ok $res, $res_class;
};

subtest 'testing create_response' => sub {
    my $res = $t->create_response(200, [], ['ok']);
    isa_ok $res, $res_class;

    ok $t->response;
    isa_ok $t->response, $res_class;
};

done_testing;
