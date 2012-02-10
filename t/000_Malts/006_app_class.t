#!perl -w
package TestApp;
use strict;
use warnings;
use parent qw(Malts);
use File::Spec ();

# HACK for Malts::app_dir
$INC{'TestApp.pm'} = File::Spec->rel2abs('./lib/TestApp.pm');

sub app_base_class { 'TestApp' }

package TestApp1;
use strict;
use warnings;
use parent qw(Malts);

sub app_base_class { 'TestApp1' }

package main;
use strict;
use Test::More;
use Malts;

subtest 'testing Malts#app_base_class' => sub {
    my $c = Malts->new;
    eval { $c->app_base_class };
    ok $@;
};

subtest 'testing MyApp#app_base_class ' => sub {
    my $c = TestApp->new;
    is $c->app_base_class, 'TestApp';

    $c = TestApp1->new;
    is $c->app_base_class, 'TestApp1';
};

subtest 'testing TestApp#app_dir' => sub {
    my $c = TestApp->new;
    is $c->app_dir, test_file_dir();
};

subtest 'testing app_dir (if not defined $INC{module_name})' => sub {
    my $c = TestApp1->new;
    is $c->app_dir, test_file_dir();
};

sub test_file_dir {
    File::Spec->rel2abs('./');
}

done_testing;
