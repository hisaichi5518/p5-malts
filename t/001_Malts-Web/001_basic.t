#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::Web;
use Test::More;

subtest 'testing html_content_type' => sub {
    my $t = TestApp::Web->new;
    isa_ok $t, 'TestApp::Web';
};

done_testing;
