package Malts::Web::Router::Simple;
use strict;
use warnings;
use 5.10.1;

use Log::Minimal qw(debugf croakff);
use Malts::Util ();
use Router::Simple 0.03;
use Exporter 'import';
our @EXPORT = qw(router any get post put del submapper dispatch);

my $_ROUTER = Router::Simple->new;
sub router { $_ROUTER }

sub get  { any(['GET', 'HEAD'], @_)  }
sub post { any('POST', @_) }
sub put  { any('PUT', @_)  }
sub del  { any('DELETE', @_) }
sub submapper { $_ROUTER->submapper(@_) }

sub any {
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

sub dispatch {
    my ($class, $c) = @_;
    return unless my $args = $_ROUTER->match($c->request->env);

    if (Malts::Util::DEBUG) {
        local $Log::Minimal::AUTODUMP = 1;
        debugf('match route! => %s', $args);
    }

    $c->request->env->{'malts.routing_args'} = $args;
    my $action = $args->{action};
    if (ref $action eq 'CODE') {
        Malts::Util::DEBUG && debugf "Dispatching action(CODE)!";
        return $action->($c);
    }
    else {
        my $controller = $args->{controller};
        croakff "But can't find Controller and/or Action!: controller:'$controller', action:'$action'"
            if !$action || !$controller;
        return _run_action($c, $controller => $action);
    }
}

sub _run_action {
    my ($c, $controller, $action, @args) = @_;
    my $namespace  = (ref $c ? ref $c : $c).'::Controller';

    $controller = Plack::Util::load_class($controller, $namespace);

    Malts::Util::DEBUG && debugf "Dispatching $controller->$action!";
    return $controller->$action($c, @args);
}


1;
__END__

=encoding utf8

=head1 NAME

Malts::Web::Router::Simple - MaltsでRouter::Simpleを使う為のモジュール

=head1 SYNOPSIS

    use Malts::Web::Router::Simple;

    get  '/' => 'Root#index';
    post '/' => 'Root#post';
    put  '/' => 'Root#put';
    del '/' => 'Root#delete';
    router->as_string;

=head1 DESCRIPTION

高速なRouter Class である L<Router::Simple> を L<Malts> で使う為のクラス

=head1 METHOD

=head2 C<< router() -> Object >>

    router->connect('/');
    router->as_string;

L<Router::Simple>のオブジェクトを返す。

=head2 C<< any(\@methods, $path => $dist|\%dist|\&action) >>

    any [qw/POST GET/], '/' => 'Root#index';
    any [qw/POST GET/], '/' => {controller => 'Controller', action => 'action'};
    any [qw/POST GET/], '/' => sub {
        my $c = shift;
        ...;
    };

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

=head2 C<< submapper($path => $dist|\%dist|\&action) >>

    my $r = submapper '/user', {controller => 'User'};
    $r->connect('/:name', {action => 'name'});

=head2 C<< $class->dispatch($c) >>

    $class->dispatch($c);

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 SEE ALSO

L<Router::Simple>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
