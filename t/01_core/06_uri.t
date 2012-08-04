use strict;
use warnings;
use FindBin;
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw(GET HEAD POST PUT DELETE);
use Plack::Builder;

use lib "$FindBin::Bin/lib";
use MaltsApp::URI;

my $app = MaltsApp::URI->to_app;

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/run_tests');
    is $res->code, 200;
    is $res->content, 'ok';
};

$app = builder {mount '/mount' => $app};

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/mount/m/run_tests');
    is $res->code, 200;
    is $res->content, 'ok';
};

done_testing;
