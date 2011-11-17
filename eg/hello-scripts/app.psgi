use strict;
use warnings;

package HelloApp;
use parent 'Malts';

sub startup {
    # CLI, Web共通のプラグインなどをここで宣言する
    # startupはMaltsの中にあるので、なくても動作可能
}

=pod

HelloApp::Webが、Maltsを継承しているのであれば、今回は作成する必要はありませんが、
CLIスクリプトを作成するときに便利なので、作成した方がよいでしょう。

=cut

package HelloApp::Model::Dice;

sub new {bless {}, shift}

sub shake {
    return int(rand(5)) + 1;
}

=pod

Modelにはロジックを書きます。

どれだけ細かくてもModelに書くべきです。

メリットとして、テストがしやすい・変更がしやすいなどがあります。

=cut

package HelloApp::Web;
use parent -norequire, 'HelloApp';
use parent 'Malts::Web';
use Text::Xslate;
use Class::Method::Modifiers::Fast;

sub dispatch {
    my $self = shift;
    HelloApp::Web::Dispatcher->dispatch($self) or return $self->create_response(404, [], ['Not Found!']);
};

sub view {
    Text::Xslate->new(
        path => {'root/index.tx' => '<: $user :> DICE: <: $dice_num :>'}
    );
}

=pod

HelloAppから継承したstartupをafterで拡張します。

そこでWeb専用のプラグインやviewの設定を行います。viewはTiffanyプロトコルに合ったものであればなんでも大丈夫です。

Viewに$cをそのまま渡すとメモリリークします。$cを渡すとゴチャゴチャになっていいことないのでオススメしません。

NOTE: ルーティングについて変更の可能性あり

=cut

package HelloApp::Web::Dispatcher;
use Malts::Web::Router::Simple::Declare;

get '/' => 'Root#index';

=pod

routesを指定する。

=cut

package HelloApp::Web::Controller::Root;
# HACK for Plack::Util::load_class()
$INC{'HelloApp/Web/Controller/Root.pm'} = __FILE__;

sub index {
    my ($self, $c) = @_;
    my $dice = HelloApp::Model::Dice->new(user => 'hisaichi');
    my $dice_num = $dice->shake;
    $c->render(200, 'root/index.tx', {user => $dice->{user}, dice_num => $dice_num});
}

=pod

Controllerは、Modelが出した結果をViewに渡すだけと考えると分かりやすいです。

めんどくさいとControllerにロジックを書いてしまいがいちですが、それは間違いです。Modelに書きましょう。

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
