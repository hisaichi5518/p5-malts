#!perl -w
use strict;
use warnings;
use Test::More;
use Malts::Util;
use Scope::Container qw(start_scope_container);

subtest 'can use Plack::Util' => sub {
    ok Plack::Util::TRUE;
};

subtest 'ok Malts::Util::DEBUG' => sub {
    ok Malts::Util::DEBUG;
};

subtest 'encoding' => sub {
    my $sc = start_scope_container;
    ok my $enc = Malts::Util::encoding();
    isa_ok $enc, 'Encode::utf8';

    for my $encoding (qw/shift-jis euc-jp/) {
        ok $enc = Malts::Util::encoding($encoding);
        isa_ok $enc, 'Encode::XS', $encoding;
        isa_ok Malts::Util::encoding(), 'Encode::XS', $encoding;
    }
};

subtest 'error => utf8' => sub {
    my $sc = start_scope_container;
    eval { Malts::Util::encoding('hisaichi5518') };
    ok $@;
    like $@, qr/encoding 'hisaichi5518' not found/;

    my $enc = Malts::Util::encoding();
    ok $enc;
    isa_ok $enc, 'Encode::utf8';
};

subtest 'shift-jis => error => shift-jis' => sub {
    my $sc = start_scope_container;

    my $enc = Malts::Util::encoding('shift-jis');
    isa_ok $enc, 'Encode::XS';

    eval { Malts::Util::encoding('hisaichi5518') };
    ok $@;
    like $@, qr/encoding 'hisaichi5518' not found/;

    $enc = Malts::Util::encoding();
    ok $enc;
    isa_ok $enc, 'Encode::XS';
};

done_testing;
