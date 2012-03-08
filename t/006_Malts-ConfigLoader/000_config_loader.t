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
    use_ok 'Malts::ConfigLoader';
}

subtest 'testing config_loader' => sub {
    my $c = TestApp::Web->new;
    my $config = {
        config_loader_test => 'ok',
        array => [1, undef, 3],
        hash => {name => 'hisaichi', null => undef},
    };
    is_deeply $c->config, $config;
};

subtest 'config is read-only' => sub {
    my $c = TestApp::Web->new;

    eval { $c->config->{config_loader_test} = 'err' };
    like $@, qr/Modification of a read-only/;

    eval { delete $c->config->{config_loader_test} };
    like $@, qr/Attempt to delete readonly/;

    eval { $c->config->{array}->[1] = 1 };
    like $@, qr/Modification of a read-only/;

    eval { $c->config->{hash}->{name} = 1 };
    like $@, qr/Modification of a read-only/;

    eval { $c->config->{miteigi} = [] };
    like $@, qr/Attempt to access disallowed key/;
};

done_testing;
