package Malts::Web;
use strict;
use warnings;

use Malts::Web::Request;
use Malts::Web::Response;
use Malts::Util ();
use Log::Minimal qw(debugf croakf croakff);
use Malts::Hook;
use URI::Escape;

sub html_content_type { 'text/html; charset=UTF-8' }
sub request { $_[0]->{request}  }
sub req { $_[0]->{request} }

sub create_request {
    my ($self, $env) = @_;
    $self->{request} = Malts::Web::Request->new($env);

    return $self->{request};
}

sub create_response {
    my $self = shift;
    return Malts::Web::Response->new(@_);
}

sub to_app {
    my ($class, %args) = @_;
    croakf "Please inherited the 'Malts' in $class."
        if !$class->can('new') or !$class->can('startup');

    return sub {
        my $env = shift;

        my $self = $class->new(%args);
        Malts->set_context($self);
        $self->create_request($env);

        Malts::Util::DEBUG && debugf "do $class->startup!";
        $self->startup();

        my $res;
        hook->run(before_dispatch => $self, \$res);
        if (!$res) {
            $res = $self->dispatch;
            unless ($res) {
                croakf 'You must create a response!';
            }
        }

        hook->run(after_dispatch => $self, $res);
        return $res->finalize;
    };
}

sub render {
    my ($self, $status, $template_path, $opts) = @_;
    Malts::Util::DEBUG && debugf "Rendering template: $template_path";

    my $decoded_html = $self->view->render($template_path, $opts);
    hook->run(html_filter => $self, \$decoded_html);
    my $str = $self->encoding->encode($decoded_html);

    return $self->create_response(
        $status,
        [
            'Content-Type'   => $self->html_content_type,
            'Content-Length' => length($str),
        ],
        [$str]
    );
}

sub render_string {
    my ($self, $status, $decoded_html) = @_;
    Malts::Util::DEBUG && debugf "Rendering string: $decoded_html";
    hook->run(html_filter => $self, \$decoded_html);

    my $str = $self->encoding->encode($decoded_html);
    return $self->create_response(
        $status,
        [
            'Content-Type'   => $self->html_content_type,
            'Content-Length' => length($str),
        ],
        [$str]
    );
}

sub uri_for {
    my ($self, $path, $query) = @_;
    my $root = $self->req->_uri_base;
    $root =~ s{([^/])$}{$1/};
    $path =~ s{^/}{};

    my @q;
    my $enc = $self->encoding;
    for my $key (keys %$query) {
        my $val = $query->{$key};
        $val = URI::Escape::uri_escape($enc->encode($val));
        push @q, "${key}=${val}";
    }
    $root . $path . (scalar @q ? '?' . join('&', @q) : '');
}

# hooks
sub dispatch {}
sub view {
    croakff 'Method "view" not implemented by subclass';
}

# shortcut
sub args { shift->request->args }
sub param {
    my $self = shift;
    $self->request->param(@_);
}

1;
__END__

=encoding utf8

=head1 NAME

Malts::Web - 次世代 Web Application Framework

=head1 SYNOPSIS

    package MyApp::Web;
    use strict;
    use warnings;
    use parent qw(Malts Malts::Web);

    sub startup {
        my $self = shift;
        $self->create_response(200, [], 'hello Malts world');
    }

=head1 METHODS

以下のメソッドは、 L<Malts> (または L<Malts> が継承されたクラス)が継承されているクラスで使用される事が前提になっています。

=head2 C<< $c->html_content_type -> Str >>

    my $content_type = $c->html_content_type;

"text/html; charset=UTF-8"を返します。

=head2 C<< $c->view -> Object >>

    my $view = $c->view;
    $c->view(Text::Xslate->new);

=head2 C<< $c->request -> Object >>

    my $req = $c->request;

C< $c->{request} >のショートカット

=head2 C<< $c->req -> Object >>

    $c->req;

C<$c->request>のショートカット

=head2 C<< $c->create_request(\%env) -> Object >>

    $req = $c->create_request({PATH_INFO => '/'});

C< Malts::Web::Request >のインスタンス化を行い、オブジェクトをC< $c->{request} >に代入する。

=head2 C<< $c->create_response($status[, \@headers[, \@bodys]]) -> Object >>

    $res = $c->create_response(200, ['Content-Type' => 'text/html; charset=UTF-8'], ['ok']);

C< Malts::Web::Response >にインスタンス化を行います。

=head2 C<< $class->to_app(%args) -> CodeRef >>

    my $app = MyApp::Web->to_app();

アプリのコードリファレンスを返します。

=head2 C<< $c->render($status, $template_path[, \%args]) -> Object >>

    $res = $c->render(200, 'root/index.tx', {foo => 'bar'});

C< $c->render() >を使用するには、C< $c->view() >を指定している必要があります。

    sub view {
        state $view = Text::Xslate->new(...);
        return $view;
    }

=head2 C<< $c->render_string($status, $decoded_str) -> Object >>

    $res = $c->render_string(200, "ok!");

Responseオブジェクトを返します。

=head2 C<< $c->uri_for($path[, \%query]) >>

    $c->uri_for('/', {hoge => 1});

このメソッドは、変更する可能性があります。

=head2 C<< $c->dispatch >>

    $c->dispatch;

C<dispatch>は必ずResponseオブジェクトを返さなければなりません。

以下のように上書きして使います。

    sub dispatch {
        my $c = shift;
        MyApp::Web::Dispatcher->dispatch($c) or $c->create_response(404, [], ['ERROR!']);
    }

=head2 C<< $c->param([$param_name]) -> ArrayRef or Str >>

L<Plack::Request>のparamメソッドへのショートカットです。

=head2 C<< $c->args -> HashRef >>

L<Malts::Web::Request>のargsメソッドへのショートカットです。

=head1 SEE ALSO

L<Plack>

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
