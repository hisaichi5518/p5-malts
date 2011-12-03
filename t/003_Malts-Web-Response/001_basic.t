#!perl -w
use strict;
use Test::More;
use Malts::Web::Response;

subtest 'testing $res isa Malts::Web::Response' => sub {
    my $res = Malts::Web::Response->new(200);
    isa_ok $res, 'Malts::Web::Response';
    isa_ok $res, 'Plack::Response';
};

done_testing;
