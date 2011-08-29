#!perl -w
use strict;
use Test::More;

use Malts::Response;

note 'testing $res isa Malts::Response';
my $res = Malts::Response->new(200);
isa_ok $res, 'Malts::Response';

done_testing;
