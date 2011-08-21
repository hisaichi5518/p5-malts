#!perl -w
use strict;
use Test::More;

use Malts;

my $req_class = 'Plack::Request';
my $malts = Malts->new;

{
    note 'testing dont have request';
    my $req = $malts->request;
    ok !$req;
}
{
    note 'testing new_request';
    my $req = $malts->new_request({ PATH_INFO => '/' });
    isa_ok $req, $req_class;
}
{
    note 'testing create request';
    my $req = $malts->create_request({PATH_INFO => '/'});
    isa_ok $req, $req_class;
    ok $malts->request;
    isa_ok $malts->request, $req_class;
}
{
    note 'testing return error if $env is required';
    eval { $malts->create_request() };
    ok $@;
}

done_testing;
