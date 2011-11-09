package TestApp::Web;
use strict;
use warnings;
use parent qw(Malts Malts::Web);

sub view { Text::Xslate->new }

1;
