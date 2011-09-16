#!perl -w
use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::Web;
use Test::More;
use Encode qw(encode_utf8);

my $t = TestApp::Web->new;

subtest 'testing not_found' => sub {
    my $not_found = $t->not_found;
    is ref $not_found, 'Malts::Web::Response';
    is_deeply $not_found->body, ['404 Not Found!'];
};

subtest 'testing error_message' => sub {
    my $not_found = $t->not_found('404!');
    is_deeply $not_found->body, ['404!'];
};

subtest 'testing decodeed error_message' => sub {
    my $not_found = $t->not_found('404だよ!');
    is_deeply $not_found->body, [encode_utf8 '404だよ!'];
};

done_testing;
