use strict;
use warnings;
use utf8;
use FindBin;
use Test::More;

my $app = do {
    package MaltsApp::URI;
    use parent qw/Malts/;

    sub dispatch {
        my $c = shift;
        $c->render_string(200, 'ok');
    }

    __PACKAGE__->to_app;
};

subtest 'not mount' => sub {
    my $c = MaltsApp::URI->boostrap(
        request => MaltsApp::URI->create_request({HTTP_HOST => 'localhost'}),
    );
    my $res;

    is $c->uri_for('/'), 'http://localhost/';
    is $c->uri_for('/tests'), 'http://localhost/tests';
    is $c->uri_for('/tests', [page => 1]), 'http://localhost/tests?page=1';
    is $c->uri_for('/tests', [hello => 'こんにちは']), 'http://localhost/tests?hello=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

    is $c->uri_with([page => 1]), 'http://localhost/?page=1';
    is $c->uri_with([hello => 'こんにちは']), 'http://localhost/?hello=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

    $res = $c->redirect($c->uri_for('/'));
    is $res->headers->header('Location'), 'http://localhost/';

    $res = $c->redirect('http://localhost/');
    is $res->headers->header('Location'), 'http://localhost/';

    # use uri_for
    $res = $c->redirect('/');
    is $res->headers->header('Location'), 'http://localhost/';

    # use uri_with
    $res = $c->redirect([page => 1]);
    is $res->headers->header('Location'), 'http://localhost/?page=1';

    # use status
    $res = $c->redirect('/', 301);
    is $res->code, 301;
};

subtest 'mount' => sub {
    my $env = {
        HTTP_HOST   => 'localhost',
        SCRIPT_NAME => '/mount',
        PATH_INFO   => '/',
    };
    my $c = MaltsApp::URI->boostrap(
        request => MaltsApp::URI->create_request($env),
    );
    my $res;
        is $c->uri_for('/'), 'http://localhost/mount/';
        is $c->uri_for('/tests'), 'http://localhost/mount/tests';
        is $c->uri_for('/tests', [page => 1]), 'http://localhost/mount/tests?page=1';
        is $c->uri_for('/tests', [hello => 'こんにちは']), 'http://localhost/mount/tests?hello=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

        is $c->uri_with([page => 1]), 'http://localhost/mount/?page=1';
        is $c->uri_with([hello => 'こんにちは']), 'http://localhost/mount/?hello=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

        $res = $c->redirect($c->uri_for('/'));
        is $res->headers->header('Location'), 'http://localhost/mount/';

        $res = $c->redirect('http://localhost/');
        is $res->headers->header('Location'), 'http://localhost/';

        # use uri_for
        $res = $c->redirect('/');
        is $res->headers->header('Location'), 'http://localhost/mount/';

        # use uri_with
        $res = $c->redirect([page => 1]);
        is $res->headers->header('Location'), 'http://localhost/mount/?page=1';
};

done_testing;
