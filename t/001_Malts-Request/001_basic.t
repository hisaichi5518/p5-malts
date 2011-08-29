#!perl -w
use strict;
use Test::More;

use Malts::Request;

note 'testing $req isa Malts::Request';
my $req = Malts::Request->new({});
isa_ok $req, 'Malts::Request';

done_testing;
