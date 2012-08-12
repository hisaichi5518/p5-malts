use strict;
use warnings;
use Malts::Test;
use Test::More;
use HTTP::Request::Common;
use Plack::Builder;

my $app = do {
    package MaltsApp::Test;
    use strict;
    use warnings;
    use parent qw/Malts/;

    sub dispatch {
        my $c = shift;
        $c->render_string(200, 'ok');
    }

    __PACKAGE__->to_app;
};

test_app
    impl     => 'MockHTTP',
    app_name => 'MaltsApp::Test',
    app      => $app,
    client   => sub {
        my ($app) = @_;
        my ($res, $c);
        ($res, $c) = $app->(GET '/test');
        isa_ok $res, 'HTTP::Response';
        isa_ok $c, 'MaltsApp::Test';
        isa_ok $c, 'Malts';
        is $c->req->script_name, '';
        is $c->req->path_info, '/test';
    }
;


$app = builder {mount '/mount' => $app};

test_app
    app_name => 'MaltsApp::Test',
    app      => $app,
    client   => sub {
        my $cb  = shift;
        my ($res, $c) = $cb->(GET '/mount/');
        is $c->req->script_name, '/mount';
        is $c->req->path_info, '/';
    }
;

done_testing;
