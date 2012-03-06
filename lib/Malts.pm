package Malts;
use 5.10.1;
use strict;
use warnings;

use Encode ();
use File::Spec ();
use Log::Minimal qw(debugf croakff);
use Malts::Util ();

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless {%args}, $class;
}

# copied Amon2::Util::base_dir
sub app_dir {
    state $app_dir = do {
        my $path = $_[0]->app_base_class;
        $path =~ s!::!/!g;

        if (my $libpath = $INC{"$path.pm"}) {
            $libpath =~ s!(?:blib/)?lib/+$path\.pm$!!;
            File::Spec->rel2abs($libpath || './');
        }
        else {
            File::Spec->rel2abs('./');
        }
    };
}

sub boostrap {
    my $class = shift;
    my $self = $class->new(@_);
    $self->startup;
    return $self;
}

sub encoding {
    state $encoding = Malts::Util::find_encoding('utf8');
    return $encoding;
}

# hooks
sub config {}
sub app_base_class {
    croakff 'Method "app_base_class" not implemented by subclass';
}
sub startup {}

1;
__END__

=encoding utf8

=head1 NAME

Malts - 次世代 Web Application Framework

=head1 SYNOPSIS

    package MyApp;
    use strict;
    use warnings;
    use parent 'Malts';

    sub startup {
        my ($self) = @_;
    }

    1;

=head1 DESCRIPTION

B<Maltsは、まだ不安定です。大きな変更が告知なしで実行される段階です。使用は控えてください。>

Maltsは、必要最低限の機能のみを実装したウェブアプリケーションフレームワークです。

とても小さく、分かりやすいがMaltsのコンセプトです。

Maltsをもっと便利に使いたい場合は、L<Malts::Style>, L<拡張について|https://github.com/malts/p5-malts/wiki/%E6%8B%A1%E5%BC%B5%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6> を参照してください。

=head1 METHODS

C< $class >はMaltsを継承したクラスとして説明していきます。

C< $object >はC< $class->new() >で作成されたオブジェクトです。

=head2 C<< $class->new(%args|\%args) -> Object >>

    my $object = $class->new;
    $object = $class->new(%args);
    $object = $class->new(\%args);

C< $class >のインスタンス化を行います。

=head2 C<< $object->app_base_class >>

    my $app_base_class = $c->app_base_class;

アプリケーションのベースクラスを返します。しかし、そのままでは使用する事が出来ず、アプリケーション側で設定する必要があります。

設定は、メソッドを上書きする事で出来ます。

    package MyApp;
    use parent 'Malts';
    sub app_base_class { 'MyApp' }

C<app_base_class>を上書きしないままC<app_base_class>を実行するとエラーが出ます。

=head2 C<< $object->app_dir -> Str >>

    my $app_dir = $c->app_dir;

アプリケーションディレクトリを返します。

=head2 C<< $object->startup >>

    sub startup {
        my ($object) = @_;
        $object->app_dir;
    }

アプリケーションにおける主要フックです。アプリケーション開始時に呼び出されます。

=head2 C<< $class->boostrap(%args|\%args) -> Object >>

    my $object = $class->boostrap;
    $object = $class->boostrap(%args);
    $object = $class->boostrap(\%args);

C< $class >をインスタンス化したあとにstartupを実行します。

=head2 C<< $object->encoding($encoding) -> Object >>

    my $encoding = $object->encoding;
    $encoding = $object->encoding($encoding);

C<Malts::Util::encoding()>へのショートカット

=head2 C<< $object->config -> HashRef >>

    my $config = $c->config;

    # get
    $c->config->{name};

configメソッドを使うには上書きが必須です。
L<Config::ENV>を使う事が現在推奨されています。

    sub config {
        MyApp::Config->current;
    }

C<Malts::ConfigLoader>を使って、設定ファイルを読み込む事も可能です。

    sub config {
        state $config = do {
            my @config_path = ($_[0]->app_dir, 'config', 'development.pl');
            Malts::ConfigLoader->load(@config_path);
        };
    }

=head1 SEE ALSO

L<Plack>, L<Amon2>, L<Mojolicious>

=head1 Repository

  http://github.com/hisaichi5518/p5-malts

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
