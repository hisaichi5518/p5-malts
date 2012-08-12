use strict;
use warnings;
use Test::More;
use Malts::Test;
use HTTP::Request::Common;

my $app = do {
    package MaltsApp::Test;
    use strict;
    use warnings;
    use utf8;
    use parent qw/Malts/;
    __PACKAGE__->load_plugins(
        'Web::View::JSON',
    );

    sub dispatch {
        my $c = shift;
        my $path_info = $c->request->path_info || '';
        if ($path_info eq '/') {
            return $c->render_json(200, {user => 'hisaichi5518'});
        }
        elsif ($path_info eq '/utf8') {
            return $c->render_json(200, {user => 'ひさいち'});
        }
        else {
            return $c->render_json(404, {err => 'not found!'});
        }
    }

    __PACKAGE__->to_app;
};

subtest 'render_json' => sub {
    my $res = $app->({PATH_INFO => '/'});
    is_deeply $res->[2], ['{"user":"hisaichi5518"}'];

    $res = $app->({PATH_INFO => '/utf8'});
    is_deeply $res->[2], ['{"user":"\u3072\u3055\u3044\u3061"}']; # ひさいち

    $res = $app->({PATH_INFO => '/404'});
    is_deeply $res->[2], ['{"err":"not found!"}'];
};

subtest 'Chrome and HTTP_X_REQUESTED_WITH is not "XMLHttpRequest"' => sub {
    my $res = $app->({
        HTTP_USER_AGENT => 'Chrome',
    });

    is_deeply $res->[1], [
        'Content-Length' => 20,
        'Content-Type'   => 'text/html; charset=utf-8',
        'X-Content-Type-Options' => 'nosniff',
        'X-Frame-Options' => 'DENY',
    ];
};

subtest 'Chrome and HTTP_X_REQUESTED_WITH is "XMLHttpRequest"' => sub {
    my $res = $app->({
        HTTP_USER_AGENT => 'Chrome',
        HTTP_X_REQUESTED_WITH => 'XMLHttpRequest',
    });

    is_deeply $res->[1], [
        'Content-Length' => 20,
        'Content-Type'   => 'application/json; charset=utf-8',
        'X-Content-Type-Options' => 'nosniff',
        'X-Frame-Options' => 'DENY',
    ];
};

subtest 'Safari and encoding is utf-8' => sub {
    my $res = $app->({
        HTTP_USER_AGENT => 'Safari',
    });

    is_deeply $res->[2], ["\xEF\xBB\xBF".'{"err":"not found!"}'];
};

done_testing;
