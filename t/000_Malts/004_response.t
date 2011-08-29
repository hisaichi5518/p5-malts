#!perl -w
use strict;
use Test::More;

use Malts;

my $res_class = 'Plack::Response';
my $malts = Malts->new;

{
    my $res = $malts->response;
    ok !$res;
}
{
    note 'testing new response';
    my $res = $malts->new_response();
    isa_ok $res, $res_class;

    $res = $malts->new_response(200);
    isa_ok $res, $res_class;

    $res = $malts->new_response(200, []);
    isa_ok $res, $res_class;

    $res = $malts->new_response(200, [], 'ok');
    isa_ok $res, $res_class;

    $res = $malts->new_response(200, [], ['ok']);
    isa_ok $res, $res_class;
}
{
    note 'testing create_response';
    my $res = $malts->create_response(200, [], ['ok']);
    isa_ok $res, $res_class;

    ok $malts->response;
    isa_ok $malts->response, $res_class;
}

done_testing;
