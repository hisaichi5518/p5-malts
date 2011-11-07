package Malts::Web::Router::Simple::Declare;
use strict;
use warnings;

use Data::Util qw(get_code_ref install_subroutine);
use Log::Minimal qw(debugf croakf);
use Malts::Util ();
use Router::Simple 0.03;

sub import {
    my $caller = scalar caller;
    my $router = Router::Simple->new;

    my $connect_with_method = sub {
        my ($method, $path, $dest, $opt) = @_;
        $opt->{method} = $method;
        if (ref $dest) {
            $router->connect($path => $dest, $opt);
        }
        elsif (!$dest) {
            $router->connect($path => {}, $opt);
        }
        else {
            my %dest;
            my ($controller, $action) = split '#', $dest;
            $dest{controller} = $controller;
            $dest{action}     = $action;
            $router->connect($path => \%dest, $opt);
        }
    };


    my $dispatch = sub {
        my ($self, $c) = @_;
        return unless my $args = $router->match($c->request->env);

        Malts::Util::DEBUG && debugf('match route! => %s', $args);

        $c->request->env->{'malts.routing_args'} = $args;
        my $action     = $args->{action};
        my $controller = $args->{controller};
        my $namespace  = ref($c).'::Controller';

        croakf "path matched route! but can't find Controller or Action!"
            if !$action || !$controller;

        $controller = Plack::Util::load_class($controller, $namespace);

        # $controller has begin method.
        if (get_code_ref($controller, 'begin')) {
            Malts::Util::DEBUG && debugf "do $controller->begin!";
            $controller->begin($c);
        }

        Malts::Util::DEBUG && debugf "Dispatching $controller->$action!";
        $controller->$action($c);

        # $controller has end method.
        if (get_code_ref($controller, 'end')) {
            Malts::Util::DEBUG && debugf "do $controller->end!";
            $controller->end($c);
        }

        return 1;
    };

    install_subroutine($caller, get => sub {
        $connect_with_method->('GET', @_);
    });
    install_subroutine($caller, post => sub {
        $connect_with_method->('POST', @_);
    });
    install_subroutine($caller, put => sub {
        $connect_with_method->('PUT', @_);
    });
    install_subroutine($caller, del => sub {
        $connect_with_method->('DELETE', @_);
    });

    install_subroutine($caller, dispatch => $dispatch);
    install_subroutine($caller, router_as_string => sub { $router->as_string });
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

=head2 C<< get($path => $dist|\%dist) >>

    get '/path' => 'Controller#action';

=head2 C<< post($path => $dist|\%dist) >>

    post '/path' => 'Controller#action';

=head2 C<< put($path => $dist|\%dist) >>

    put '/path' => 'Controller#action';

=head2 C<< del($path => $dist|\%dist) >>

    del '/path' => 'Controller#action';

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
