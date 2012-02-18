use strict;
use warnings;
use parent qw(Malts Malts::Web);
use Malts::Web::Router::Simple qw(!dispatch);

get '/' => sub {
    $_[0]->create_response(200, [], 'ok');
};

sub dispatch {
    Malts::Web::Router::Simple->dispatch(@_)
        or $_[0]->create_response(404, [], ['404 Not Found!']);
}

__PACKAGE__->to_app;
