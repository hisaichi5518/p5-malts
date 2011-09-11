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
use Class::Method::Modifiers::Fast qw(after);

after startup => sub {
    my $self = shift;
    $self->create_response(200, [], ['ok']);
};

package main;
use strict;
use warnings;
use utf8;

use Test::More;

subtest 'testing to_app' => sub {
    my $app = TestApp::Web->to_app;
    isa_ok $app, 'CODE';
    is_deeply $app->({}), [200, [], ['ok']];
};

done_testing;
