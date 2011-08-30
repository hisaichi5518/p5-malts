#!perl -w
use strict;
use Test::More;

use Malts::Web::Request;

note 'testing $req isa Malts::Web::Request';
my $req = Malts::Web::Request->new({});
isa_ok $req, 'Malts::Web::Request';

done_testing;
