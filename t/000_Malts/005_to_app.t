#!perl -w
use strict;
use Test::More;

use Malts;

note 'testing to_app';
my $app = Malts->to_app;
is ref $app, 'CODE';
is_deeply $app->({}), [200, ['Content-Length' => 2, 'Content-Type' => 'text/html; charset=UTF-8'], ['ok']];

done_testing;
