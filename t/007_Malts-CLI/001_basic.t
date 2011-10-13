#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::CLI;
use Test::More;

subtest 'testing new' => sub {
    my $t = TestApp::CLI->new;
    isa_ok $t, 'TestApp::CLI';
};

done_testing;
