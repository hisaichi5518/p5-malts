package HelloApp::Web;

use 5.10.1;
use strict;
use warnings;
use parent qw(HelloApp Malts::Web);
use Text::Xslate;
use HelloApp::Web::Dispatcher;

sub dispatch {
    my $self = shift;
    HelloApp::Web::Dispatcher->dispatch($self) or return $self->res_404;
}

sub view {
    state $view = Text::Xslate->new(
        path => {'root/index.tx' => '<: $dice_user :> -> DICE: <: $dice_num :>'}
    );
}

sub res_200 {
    my $self = shift;
    $self->render(200, @_);
}

sub res_404 {
    my ($self) = @_;
    $self->render_string(404, 'Not Found!');
}

1;
