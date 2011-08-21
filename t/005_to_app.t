#!perl -w
use strict;
use Test::More;

use Malts;

note 'testing to_app';
my $app = Malts->to_app;
is ref $app, 'CODE';
is_deeply $app->({}), [200, [], ['ok']];

done_testing;
