#!perl -w
use strict;
use Test::More;

use Malts::Web::Response;

note 'testing $res isa Malts::Web::Response';
my $res = Malts::Web::Response->new(200);
isa_ok $res, 'Malts::Web::Response';

done_testing;
