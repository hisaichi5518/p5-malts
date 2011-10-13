#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::CLI;
use Test::More;

subtest 'testing options, args and parse_options' => sub {
    ok my $c = TestApp::CLI->boostrap;
    is_deeply $c->options, {};
    is_deeply $c->args, [];

    $c->parse_options(
        option_spec  => [],
        pass_through => 0,
        args => []
    );

    is_deeply $c->options, {};
    is_deeply $c->args, [];

    $c->parse_options(
        option_spec  => ['option=s'],
        pass_through => 0,
        args => ['--option=hoge']
    );

    is_deeply $c->options, {option => 'hoge'};
    is_deeply $c->args, [];

    $c->parse_options(
        option_spec  => ['option=s'],
        pass_through => 0,
        args => ['--option=hoge', 'hisaichi5518']
    );

    is_deeply $c->options, {option => 'hoge'};
    is_deeply $c->args, ['hisaichi5518'];

    $c->parse_options(
        option_spec  => ['option=s'],
        pass_through => 1,
        args => ['--foo', 'foo', '--option', 'hoge', 'hisaichi5518']
    );

    is_deeply $c->options, {option => 'hoge'};
    is_deeply $c->args, ['--foo', 'foo', 'hisaichi5518'];

    $c->parse_options(
        option_spec  => ['option=s'],
        pass_through => 1,
        args => ['--foo=foo', '--option=hoge', 'hisaichi5518']
    );

    is_deeply $c->options, {option => 'hoge'};
    is_deeply $c->args, ['--foo=foo', 'hisaichi5518'];
};

done_testing;
