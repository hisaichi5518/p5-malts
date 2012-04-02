#!perl -w
use strict;
use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More;
use Malts::Web;
use TestApp::Web;

my $t = TestApp::Web->new;
subtest 'uri_for' => sub {
    my $req = $t->create_request({HTTP_HOST => 'localhost', PATH_INFO => '/'});
    is $t->uri_for('/user/name'), 'http://localhost/user/name';
    is $t->uri_for('/user/name', {hoge => 11}), 'http://localhost/user/name?hoge=11';
};

done_testing;
