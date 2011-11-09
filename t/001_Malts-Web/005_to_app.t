#!perl -w
package TestApp::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);

sub dispatch {
    shift->create_response(200, [], ['ok']);
}


package main;
use strict;
use warnings;

use Test::More;

subtest 'testing to_app' => sub {
    my $app = TestApp::Web->to_app;
    isa_ok $app, 'CODE';
    is_deeply $app->({}), [200, [], ['ok']];
};

done_testing;
