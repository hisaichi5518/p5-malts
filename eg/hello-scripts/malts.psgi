package HelloMalts::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);

sub startup {
    my $self = shift;
    $self->ok('Hello Malts!');
};

package main;
use strict;
use warnings;

HelloMalts::Web->to_app;
