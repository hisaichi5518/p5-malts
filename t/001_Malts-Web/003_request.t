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

use Test::More;

my $t = TestApp::Web->new;
my $req_class = 'Malts::Web::Request';

subtest 'testing dont have request'=> sub {
    my $req = $t->request;
    ok !$req;
};

subtest 'testing new_request' => sub {
    my $req = $t->new_request({ PATH_INFO => '/' });
    isa_ok $req, $req_class;
    ok !$t->request;
};

subtest 'testing create request' => sub {
    my $req = $t->create_request({PATH_INFO => '/'});
    isa_ok $req, $req_class;
    ok $t->request;
    isa_ok $t->request, $req_class;
};

subtest 'testing return error if $env is required' => sub {
    eval { $t->create_request() };
    ok $@;
};

done_testing;
