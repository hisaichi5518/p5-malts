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

subtest 'testing html_content_type' => sub {
    my $t = TestApp::Web->new;
    isa_ok $t, 'TestApp::Web';
};

done_testing;
