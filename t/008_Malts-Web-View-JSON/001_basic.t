#!perl -w
use strict;
use warnings;

package MyApp::Web;
use parent qw(Malts Malts::Web);
use Malts::Web::View::JSON qw(render_json);

sub dispatch {
    my ($c) = @_;
    my $path_info = $c->request->path_info || '';
    if ($path_info eq '/') {
        return $c->render_json(200, {user => 'hisaichi5518'});
    }
    else {
        return $c->render_json(404, {err => 'not found!'});
    }
}

package main;
use Test::More;
use Scope::Container qw(start_scope_container);
my $sc = start_scope_container();

subtest 'testing render_json' => sub {
    my $psgi = psgi_app({PATH_INFO => '/'});
    is_deeply $psgi->[2], ['{"user":"hisaichi5518"}'];

    $psgi = psgi_app({PATH_INFO => '/404'});
    is_deeply $psgi->[2], ['{"err":"not found!"}'];
};

subtest 'Chrome and HTTP_X_REQUESTED_WITH is not "XMLHttpRequest"' => sub {
    my $psgi = psgi_app({
        HTTP_USER_AGENT => 'Chrome',
    });

    is_deeply $psgi->[1], [
        'Content-Length' => 20,
        'Content-Type'   => 'text/html; charset=utf-8',
        'X-Content-Type-Options' => 'nosniff'
    ];
};

subtest 'Chrome and HTTP_X_REQUESTED_WITH is "XMLHttpRequest"' => sub {
    my $psgi = psgi_app({
        HTTP_USER_AGENT => 'Chrome',
        HTTP_X_REQUESTED_WITH => 'XMLHttpRequest',
    });

    is_deeply $psgi->[1], [
        'Content-Length' => 20,
        'Content-Type'   => 'application/json; charset=utf-8',
        'X-Content-Type-Options' => 'nosniff'
    ];
};

subtest 'Safari and encoding is utf-8' => sub {
    my $psgi = psgi_app({
        HTTP_USER_AGENT => 'Safari',
    });

    is_deeply $psgi->[2], ["\xEF\xBB\xBF".'{"err":"not found!"}'];
};

sub psgi_app {
    my $env = shift;
    ok my $app = MyApp::Web->to_app;
    ok my $psgi = $app->($env);
    return $psgi;
}

done_testing;
