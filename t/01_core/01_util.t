use strict;
use warnings;
use Test::More;
use Malts::Util;

subtest 'find_encoding' => sub {
    isa_ok Malts::Util::find_encoding('utf-8'), 'Encode::utf8';
};

subtest 'find_encoding error' => sub {
    eval { Malts::Util::find_encoding('hisaichi5518') };
    ok $@;
};

done_testing;
