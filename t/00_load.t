use strict;
use warnings;
use Test::More;

subtest 'load all Malts modules' => sub {
    my @modules = qw(
        Malts
        Malts::App
        Malts::Util
        Malts::Web::Request
        Malts::Web::Response
        Malts::Web::Router::Simple
        Malts::Web::View::Util
        Malts::Plugin::Web::CSRFDefender
        Malts::Plugin::Web::View::JSON
    );
    require_ok $_ for @modules;
};

done_testing;
