#!perl -w
use strict;
use Test::More;

use Malts::Web::Request;

subtest 'testing args' => sub {
    my $req = Malts::Web::Request->new({});
    is $req->args, undef;
};

subtest 'testing ' => sub {
    my $req = Malts::Web::Request->new({});
    $req->env->{'malts.routing_args'} = {name => 'hisaichi'};
    is_deeply $req->args, {name => 'hisaichi'};
};

done_testing;
