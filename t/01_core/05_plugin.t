use strict;
use warnings;
use FindBin;
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw(GET HEAD POST PUT DELETE);

use lib "$FindBin::Bin/lib";
use MaltsApp::Plugin;

my $app = MaltsApp::Plugin->to_app;

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/run_hooks');
    is $res->code, 200;
    is $res->content, 'ok';

    $res = $cb->(GET '/add_method');
    is $res->code, 200;
};

done_testing;
