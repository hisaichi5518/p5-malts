#!perl -w
use strict;
use Test::More;

use Malts::Web;

{
    package TestApp::Web;
    use parent 'Malts::Web';

    sub startup {
        shift->ok('ok');
    }
}
{
    note 'testing to_app';
    my $app = TestApp::Web->to_app;
    isa_ok $app, 'CODE';
    is_deeply $app->({}), [200, ['Content-Length' => 2, 'Content-Type' => 'text/html; charset=UTF-8'], ['ok']];
}

done_testing;
