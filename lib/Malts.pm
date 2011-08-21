package Malts;
use 5.008_001;
use strict;
use warnings;

use Encode ();
use Plack::Request;
use Plack::Response;

use Plack::Util::Accessor qw(html_content_type);

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless {%args}, $class;
}

sub encoding {
    my ($self, $encoding) = @_;

    return $self->{encoding}
        if !$encoding && exists $self->{encoding};

    $self->{encoding} = Encode::find_encoding($encoding || 'utf8')
        or die "encoding '$encoding' not found";

    return $self->{encoding};
}

sub request { $_[0]->{request} }

sub response { $_[0]->{response} }

sub new_request {
    return Plack::Request->new($_[1]);
}

sub new_response {
    shift;
    return Plack::Response->new(@_);
}

sub create_request {
    my ($self, $env) = @_;
    $self->{request} = $self->new_request($env);

    return $self->{request};
}

sub create_response {
    my $self = shift;
    $self->{response} = $self->new_response(@_);

    return $self->{response};
}

sub to_app {
    my ($class, %args) = @_;

    return sub {
        my $env = shift;
        my $self = $class->new(%args);
        $self->create_request($env);
        $self->create_response(200, [], 'ok');
        return $self->response->finalize;
    };
}

sub ok {
    my ($self, $decoed_html) = @_;
    die "Can't find html." unless $decoed_html;

    my $content_type = $self->html_content_type || 'text/html; charset=UTF-8';
    return $self->create_response(
        200,
        [
            'Content-Type'   => $content_type,
            'Content-Length' => length($decoed_html),
        ],
        [$self->encoding->encode($decoed_html)]
    );
}

1;
__END__

=encoding utf8

=head1 NAME

Malts - 次世代 Web Application Framework

=head1 SYNOPSIS

    package MyApp::Web;
    use strict;
    use warnings;
    use parent 'Malts';

    sub startup {
        my $self = shift;
        $self->create_response(200, [], ['Hello, World!']);
    }

=head1 DESCRIPTION

Malts is ...!

=head1 ATTRIBUTES

=head2 html_content_type

    $c->html_content_type;
    $c->html_content_type('text/html; charset=UTF-8');

=head1 METHODS

=head2 C<encoding>

    $c->encoding;
    $c->encoding('utf8');
    $c->encoding('shift-jis');


渡した文字コードをEncode::find_encoding()したものが返される。

文字コードが存在しない場合はエラーを返す。

デフォルトは、utf8

B<変更は推奨されない>が、携帯サイトの場合はその限りではない。

=head2 C<request>

    $c->request;

$c->create_request;された後ならRequestクラスのインスタンスを返す。

=head2 C<response>

    $c->response;

$c->create_response;された後ならResponseクラスのインスタンスを返す。

=head2 C<new_request>

    $c->new_request({PATH_INFO => '/'});

Requestクラスのインスタンスを返す。

=head2 C<new_response>

    $c->new_response;
    $c->new_response($status);
    $c->new_response($status, \%headers);
    $c->new_response($status, \%headers, $body);
    $c->new_response($status, \%headers, \@bodys);

Responseクラスのインスタンスを返す。

=head2 C<create_request>

    $c->create_request({PATH_INFO => '/'});

Requestクラスのインスタンス作成し $c->request;に代入する。

=head2 C<create_response>

    $c->create_response;
    $c->create_response($status);
    $c->create_response($status, \%headers);
    $c->create_response($status, \%headers, $body);
    $c->create_response($status, \%headers, \@bodys);

Responseクラスのインスタンス作成し $c->response;に代入する。

=head2 C<to_app>

    MyApp::Web->to_app;

PSGIアプリのコードリファレンスを返します。

=head2 ok

    $c->ok($decoed_html);

Status: 200のResponseのインスタンスを返します。

=head1 SEE ALSO

L<Plack>

=head1 Repository

  http://github.com/hisaichi5518/p5-malts

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
