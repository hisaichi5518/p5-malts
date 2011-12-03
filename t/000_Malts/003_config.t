#!perl -w
use strict;
use Test::More;

use Malts;
use Scope::Container qw(start_scope_container);

my $malts = Malts->new;
my $sc = start_scope_container;

subtest 'testing get default config' => sub {
    my $config = $malts->config;
    ok $config;
    is_deeply $config, {};
};

subtest 'testing set config and get config' => sub {
    # 将来的にはset出来ないようにするかもしれないので極力使わない方がよい。
    ok !$malts->config->{name};
    ok $malts->config->{name} = 'hisada';
    is $malts->config->{name}, 'hisada';
    is_deeply $malts->config, {name => 'hisada'};

    ok my $config = $malts->config;
    ok $config->{name} = 'hisaichi5518';
    is_deeply $config, {name => 'hisaichi5518'};
    is_deeply $malts->config, {name => 'hisaichi5518'};
};

done_testing;
