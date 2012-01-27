package Malts::Web::Router::Simple::Declare;
use strict;
use warnings;
use 5.10.1;

use Log::Minimal qw(debugf croakff);
use Malts::Util ();
use Router::Simple 0.03;
use Exporter 'import';
our @EXPORT = qw(get post put del dispatch router_as_string);

my $_ROUTER = Router::Simple->new;

sub get  { _connect_with_method('GET', @_);  }
sub post { _connect_with_method('POST', @_); }
sub put  { _connect_with_method('PUT', @_);  }
sub del  { _connect_with_method('DELETE', @_); }

sub router_as_string {
    $_ROUTER->as_string;
}

sub dispatch {
    my ($class, $c) = @_;
    return unless my $args = $_ROUTER->match($c->request->env);

    Malts::Util::DEBUG && debugf('match route! => %s', $args);

    $c->request->env->{'malts.routing_args'} = $args;
    my $action     = $args->{action};
    if (ref $action eq 'CODE') {
        Malts::Util::DEBUG && debugf "Dispatching action(CODE)!";
        return $action->($c);
    }
    else {
        my $controller = $args->{controller};
        my $namespace  = ref($c).'::Controller';

        croakff "path matched route! but can't find Controller or Action!"
        if !$action || !$controller;

        $controller = Plack::Util::load_class($controller, $namespace);

        Malts::Util::DEBUG && debugf "Dispatching $controller->$action!";
        return $controller->$action($c);
    }
}

sub _connect_with_method {
    my ($method, $path, $dest, $opt) = @_;
    $opt->{method} = $method;
    if (ref $dest eq 'HASH') {
        $_ROUTER->connect($path => $dest, $opt);
    }
    elsif (ref $dest eq 'CODE') {
        $_ROUTER->connect($path => {
            action => $dest,
        }, $opt);
    }
    elsif (!$dest) {
        $_ROUTER->connect($path => {}, $opt);
    }
    else {
        my %dest;
        my ($controller, $action) = split '#', $dest;
        $dest{controller} = $controller;
        $dest{action}     = $action;
        $_ROUTER->connect($path => \%dest, $opt);
    }
}

1;
__END__

=encoding utf8

=head1 NAME

Malts::Web::Router::Simple - MaltsでRouter::Simpleを使う為のモジュール

=head1 SYNOPSIS

    use Malts::Web::Router::Simple::Declare;

    get  '/' => 'Root#index';
    post '/' => 'Root#post';
    put  '/' => 'Root#put';
    del '/' => 'Root#delete';

=head1 DESCRIPTION

高速なRouter Class である L<Router::Simple> を L<Malts::Web> で使う為のクラス

=head1 METHOD

=head2 C<< get($path => $dist|\%dist|\&action) >>

    get '/path' => 'Controller#action';
    get '/' => {controller => 'Controller', action => 'action'};
    get '/' => sub {
        my $c = shift;
        ...;
    };

=head2 C<< post($path => $dist|\%dist|\&action) >>

    post '/path' => 'Controller#action';
    post '/' => {controller => 'Controller', action => 'action'};
    post '/' => sub {
        my $c = shift;
        ...;
    };

=head2 C<< put($path => $dist|\%dist|\&action) >>

    put '/path' => 'Controller#action';
    put '/' => {controller => 'Controller', action => 'action'};
    put '/' => sub {
        my $c = shift;
        ...;
    };

=head2 C<< del($path => $dist|\%dist|\&action) >>

    del '/path' => 'Controller#action';
    del '/' => {controller => 'Controller', action => 'action'};
    del '/' => sub {
        my $c = shift;
        ...;
    };

=head2 C<< $class->dispatch($c) >>

    $class->dispatch($c);

=head2 C<< router_as_string() >>

    router_as_string;

どのようなPATH_INFOにマッチするかを表示します。

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO

L<Router::Simple>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
