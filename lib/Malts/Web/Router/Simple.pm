package Malts::Web::Router::Simple;
use 5.10.1;
use strict;
use warnings;

use Exporter 'import';
use Router::Simple;
use Malts::App;

our @EXPORT = qw(any get post put del dispatch);

sub _router {
    my ($class, $pkg) = @_;
    my ($name) = split '::Dispatcher', $pkg;

    Malts::App->routers->{$name} ||= Router::Simple->new();
}

sub get {
    my $caller = caller(0);
    __PACKAGE__->_add_router($caller, ['GET', 'HEAD'], @_);
}

sub post {
    my $caller = caller(0);
    __PACKAGE__->_add_router($caller, 'POST', @_);
}

sub put {
    my $caller = caller(0);
    __PACKAGE__->_add_router($caller, 'PUT', @_);
}

sub del {
    my $caller = caller(0);
    __PACKAGE__->_add_router($caller, 'DELETE', @_);
}

sub any {
    my $caller = caller(0);
    __PACKAGE__->_add_router($caller, @_);
}

sub _add_router {
    my ($class, $caller, $method, $path, $dest, $opt) = @_;
    my $router = __PACKAGE__->_router($caller); # use Malts::Web::Router::Simple;した場所

    # 初期化
    $opt->{method} = $method;

    if (ref $dest eq 'HASH') {
        $router->connect($path => $dest, $opt);
    }
    elsif (ref $dest eq 'CODE') {
        $router->connect($path => {
            action => $dest,
        }, $opt);
    }
    else {
        my %dest;
        my ($controller, $action) = split '#', $dest;
        $dest = {controller => $controller, action => $action};
        $router->connect($path => $dest, $opt);
    }
}

sub dispatch {
    my ($class, $c) = @_;
    my $router = __PACKAGE__->_router($class);
    my $args   = $router->match($c->request->env);

    return unless $args;
    $c->request->env->{'malts.routing_args'} = $args;

    my $action = $args->{action};
    if (ref $action eq 'CODE') {
        return $action->($c);
    }
    else {
        my $controller = $args->{controller};
        my $namespace  = $c->controller_base_name;

        $controller = Plack::Util::load_class($controller, $namespace);
        return $controller->$action($c);
    }
}

1;
__END__

=encoding utf8

=head1 FUNCTIONS

=head2 C<< get >>

=head2 C<< post >>

=head2 C<< put >>

=head2 C<< del >>

=head2 C<< any >>

=head1 METHODS

=head2 C<< $class->dispatch >>

=cut
