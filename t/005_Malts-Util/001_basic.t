#!perl -w
use strict;
use warnings;

BEGIN {
    $ENV{PLACK_ENV} = 'development';
};

use Test::More;
use Malts::Util;

subtest 'testing use Plack::Util' => sub {
    ok Plack::Util::TRUE;
};

subtest 'testing use Malts::Util::DEBUG' => sub {
    ok Malts::Util::DEBUG;
};

done_testing;
