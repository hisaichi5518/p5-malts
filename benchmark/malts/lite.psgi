use strict;
use warnings;

package MyApp::Dispatcher;
use Malts::Web::Router::Simple;

get '/' => sub {
    $_[0]->create_response(200, [], 'ok');
};

package MyApp;
use parent qw(Malts);
# XXX: ファイルを読み込み済みという事にする。
$INC{'MyApp/Dispatcher.pm'} = 1;

__PACKAGE__->to_app;
