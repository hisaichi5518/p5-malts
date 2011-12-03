#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::Web;
use Test::More;

subtest 'testing html_content_type' => sub {
    my $t = TestApp::Web->new;
    ok !$t->html_content_type;
};

subtest 'testing html_content_type have string' => sub {
    my $t = TestApp::Web->new(html_content_type => 'text/html; charset=UTF-8');
    is $t->html_content_type, 'text/html; charset=UTF-8';
};

subtest 'set html_content_type' => sub {
    my $t = TestApp::Web->new(html_content_type => 'text/html; charset=UTF-8');
    is $t->html_content_type, 'text/html; charset=UTF-8';
    is $t->html_content_type('hoge'), 'hoge';
    is $t->html_content_type, 'hoge';
};

done_testing;
