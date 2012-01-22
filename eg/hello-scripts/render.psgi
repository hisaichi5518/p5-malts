use strict;
use warnings;

package HelloRender::Web;
use parent qw(Malts Malts::Web);
use Text::Xslate;

sub dispatch {
    my $self = shift;
    $self->render(200, 'index', {type => 'Xslate'});
}

sub view {
    Text::Xslate->new(path => {
        index => 'Hello <: $type :> World!'
    });
}
=pod

viewの設定は、継承されたviewメソッドの上書きで行う。

テンプレートのファイルパスは、"$controller/$action.tx"を推奨している。

またrenderはControllerで直接呼ぶのは推奨されていない。以下の様にres_200()やres_404()などステータス毎にメソッドを作る事が推奨されている。

    package MyApp::Web;
    use parent qw(Malts Malts::Web);

    sub res_200 {
        my $c = shift;
        $c->render(200, @_);
    }

    sub res_404 {
        my ($c, $message) = @_;
        $c->render_string(404, $message || '404 Not Found!');
    }

=cut

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Scope::Container";
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloRender::Web->to_app;
};

=pod

Plack::Middleware::Scope::Containerは、$c->render()の中で使われているメソッド(encoding)で使用されているため必須。

またこれは、render_stringでも同様である。

=cut



__END__

=pod

=head1 NAME

render.psgi - renderメソッドを使ってみる

=cut
