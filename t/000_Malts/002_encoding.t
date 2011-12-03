#!perl -w
use strict;
use Test::More;

use Malts;
use Scope::Container qw(start_scope_container);

my $sc = start_scope_container;
my $malts = Malts->new;

subtest 'default encoding' => sub {
    ok my $enc = $malts->encoding;
    isa_ok $enc, 'Encode::utf8';
};

subtest 'set encoding' => sub {
    ok my $enc = $malts->encoding('shift-jis');
    isa_ok $enc, 'Encode::XS';
};

done_testing;
