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
subtest 'testing ok' => sub {
    my $ok =  $t->ok('ok');
    isa_ok $ok, 'Malts::Web::Response';
    is_deeply $ok->body, ['ok'];
};

subtest 'testing decoded string' => sub {
    my $ok = $t->ok('こんにちは');
    is_deeply $ok->body, [encode_utf8 'こんにちは'];
};

subtest 'testing return error if $decoed_html is required' => sub {
    eval { $t->ok };
    ok $@;
};

done_testing;
