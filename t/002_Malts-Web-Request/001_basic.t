#!perl -w
use strict;
use Test::More;
use Malts::Web::Request;

subtest '$req isa Malts::Web::Request and Plack::Request' => sub {
    my $req = Malts::Web::Request->new({});
    isa_ok $req, 'Malts::Web::Request';
    isa_ok $req, 'Plack::Request';
};

subtest '$env is required' => sub {
    eval { Malts::Web::Request->new };
    ok $@;
    like $@, qr/\$env is required/;
};

done_testing;
