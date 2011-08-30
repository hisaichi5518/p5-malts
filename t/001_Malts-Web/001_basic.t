#!perl -w
use strict;
use Test::More;

use Malts::Web;

note 'testing $malts isa Malts::Web';
my $malts = Malts::Web->new;
isa_ok $malts, 'Malts::Web';

done_testing;
