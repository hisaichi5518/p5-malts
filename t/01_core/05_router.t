use strict;
use warnings;
use FindBin;
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw(GET HEAD POST PUT DELETE);

use lib "$FindBin::Bin/lib";
use MaltsApp::Router;

my $app = MaltsApp::Router->to_app;

test_psgi $app, sub {
    my $cb = shift;

    # 200
    my $res = $cb->(GET '/get');
    is $res->code, 200;
    is $res->content, 'get!';

    $res = $cb->(HEAD '/get');
    is $res->code, 200;
    is $res->content, 'get!';

    $res = $cb->(POST '/post');
    is $res->code, 200;
    is $res->content, 'post!';

    $res = $cb->(GET '/any');
    is $res->code, 200;
    is $res->content, 'any!';

    $res = $cb->(PUT '/put');
    is $res->code, 200;
    is $res->content, 'put!';

    $res = $cb->(DELETE '/del');
    is $res->code, 200;
    is $res->content, 'del!';


    $res = $cb->(GET '/hash');
    is $res->code, 200;
    is $res->content, 'Root#index';

    $res = $cb->(GET '/str');
    is $res->code, 200;
    is $res->content, 'Root#index';

    $res = $cb->(GET '/args/hisaichi5518');
    is $res->code, 200;
    is $res->content, 'hisaichi5518';

    $res = $cb->(GET '/bridge');
    is $res->code, 200;
    is $res->content, 'Root#index';

    $res = $cb->(GET '/bridge/fail');
    is $res->code, 403;
    is $res->content, 'fail';

    $res = $cb->(GET '/mount/1');
    is $res->code, 200;
    is $res->content, 'mount!!';

    $res = $cb->(GET '/mount/1/');
    is $res->code, 200;
    is $res->content, 'mount!!';

    $res = $cb->(GET '/mount/1/mount');
    is $res->code, 200;
    is $res->content, 'mount!!!';

    $res = $cb->(GET '/mount/1/404');
    is $res->code, 404;
    is $res->content, 'Page Not Found';

    # 404
    $res = $cb->(POST '/get');
    is $res->code, 404;
    is $res->content, 'Page Not Found';

    $res = $cb->(GET '/post');
    is $res->code, 404;

    $res = $cb->(HEAD '/any');
    is $res->code, 404;

    $res = $cb->(DELETE '/put');
    is $res->code, 404;

    $res = $cb->(PUT '/del');
    is $res->code, 404;
};

done_testing;
