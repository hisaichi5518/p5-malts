#!perl -w
package TestApp;
use strict;
use warnings;
use parent 'Malts';

package TestApp::Web;
use strict;
use warnings;

use parent -norequire, 'TestApp';
use parent 'Malts::Web';

package main;
use strict;
use warnings;
use utf8;

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
