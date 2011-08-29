#!perl -w
use strict;
use Test::More;

use Malts;

my $malts = Malts->new;


{
    note 'testing default encoding';
    my $encoding = $malts->encoding;
    ok $encoding;
    isa_ok $encoding, 'Encode::utf8';
}
{
    note 'testing shift-jis';
    my $encoding = $malts->encoding('shift-jis');
    ok $encoding;
    isa_ok $encoding, 'Encode::XS';
}
{
    note 'testing euc-jp';
    my $encoding = $malts->encoding('euc-jp');
    ok $encoding;
    isa_ok $encoding, 'Encode::XS';
}
{
    note 'testing default changes';
    my $encoding = $malts->encoding;
    ok $encoding;
    isa_ok $encoding, 'Encode::XS';
}
{
    note 'testing error';
    eval { $malts->encoding('hisaichi5518') };
    ok $@;
}

done_testing;
