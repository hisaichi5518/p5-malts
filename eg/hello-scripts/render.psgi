use strict;
use warnings;

package HelloRender::Web;
use parent qw(Malts Malts::Web);
use Text::Xslate;

sub dispatch {
    my $self = shift;
    $self->render('index', {type => 'Xslate'});
}

sub view {
    Text::Xslate->new(path => {
        index => 'Hello <: $type :> World!'
    });
}
=pod

startupでviewの設定を行う。

バグの原因になるので、viewには$cを渡さない。

テンプレートのファイルパスは、"controller/action.tx"を推奨している。

=cut

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Scope::Container";
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloRender::Web->to_app;
};

__END__

=pod

=head1 NAME

render.psgi - renderメソッドを使ってみる

=cut
