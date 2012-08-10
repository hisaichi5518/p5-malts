use strict;
use warnings;
use Malts::Test;
use Test::More;
use HTTP::Request::Common;

my $app = do {
    package MaltsApp::Test::Dispatcher;
    use strict;
    use warnings;
    use Malts::Web::Router::Simple;
    get '/' => sub { shift->render_string(200, 'ok') };

    package MaltsApp::Test;
    use strict;
    use warnings;
    use parent qw/Malts/;

    __PACKAGE__->to_app;
};

apptest(
    impl     => 'MockHTTP',
    app_name => 'MaltsApp::Test',
    app      => $app,
    client   => sub {
        my ($app) = @_;
        my ($res, $c);
        ($res, $c) = $app->(GET '/');
        isa_ok $res, 'HTTP::Response';
        isa_ok $c, 'MaltsApp::Test';
        isa_ok $c, 'Malts';
    },
);

done_testing;
