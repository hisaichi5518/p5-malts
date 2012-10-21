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
        my ($cb) = @_;
        my ($res, $c);
        ($res, $c) = $cb->(GET '/test');
        isa_ok $res, 'HTTP::Response';
        isa_ok $c, 'MaltsApp::Test';
        isa_ok $c, 'Malts';
        is $c->req->script_name, '';
        is $c->req->path_info, '/test';
    }
;

test_app
    app_name => 'MaltsApp::Test::Die::Hook',
    app => do {
        package MaltsApp::Test::Die::Hook;
        use parent qw/Malts/;
        __PACKAGE__->add_hooks(before_dispatch => sub { die });
        __PACKAGE__->to_app;
    },
    client => sub {
        my ($cb) = @_;
        my ($res, $c);
        ($res, $c) = $cb->(GET '/');
        is $res->code, 500;
        ok !$c;
    }
;

test_app
    app_name => 'MaltsApp::Test::Die::App',
    app => do {
        package MaltsApp::Test::Die::App;
        use parent qw/Malts/;
        sub dispatch { die "error" }
        __PACKAGE__->to_app;
    },
    client => sub {
        my ($cb) = @_;
        my ($res, $c);
        ($res, $c) = $cb->(GET '/');
        is $res->code, 500;
        ok !$c;
    }
;

test_app
    app_name => 'MaltsApp::Test::Die::App::Eval',
    app => do {
        package MaltsApp::Test::Die::App::Eval;
        use parent qw/Malts/;
        sub to_app {
            my ($class) = @_;

            return sub {
                my $env  = shift;
                my $self = $class->setup(env => $env);
                local $Malts::_context = $self;

                my $res;
                $self->run_hooks('before_dispatch', \$res);
                if (!$res) {
                    $res = eval { die 'error' };
                    if ($@) {
                        $res = $self->create_response(500, [], [$@]);
                    }
                }
                $self->run_hooks('after_dispatch', \$res);
                return $res->finalize;
            };
        }
        __PACKAGE__->to_app;
    },
    client => sub {
        my ($cb) = @_;
        my ($res, $c);
        ($res, $c) = $cb->(GET '/');
        is $res->code, 500;
        ok $c;
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
