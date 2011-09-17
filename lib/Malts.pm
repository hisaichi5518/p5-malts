package Malts;
use 5.008_001;
use strict;
use warnings;

use Encode ();

our $VERSION = '0.01';

{
    my $context;
    sub context     { $context }
    sub set_context { $context = $_[1] }
}

sub startup {}

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless {%args}, $class;
}

sub app_base_class {
    my $self = shift;
    return $self->{app_base_class} if $self->{app_base_class};

    ($self->{app_base_class}) = (ref($self) =~ m/(.+)(::[A-Za-z0-9]+)$/);
    return $self->{app_base_class};
}

sub app_class {
    ref $_[0];
}

sub boostrap {
    my $class = shift;
    Malts->set_context($class->new(@_));
}

sub encoding {
    my ($self, $encoding) = @_;

    return $self->{encoding}
        if !$encoding && exists $self->{encoding};

    $self->{encoding} = Encode::find_encoding($encoding || 'utf8')
        or die "encoding '$encoding' not found";

    return $self->{encoding};
}

sub config {
    my $self = shift;
    # Initialize
    $self->{config} ||= {};

    # Hash
    return $self->{config} unless @_;

    # Get
    return $self->{config}->{$_[0]} unless @_ > 1 || ref $_[0];

    # Set
    my $values = ref $_[0] ? $_[0] : {@_};
    for my $key (keys %$values) {
        $self->{config}->{$key} = $values->{$key};
    }

    return $self->{config};
}

1;
__END__

=encoding utf8

=head1 NAME

Malts - 次世代 Web Application Framework

=head1 SYNOPSIS

    # TODO

=head1 DESCRIPTION

Malts is ...!

=head1 METHODS

=head2 C<new>

    MyApp->new;
    MyApp->new(%args);
    MyApp->new(mode => 'test');

アプリケーションのインスタンスを作成します。

=head2 C<app_base_class>

    $app_base_class = $c->app_base_class;

MyApp::Webで呼び出した場合、MyAppを返します。

=head2 C<app_class>

    $app_class = $c->app_class;

MyApp::Webで呼び出した場合、MyApp::Webを返します。

=head2 context

    Malts->context;

コンテキストを取り出します。Malts::Web::Requestなどでcontextを使う場合に使用します。

=head2 set_context

    Malts->set_context($context);
    Mlats->set_context(Malts->new);

コンテキストをセットします。

=head2 C<startup>

    $c->startup;

アプリケーションにおける主要フックです。アプリケーション開始時に呼び出されます。

=head2 C<boostrap>

    MyApp->boostrap;
    MyApp->boostrap(mode => test);

newした後にset_contextする。

=head2 C<encoding>

    $c->encoding;
    $c->encoding($encoding);
    $c->encoding('utf8');

渡した文字コードをEncode::find_encoding()したものが返される。

文字コードが存在しない場合はエラーを返す。

デフォルトは、utf8

B<変更は推奨されない>が、携帯サイトの場合はその限りではない。

=head2 C<config>

    $config = $c->config;

    # set
    $c->config($config_name => $config_value);
    $c->config(name => 'hisaichi5518');

    # get
    $c->config($config_name);
    $name = $c->config('name');

設定を返します。

C<Malts::Plugin::ConfigLoader>プラグインを使って、設定ファイルを読み込む事が可能です。

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
