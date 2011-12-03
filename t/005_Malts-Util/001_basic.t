#!perl -w
use strict;
use warnings;
use Test::More;
use Malts::Util;

subtest 'can use Plack::Util' => sub {
    ok Plack::Util::TRUE;
};

subtest 'ok Malts::Util::DEBUG' => sub {
    ok Malts::Util::DEBUG;
};

done_testing;
