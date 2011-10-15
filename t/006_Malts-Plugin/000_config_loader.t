#!perl -w
package TestApp::Web;
use strict;
use warnings;
use parent qw(Malts Malts::Web);
use FindBin;

# HACK for Malts::app_base_class
$INC{'TestApp.pm'} = $FindBin::Bin;

package main;
use strict;
use Test::More;

BEGIN {
    use_ok 'Malts::Plugin::ConfigLoader';
}

subtest 'testing config_loader' => sub {
    my $c = TestApp::Web->new;
    Malts::Plugin::ConfigLoader->init($c);
    is $c->config->{config_loader}, 'ok';
};

subtest 'testing config_loader on plugin' => sub {
    my $c = TestApp::Web->new;
    $c->plugin('ConfigLoader');
    is $c->config->{config_loader}, 'ok';
};

subtest 'testing mode' => sub {
    my $c = TestApp::Web->new;
    $c->plugin('ConfigLoader' => {mode => 'test'});
    is $c->config->{config_loader_test}, 'ok';
};

subtest 'testing use $ENV{PLACK_ENV}' => sub {
    $ENV{PLACK_ENV} = 'test';
    my $c = TestApp::Web->new;
    $c->plugin('ConfigLoader');
    is $c->config->{config_loader_test}, 'ok';
};

done_testing;
