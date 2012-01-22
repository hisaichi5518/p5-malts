package HelloApp::Web::Dispatcher;

use strict;
use warnings;
use Malts::Web::Router::Simple::Declare;

get '/' => 'Root#index';

1;
