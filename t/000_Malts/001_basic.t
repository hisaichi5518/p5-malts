#!perl -w
use strict;
use Test::More;

use Malts;

note 'testing $malts isa Malts';
my $malts = Malts->new;
isa_ok $malts, 'Malts';

done_testing;
