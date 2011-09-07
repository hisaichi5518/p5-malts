package Malts::Web;
use strict;
use warnings;

use parent 'Malts';
use Malts::Web::Request;
use Malts::Web::Response;
use Plack::Util::Accessor qw(html_content_type);

sub new {
    my ($class, %args) = @_;
    $class->SUPER::new(
        html_content_type => 'text/html; charset=UTF-8',
        %args
    );
}

sub request  { $_[0]->{request}  }
sub response { $_[0]->{response} }

sub new_request {
    return Malts::Web::Request->new($_[1]);
}

sub new_response {
    shift;
    return Malts::Web::Response->new(@_);
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
        $self->ok('ok');
        return $self->response->finalize;
    };
}

sub ok {
    my ($self, $decoed_html) = @_;
    die "Can't find html." unless defined $decoed_html;

    my $content_type = $self->html_content_type;
    return $self->create_response(
        200,
        [
            'Content-Type'   => $content_type,
            'Content-Length' => length($decoed_html),
        ],
        [$self->encoding->encode($decoed_html)]
    );
}

sub not_found {
    my ($self, $not_found_message) = @_;

    $not_found_message ||= "404 Not Found!";
    return $self->create_response(
        404,
        ['Content-Length' => length($not_found_message)],
        [$self->encoding->encode($not_found_message)]
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
    use parent 'Malts::Web';

    sub startup {
        my $self = shift;
        $self->ok('Hello, World!');
    }

=head1 DESCRIPTION

Malts is ...!

=head1 ATTRIBUTES

=head2 html_content_type

    $c->html_content_type;
    $c->html_content_type('text/html; charset=UTF-8');

=head1 METHODS

このモジュールは、L<Malts>を継承している。

=head2 C<new>

    MyApp->new;
    MyApp->new(html_content_type => 'text/html; charset=UTF-8');

アプリケーションのインスタンスを作成します。

html_content_typeの初期値もここで設定されます。

=head2 C<request>

    $c->request;

$c->create_request;された後ならRequestクラスのインスタンスを返す。

=head2 C<response>

    $c->response;

$c->create_response;された後ならResponseクラスのインスタンスを返す。

=head2 C<new_request>

    $c->new_request(\%env);

Requestクラスのインスタンスを返す。

=head2 C<new_response>

    $c->new_response;
    $c->new_response($status);
    $c->new_response($status, \%headers);
    $c->new_response($status, \%headers, $body);
    $c->new_response($status, \%headers, \@bodys);

Responseクラスのインスタンスを返す。

=head2 C<create_request>

    $c->create_request(\%env);

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

=head2 not_found

    $c->not_found;
    $c->not_found($not_found_message);

Status: 404のResponseクラスのインスタンスを返します。

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
