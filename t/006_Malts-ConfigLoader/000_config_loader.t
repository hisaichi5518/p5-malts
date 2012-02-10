#!perl -w
package TestApp::Web;
use 5.10.1;
use strict;
use warnings;
use parent qw(Malts Malts::Web);
use FindBin;
use File::Spec;
use Malts::ConfigLoader;

# HACK for Malts::app_base_class
$INC{'TestApp.pm'} = File::Spec->catdir($FindBin::Bin);

sub app_base_class { 'TestApp' }

sub config {
    state $config = do {
        my @config_path = ($_[0]->app_dir, 'config', 'test.pl');
        Malts::ConfigLoader->load(@config_path);
    };
}

package main;
use strict;
use Test::More;

BEGIN {
    use_ok 'Malts::Plugin::ConfigLoader';
}

subtest 'testing config_loader' => sub {
    my $c = TestApp::Web->new;
    is_deeply $c->config, {config_loader_test => 'ok'};
};

done_testing;
