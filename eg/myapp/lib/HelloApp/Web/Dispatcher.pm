package HelloApp::Web::Dispatcher;

use strict;
use warnings;
use Malts::Web::Router::Simple;

get '/' => 'Root#index';

1;
