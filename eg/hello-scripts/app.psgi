use strict;
use warnings;
use 5.10.1;

package HelloApp;
use parent 'Malts';

sub startup {
    # CLI, Web共通のプラグインなどをここで宣言する
    # startupはMaltsの中にあるので、なくても動作可能
}

=pod

HelloApp::Webが、Maltsを継承している場合は作成する必要はないが、
CLIスクリプトを作成するときに便利なので、作成した方がよい。

=cut

package HelloApp::Model::Dice;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub shake {
    return int(rand(5)) + 1;
}

=pod

Modelにはロジックを書く。ロジックはどれだけ細かくてもModelに書くべき。

メリットとして、テストがしやすい・変更がしやすいなどがあげられる。

またModelはDBに関するものだけではなく、Web APIやその他色々もModelに書く。

=cut

package HelloApp::Web;
use parent -norequire, 'HelloApp';
use parent 'Malts::Web';
use Text::Xslate;

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

=pod

Web専用のプラグインなど呼びたい場合は、継承されたstartupメソッドを拡張します。

HelloAppから継承したstartup拡張する場合は、Class::Method::Modifiers::Fast#afterなどで拡張する。

dispatchメソッドは、必ずresponseオブジェクトを返さなければなりません。

viewはTiffanyプロトコルに合ったものであればなんでも大丈夫です。myではなくstateを使用すると効率的です。

res_200, res_404は作らなくても動作しますが、作ったほうが分かりやすいので作りましょう。

=cut

package HelloApp::Web::Dispatcher;
use Malts::Web::Router::Simple::Declare;

get '/' => 'Root#index';

=pod

routes.psgi参照

=cut

package HelloApp::Web::Controller::Root;
# HACK for Plack::Util::load_class()
# ファイルを分けた場合は必要ないが、このサンプルの場合は分けていないので必要。
$INC{'HelloApp/Web/Controller/Root.pm'} = __FILE__;

sub index {
    my ($self, $c) = @_;
    my $dice = HelloApp::Model::Dice->new(user => 'hisaichi');
    my $dice_num = $dice->shake;
    $c->res_200('root/index.tx', {dice_user => $dice->{user}, dice_num => $dice_num});
}

=pod

Controllerは、Modelが出した結果をViewに渡すだけと考える。

Controllerにロジックを書いてしまいがちだがModelに書く。

=cut

package main;
use Plack::Builder;

builder {
    enable "Plack::Middleware::Scope::Container";
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloApp::Web->to_app;
};

__END__

=encoding utf8

=head1 NAME

app.psgi - DICEを振る

=cut
