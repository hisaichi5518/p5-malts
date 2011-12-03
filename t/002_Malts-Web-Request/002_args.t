#!perl -w
use strict;
use Test::More;
use Malts::Web::Request;

subtest 'testing args' => sub {
    my $req = Malts::Web::Request->new({});
    ok !$req->args;
};

subtest 'testing "malts.routing_args"' => sub {
    my $req = request();
    is_deeply $req->args, {name => 'hisaichi'};
};

subtest 'testing parameters' => sub {
    my $req = request();
    is_deeply $req->parameters, {name => 'hisaichi'};
};

subtest 'testing param' => sub {
    my $req = request();
    is_deeply $req->param('name'), 'hisaichi';
};

sub request {
    ok my $req = Malts::Web::Request->new({});
    $req->env->{'malts.routing_args'} = {name => 'hisaichi'};
    return $req;
}

done_testing;
