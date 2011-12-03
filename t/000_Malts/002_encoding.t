#!perl -w
use strict;
use Test::More;

use Malts;
use Scope::Container qw(start_scope_container);

my $sc = start_scope_container;
my $malts = Malts->new;

subtest 'testing default encoding' => sub {
    my $encoding = $malts->encoding;
    ok $encoding;
    isa_ok $encoding, 'Encode::utf8';
};

subtest 'testing shift-jis' => sub {
    my $encoding = $malts->encoding('shift-jis');
    ok $encoding;
    isa_ok $encoding, 'Encode::XS';
};

subtest 'testing euc-jp' => sub {
    my $encoding = $malts->encoding('euc-jp');
    ok $encoding;
    isa_ok $encoding, 'Encode::XS';
};

subtest 'testing default changes' => sub {
    my $encoding = $malts->encoding;
    ok $encoding;
    isa_ok $encoding, 'Encode::XS';
};

subtest 'testing error' => sub {
    my $encoding = $malts->encoding;
    ok $encoding;
    isa_ok $encoding, 'Encode::XS';

    eval { $malts->encoding('hisaichi5518') };
    ok $@;

    $encoding = $malts->encoding;
    ok $encoding;
    isa_ok $encoding, 'Encode::XS';
};

done_testing;
