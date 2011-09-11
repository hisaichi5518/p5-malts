package Malts::Web;
use strict;
use warnings;

use Malts::Web::Request;
use Malts::Web::Response;
use Plack::Util::Accessor qw(html_content_type);
use Plack::Util ();

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

sub routes {
    my ($self, $name, %args) = @_;
    return $self->{routes} unless $name;
    $self->{routes} = Plack::Util::load_class($name, 'Malts::Web::Routes')->new(%args);

    return $self->{routes};
}

sub to_app {
    my ($class, %args) = @_;

    return sub {
        my $env = shift;

        # Malts.pmを継承してるクラスで使う前提
        my $self = $class->new(
            html_content_type => 'text/html; charset=UTF-8',
            %args
        );
        $self->create_request($env);

        # Malts.pmを継承してるモジュールで使われる前提なので
        # このクラスにstartupがなくても問題ない
        $self->startup;

        $self->routes->dispatch($self) if $self->routes;

        die 'You must create a response.' unless $self->response;
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

    pacakage MyApp;
    use strict;
    use warnings;
    use parent 'Malts';

    package MyApp::Web;
    use strict;
    use warnings;
    use parent -norequire, 'MyApp';
    use parent 'Malts::Web';
    use Class::Method::Modifiers::Fast qw(after);

    after startup => sub {
        my $self = shift;
        $self->ok('hello Malts world');
    };

=head1 DESCRIPTION

Malts is ...!

=head1 METHODS

=head2 html_content_type

    $content_type = $c->html_content_type;
    $c->html_content_type('text/html; charset=UTF-8');

=head2 C<request>

    $req = $c->request;

$c->create_request;された後ならRequestクラスのインスタンスを返す。

=head2 C<response>

    $res = $c->response;

$c->create_response;された後ならResponseクラスのインスタンスを返す。

=head2 C<new_request>

    $req = $c->new_request(\%env);
    $req = $c->new_request({PATH_INFO => '/'});

Requestクラスのインスタンスを返す。

=head2 C<new_response>

    $res = $c->new_response;
    $res = $c->new_response($status);
    $res = $c->new_response($status, \%headers);
    $res = $c->new_response($status, \%headers, $body);
    $res = $c->new_response($status, \%headers, \@bodys);
    $res = $c->new_response(200, ['Content-Type' => 'text/html; charset=UTF-8'], ['ok']);

Responseクラスのインスタンスを返す。

=head2 C<create_request>

    $req = $c->create_request(\%env);
    $req = $c->create_request({PATH_INFO => '/'});

Requestクラスのインスタンス作成し $c->request;に代入する。

=head2 C<create_response>

    $res = $c->create_response;
    $res = $c->create_response($status);
    $res = $c->create_response($status, \%headers);
    $res = $c->create_response($status, \%headers, $body);
    $res = $c->create_response($status, \%headers, \@bodys);
    $res = $c->create_response(200, ['Content-Type' => 'text/html; charset=UTF-8'], ['ok']);

Responseクラスのインスタンス作成し $c->response;に代入する。

=head2 C<routes>

    $r = $c->routes;
    $r = $c->routes($routes_class);
    $r = $c->routes('RSimple');

$routes_classがあれば、ロードしてnewした後にRoutes Classを返す。

=head2 C<to_app>

    $app = MyApp::Web->to_app;
    $app = MyApp::Web->to_app(%args);
    $app = MyApp::Web->to_app(html_content_type => 'text/html; charset=UTF-8');

PSGIアプリのコードリファレンスを返します。

自動で I<html_content_type> に I<text/html; charset=UTF-8> がセットされまが、上書きする事も可能です。

=head2 ok

    $res = $c->ok($decoed_html);
    $res = $c->ok('<html>ok</html>'):

Status: 200のResponseのインスタンスを返します。

=head2 not_found

    $res = $c->not_found;
    $res = $c->not_found($not_found_message);
    $res = $c->not_found('<html>404!</html>');

Status: 404のResponseクラスのインスタンスを返します。

=head1 SEE ALSO

L<Plack>

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
