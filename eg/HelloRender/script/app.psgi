package HelloMalts::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);
use Text::Xslate;

sub startup {
    my $self = shift;
    $self->view(Text::Xslate->new(
        path => {
            index => 'Hello <: $type :> World!'
        }
    ));
    $self->render('index', {type => 'Xslate'});
}

package main;
use strict;
use warnings;

HelloMalts::Web->to_app;
