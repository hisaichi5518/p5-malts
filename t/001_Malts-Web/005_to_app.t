#!perl -w
use strict;
use Test::More;

use Malts::Web;

note 'testing to_app';
my $app = Malts::Web->to_app;
is ref $app, 'CODE';
is_deeply $app->({}), [200, ['Content-Length' => 2, 'Content-Type' => 'text/html; charset=UTF-8'], ['ok']];

done_testing;
