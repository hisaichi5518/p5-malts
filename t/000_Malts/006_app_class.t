#!perl -w
package TestApp::Web;
use strict;
use warnings;
use parent qw(Malts);

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

done_testing;
