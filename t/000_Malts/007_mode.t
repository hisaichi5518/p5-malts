#!perl -w
use strict;
use Test::More;
use Malts;

subtest 'testing mode' => sub {
    my $c = Malts->new;
    is $c->mode, 'development';
    is $c->mode('test'), 'test';
    is $c->mode, 'test';
    is $c->mode(0), 0;
};

done_testing;
