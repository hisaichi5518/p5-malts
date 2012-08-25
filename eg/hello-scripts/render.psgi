use strict;
use warnings;

package HelloApp::Render;
use parent qw(Malts);
use Text::Xslate;

sub dispatch {
    my $self = shift;
    $self->render(200, 'root/index.tx', {type => 'Xslate'});
}

my $view;
sub view {
    $view ||= Text::Xslate->new(path => {
        'root/index.tx' => '<body>Hello <: $type :> World!</body>'
    });
}

package main;
HelloApp::Render->to_app;

__END__

=pod

=head1 NAME

render.psgi - renderメソッドを使ってみる

=cut
