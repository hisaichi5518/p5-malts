#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More;
BEGIN { use_ok 'TestApp::Web' };

subtest 'testing new' => sub {
    my $t = TestApp::Web->new;
    isa_ok $t, 'TestApp::Web';
    isa_ok $t, 'Malts::Web';
    isa_ok $t, 'Malts';
};

done_testing;
