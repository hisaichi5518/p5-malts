#!perl -w
use strict;
use Test::More;

use Malts;

my $malts = Malts->new;

note 'testing $malts isa Malts';
isa_ok $malts, 'Malts';

done_testing;
