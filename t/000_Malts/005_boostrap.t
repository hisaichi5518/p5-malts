#!perl -w
use strict;
use Test::More;

use Malts;

{
    note 'testing boostrap';
    my $c = Malts->boostrap;
    ok $c->context;
    isa_ok $c->context, 'Malts';
}

done_testing;
