#!perl -w
use strict;
use Test::More;

use Malts::Web::Request;

subtest 'testing args' => sub {
    my $req = Malts::Web::Request->new({});
    is $req->args, undef;
};

subtest 'testing "malts.routing_args"' => sub {
    my $req = Malts::Web::Request->new({});
    ok !$req->args;
    $req->env->{'malts.routing_args'} = {name => 'hisaichi'};
    is_deeply $req->args, {name => 'hisaichi'};
};

subtest 'testing parameters' => sub {
    my $req = Malts::Web::Request->new({});
    $req->env->{'malts.routing_args'} = {name => 'hisaichi'};
    is_deeply $req->parameters, {name => 'hisaichi'};
};

subtest 'testing param' => sub {
    my $req = Malts::Web::Request->new({});
    $req->env->{'malts.routing_args'} = {name => 'hisaichi'};
    is_deeply $req->param('name'), 'hisaichi';
};

done_testing;
