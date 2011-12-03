#!perl -w
package TestApp::Web;
use strict;
use warnings;
use parent qw(Malts Malts::Web);
use FindBin;
use File::Spec;

# HACK for Malts::app_base_class
$INC{'TestApp.pm'} = File::Spec->catdir($FindBin::Bin);

sub app_base_class { 'TestApp' }

package main;
use strict;
use Test::More;
use Scope::Container qw(start_scope_container);

BEGIN {
    use_ok 'Malts::Plugin::ConfigLoader';
}

my $sc = start_scope_container;
subtest 'testing config_loader' => sub {
    my $c = TestApp::Web->new;
    Malts::Plugin::ConfigLoader->init($c);
    is $c->config->{config_loader}, 'ok';
};

subtest 'config_loader on plugin' => sub {
    my $c = TestApp::Web->new;
    $c->plugin('ConfigLoader');
    is $c->config->{config_loader}, 'ok';
};

subtest 'set mode' => sub {
    my $c = TestApp::Web->new;
    $c->plugin('ConfigLoader' => {mode => 'test'});
    is $c->config->{config_loader_test}, 'ok';
};

subtest 'use $ENV{PLACK_ENV}' => sub {
    $ENV{PLACK_ENV} = 'test';
    my $c = TestApp::Web->new;
    $c->plugin('ConfigLoader');
    is $c->config->{config_loader_test}, 'ok';
};

done_testing;
