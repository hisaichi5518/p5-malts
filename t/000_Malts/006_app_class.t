#!perl -w
package TestApp::Web;
use strict;
use warnings;
use parent qw(Malts);
use File::Spec ();

# HACK for Malts::app_dir
$INC{'TestApp/Web.pm'} = File::Spec->rel2abs('./lib/TestApp');

package TestApp1::Web;
use strict;
use warnings;
use parent -norequire, 'TestApp::Web';

package main;
use strict;
use Test::More;

use Malts;

subtest 'testing app_base_class' => sub {
    my $c = Malts->new(app_base_class => 'TestApp');
    is $c->app_base_class, 'TestApp';
};

subtest 'testing app_base_class is TestApp' => sub {
    my $c = TestApp::Web->new;
    is $c->app_base_class, 'TestApp';
};

subtest 'testing app_class' => sub {
    my $c = Malts->new;
    is $c->app_class, 'Malts';
};

subtest 'testing app_class is TestApp::Web' => sub{
    my $c = TestApp::Web->new;
    is $c->app_class, 'TestApp::Web';
};

subtest 'testing app_dir' => sub {
    my $c = TestApp::Web->new;
    is $c->app_dir, test_file_dir();
};

subtest 'testing app_dir (if not defined $INC{module_name})' => sub {
    my $c = TestApp1::Web->new;
    is $c->app_dir, test_file_dir();
};

sub test_file_dir {
    File::Spec->rel2abs('./');
}

done_testing;
