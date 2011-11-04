#!perl -w
use strict;
use Test::More;

use Malts;

{
    note 'testing boostrap';
    my $c = Malts->boostrap;
    isa_ok $c, 'Malts';
}

done_testing;
