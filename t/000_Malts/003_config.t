#!perl -w
use strict;
use Test::More;

use Malts;

my $malts = Malts->new;

{
    note 'testing get default config';
    my $config = $malts->config;
    ok $config;
    is_deeply $config, {};
}
{
    note 'testing set config';
    $malts->config->{name} = 'hisada';
    is_deeply $malts->config, {name => 'hisada'};

    my $config = $malts->config;
    $config->{name} = 'hisaichi5518';
    ok $malts->config;
    is_deeply $malts->config, {name => 'hisaichi5518'};
}
{
    note 'testing get config';
    my $config = $malts->config->{name};
    ok $config;
    is $config, 'hisaichi5518';
}
{
    note 'testing get hash config';
    my $config = $malts->config;
    ok $config;
    is_deeply $config, {name => 'hisaichi5518'};
}

done_testing;
