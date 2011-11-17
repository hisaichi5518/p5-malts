#!perl -w
use strict;
use Test::More;

use Malts;

subtest 'testing new' => sub {
    new_ok 'Malts';
    my $m = Malts->new(user => 1);
    is $m->{user}, 1;

    $m = Malts->new({user => 2});
    is $m->{user}, 2;
};

done_testing;
