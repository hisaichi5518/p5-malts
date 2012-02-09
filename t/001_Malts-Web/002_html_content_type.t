#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::Web;
use Test::More;

subtest 'html_content_type' => sub {
    my $t = TestApp::Web->new();
    is $t->html_content_type, 'text/html; charset=UTF-8';
};

done_testing;
