use strict;
use warnings;

package MaltsApp::URI;
use parent qw(Malts);

package MaltsApp::URI::Dispatcher;
use utf8;
use Malts::Web::Router::Simple;
use Test::More;

get '/run_tests' => sub {
    my $c = shift;

    is $c->uri_for('/'), 'http://localhost/';
    is $c->uri_for('/tests'), 'http://localhost/tests';
    is $c->uri_for('/tests', [page => 1]), 'http://localhost/tests?page=1';
    is $c->uri_for('/tests', [hello => 'こんにちは']), 'http://localhost/tests?hello=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

    is $c->uri_with([page => 1]), 'http://localhost/run_tests?page=1';
    is $c->uri_with([hello => 'こんにちは']), 'http://localhost/run_tests?hello=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

    my $res = $c->redirect_to($c->uri_for('/'));
    is $res->headers->header('Location'), 'http://localhost/';

    $res = $c->redirect_to('http://localhost/');
    is $res->headers->header('Location'), 'http://localhost/';

    # use uri_for
    $res = $c->redirect_to('/');
    is $res->headers->header('Location'), 'http://localhost/';

    # use uri_with
    $res = $c->redirect_to([page => 1]);
    is $res->headers->header('Location'), 'http://localhost/run_tests?page=1';

    $c->render_string(200, 'ok');
};

# mount '/mount' => $app;
get '/m/run_tests' => sub {
    my $c = shift;

    is $c->uri_for('/'), 'http://localhost/mount/';
    is $c->uri_for('/tests'), 'http://localhost/mount/tests';
    is $c->uri_for('/tests', [page => 1]), 'http://localhost/mount/tests?page=1';
    is $c->uri_for('/tests', [hello => 'こんにちは']), 'http://localhost/mount/tests?hello=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

    is $c->uri_with([page => 1]), 'http://localhost/mount/m/run_tests?page=1';
    is $c->uri_with([hello => 'こんにちは']), 'http://localhost/mount/m/run_tests?hello=%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF';

    my $res = $c->redirect_to($c->uri_for('/'));
    is $res->headers->header('Location'), 'http://localhost/mount/';

    $res = $c->redirect_to('http://localhost/');
    is $res->headers->header('Location'), 'http://localhost/';

    # use uri_for
    $res = $c->redirect_to('/');
    is $res->headers->header('Location'), 'http://localhost/mount/';

    # use uri_with
    $res = $c->redirect_to([page => 1]);
    is $res->headers->header('Location'), 'http://localhost/mount/m/run_tests?page=1';

    $c->render_string(200, 'ok');
};
1;
