use strict;
use warnings;
use Amon2::Lite;

get '/' => sub {
    $_[0]->create_response(200, [], ['ok']);
};

__PACKAGE__->to_app();
