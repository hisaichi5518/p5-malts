#!perl -w
use strict;
use Test::More;

use Malts;
my $malts = Malts->new;

subtest 'default encoding' => sub {
    ok my $enc = $malts->encoding;
    isa_ok $enc, 'Encode::utf8';
};

done_testing;
