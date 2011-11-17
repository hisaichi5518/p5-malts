package Malts::Web;
use strict;
use warnings;

use Malts::Web::Request;
use Malts::Web::Response;
use Plack::Util::Accessor qw(html_content_type);
use Malts::Util ();
use Log::Minimal qw(debugf croakf);

sub request  { $_[0]->{request}  }

sub new_request {
    return Malts::Web::Request->new($_[1]);
}

sub create_request {
    my ($self, $env) = @_;
    $self->{request} = $self->new_request($env);

    return $self->{request};
}

sub create_response {
    my $self = shift;
    return Malts::Web::Response->new(@_);
}

# new, startupがない場合は、Malts.pmを継承していない
sub to_app {
    my ($class, %args) = @_;

    return sub {
        my $env = shift;

        my $self = $class->new(
            html_content_type => 'text/html; charset=UTF-8',
            %args
        );
        $self->create_request($env);

        Malts::Util::DEBUG && debugf "do $class->startup!";
        $self->startup;
        my $res = $self->dispatch;
        $self->after_dispatch($res);

        unless ($res) {
            croakf 'You must create a response. use $c->create_response(), $c->render()!';
        }
        return $res->finalize;
    };
}

sub render {
    my $self = shift;
    my $status = shift;
    Malts::Util::DEBUG && debugf 'rendering template.';
    die 'You must create a view.' unless $self->view;

    my $decoed_html = $self->view->render(@_);
    return $self->create_response(
        $status,
        [
            'Content-Type'   => $self->html_content_type,
            'Content-Length' => length($decoed_html),
        ],
        [Malts::Util::encoding()->encode($decoed_html)]
    );
}

sub dispatch {}
sub view {}
sub after_dispatch {}

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

以下のメソッドは、 L<Malts> が継承されているクラスで使用される事が前提になっています。

=head2 C<< $c->html_content_type -> Str >>

    my $content_type = $c->html_content_type;
    $c->html_content_type('text/html; charset=UTF-8');

=head2 C<< $c->view -> Object >>

    my $view = $c->view;
    $c->view(Text::Xslate->new);

=head2 C<< $c->request -> Object >>

    my $req = $c->request;

C< $c->{request} >のショートカット

=head2 C<< $c->new_request(\%env) -> Object >>

    $req = $c->new_request({PATH_INFO => '/'});

C< Malts::Web::Request >のインスタンス化を行います。

=head2 C<< $c->create_request(\%env) -> Object >>

    $req = $c->create_request({PATH_INFO => '/'});

C< Malts::Web::Request >のインスタンス化を行い、オブジェクトをC< $c->{request} >に代入する。

=head2 C<< $c->create_response($status[, \@headers[, \@bodys]]) -> Object >>

    $res = $c->create_response(200, ['Content-Type' => 'text/html; charset=UTF-8'], ['ok']);

C< Malts::Web::Response >にインスタンス化を行います。

=head2 C<< $class->to_app(%args) -> CodeRef >>

    my $app = MyApp::Web->to_app(html_content_type => 'text/html; charset=UTF-8');

アプリのコードリファレンスを返します。

自動で I<html_content_type> に I<text/html; charset=UTF-8> がセットされますが、上書きする事も可能です。

=head2 C<< $c->render($status, $template_path[, \%args]) -> Object >>

    $res = $c->render(200, 'root/index.tx', {foo => 'bar'});

C< $c->render() >を使用するには、C< $c->view() >を指定している必要があります。

    sub view {
        state $view = Text::Xslate->new(...);
        return $view;
    }

=head2 C<< $c->after_dispatch($res) >>

    $c->after_dispatch($res);

上書きしてフックします。

    sub after_dispatch {
        my ($c, $res) = @_;
        $res->body("hisaichi5518");
        $c->plguin("Web::Hoge");
    }

=head2 C<< $c->dispatch >>

    $c->dispatch;

C<dispatch>は必ずResponseオブジェクトを返さなければなりません。

以下のように上書きして使います。

    sub dispatch {
        my $c = shift;
        MyApp::Web::Dispatcher->dispatch($c) or $c->create_response(404, [], ['ERROR!']);
    }

=head1 SEE ALSO

L<Plack>

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
