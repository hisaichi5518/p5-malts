package Malts::Web::Routes::RSimple;
use strict;
use warnings;

use parent "Router::Simple";
use Data::Util qw(get_code_ref);

sub dispatch {
    my ($self, $c) = @_;
    return unless my $args = $self->match($c->request->env);

    $c->request->env->{'slug.routing_args'} = $args;
    my $action     = $args->{action};
    my $controller = $args->{controller};
    my $namespace  = $args->{namespace} || $self->{namespace} || ref($c).'::Controller';

    die "path matched route! but can't find Controller or Action!"
        if !$action || !$controller;

    $controller = Plack::Util::load_class($controller, $namespace);

    # $controller has begin method.
    if (get_code_ref($controller, 'begin')) {
        $controller->begin($c);
    }

    $controller->$action($c);

    # $controller has end method.
    if (get_code_ref($controller, 'end')) {
        $controller->end($c);
    }
}

1;
__END__

=encoding utf8

=head1 NAME

Malts::Web::Routes::RSimple - MaltsでRouter::Simpleを使う為のモジュール

=head1 SYNOPSIS

    use Malts::Web::Routes::RSimple;
    my $r = Malts::Web::Routes::RSimple->new;

    $r->connect('/' => {controller => "Root", action => "index"});

=head1 DESCRIPTION

高速なRouter Class である L<Router::Simple> を L<Malts::Web> で使う為のクラス

=head1 METHOD

L<Router::Simple> を継承している。

=head2 dispatch

    $c->dispatch($c);

=over 3

=item namespace

MyApp::Web::Controller 以下にコントローラを置きたくない場合に使う。

これはnew でも指定する事が出来るが、argsで指定したほうが優先される。

デフォルトは、 I<MyApp::Web::Controller>

=item controller

コントローラを指定する。

一番前に「 + 」を付けるとnamespaceが無視される。

controllerが指定されていないと404を返す。

=item action

アクションを指定する。

actionが指定されていないと404を返す。

=back

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO

L<Router::Simple>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
