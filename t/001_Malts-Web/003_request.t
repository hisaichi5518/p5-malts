#!perl -w
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::Web;
use Test::More;

my $t = TestApp::Web->new;
my $req_class = 'Malts::Web::Request';

subtest 'testing dont have request'=> sub {
    my $req = $t->request;
    ok !$req;

    $req = $t->req;
    ok !$req;
};

subtest 'testing create request' => sub {
    my $req = $t->create_request({PATH_INFO => '/'});
    isa_ok $req, $req_class;
    ok $t->request;
    isa_ok $t->request, $req_class;
};

subtest 'args, param shortcut' => sub {
    my $req = $t->create_request({PATH_INFO => '/', QUERY_STRING => "foo=bar&foo=baz"});
    ok !$t->args;
    $req->env->{'malts.routing_args'} = {name => 'hisaichi5518'};
    is_deeply $t->args, {name => 'hisaichi5518'};

    is $t->param('foo'), "baz";
    is_deeply [$t->param('foo')], [qw(bar baz)];
    is_deeply [$t->param], [qw(name foo)];
};

subtest 'testing return error if not defined $env' => sub {
    eval { $t->create_request() };
    ok $@;
    like $@, qr/\$env is required/;
};

done_testing;
