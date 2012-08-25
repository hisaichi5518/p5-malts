use strict;
use warnings;
use Test::More;
use Malts::Web::Response;

subtest 'new' => sub {
    my $res = Malts::Web::Response->new(200);
    isa_ok $res, 'Plack::Response';
};

done_testing;
