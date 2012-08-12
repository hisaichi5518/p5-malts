use strict;
use warnings;
use utf8;
use FindBin;
use Test::More;
use Malts::Test;
use HTTP::Request::Common;
use Plack::Builder;
use Encode qw(encode_utf8);

my $app = do {
    package MaltsApp::Render;
    use parent 'Malts';
    use Text::Xslate;

    sub dispatch {
        my ($c) = @_;
        $c->render_string(200, 'ok');
    }

    my $view;
    sub view {
        $view ||= Text::Xslate->new(
            path => [{
                'index.tx' => '<body><: $message :></body>',
            }],
        );
    }

    __PACKAGE__->to_app;
};

test_app
    app_name => 'MaltsApp::Render',
    app      => $app,
    client   => sub {
        my ($cb) = @_;
        my ($res, $c) = $cb->(GET '/');

        my $message = 'こんにちは';
        my $raw_message = encode_utf8 $message;

        $res = $c->render(200, 'index.tx', {message => $message});
        is $res->code, 200;
        like $res->body->[0], qr/$raw_message/;

        $res = $c->render_string(200, $message);
        is $res->code, 200;
        like $res->body->[0], qr/$raw_message/;
    },
;

done_testing;
