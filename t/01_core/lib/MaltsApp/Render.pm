use strict;
use warnings;

package MaltsApp::Render;
use parent qw(Malts);
use Text::Xslate;

my $view;
sub view {
    $view ||= Text::Xslate->new(
        path => [{
            'index.tx' => '<body><: $message :></body>',
        }],
    );
}

package MaltsApp::Render::Dispatcher;
use utf8;
use Malts::Web::Router::Simple;
use Test::More;
use Encode qw/encode_utf8/;

get '/run_tests' => sub {
    my $c = shift;
    my $message = 'こんにちは';
    my $raw_message = encode_utf8 $message;

    my $res = $c->render(200, 'index.tx', {message => $message});
    is $res->code, 200;
    like $res->body->[0], qr/$raw_message/;

    $res = $c->render_string(200, $message);
    is $res->code, 200;
    like $res->body->[0], qr/$raw_message/;

    $c->render_string(200, 'ok');
};


1;
