use strict;
use warnings;
use Test::More;

subtest 'load all Malts modules' => sub {
    my @modules = qw(
        Malts
        Malts::App
        Malts::ConfigLoader
        Malts::Util
        Malts::Web::CSRFDefender
        Malts::Web::Request
        Malts::Web::Response
        Malts::Web::Flash
        Malts::Web::Router::Simple
        Malts::Web::View::JSON
        Malts::Web::View::Util
    );
    require_ok $_ for @modules;
};

done_testing;
