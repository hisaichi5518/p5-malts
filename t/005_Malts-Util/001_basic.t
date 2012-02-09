#!perl -w
use strict;
use warnings;
use Test::More;
BEGIN {$ENV{PLACK_ENV} = ''};
use Malts::Util;
use Scope::Container qw(start_scope_container);

subtest 'can use Plack::Util' => sub {
    ok Plack::Util::TRUE;
};

subtest 'ok Malts::Util::DEBUG' => sub {
    ok Malts::Util::DEBUG;
};

subtest 'find_encoding' => sub {
    for my $encoding (qw/shift-jis euc-jp/) {
        ok my $enc = Malts::Util::find_encoding($encoding);
        isa_ok $enc, 'Encode::XS', $encoding;
    }
};

subtest 'error' => sub {
    eval { Malts::Util::find_encoding('hisaichi5518') };
    ok $@;
    like $@, qr/encoding 'hisaichi5518' not found/;
};

done_testing;
