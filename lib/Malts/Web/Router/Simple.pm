package Malts::Web::Router::Simple;
use 5.10.1;
use strict;
use warnings;

use Exporter 'import';
use Router::Simple;
use Malts::App;

our @EXPORT = qw(any get post put del dispatch mount);
my $pkg = __PACKAGE__;


sub _router {
    my ($class, $caller) = @_;
    Malts::App->routers->{$caller} ||= Router::Simple->new();
}

sub get {
    $pkg->_add_route(['GET', 'HEAD'], @_);
}

sub post {
    $pkg->_add_route('POST', @_);
}

sub put {
    $pkg->_add_route('PUT', @_);
}

sub del {
    $pkg->_add_route('DELETE', @_);
}

sub any {
    $pkg->_add_route(@_);
}

sub mount {
    my ($prefix, $name) = @_;
    my $caller = caller(0);
    $pkg->_mount($caller, $prefix, $name);
}

sub _mount {
    my ($class, $caller, $prefix, $name) = @_;

    my $klass  = Plack::Util::load_class($name, $caller);
    my $router = $class->_router($caller);

    $router->{mount}->{$name} = $prefix;

    $router->connect(
        $prefix.'{_mount_path:(?:/(?:.+)?)?}'
            => {mount => $klass},
    );
}

}

sub _add_route {
    my ($class, $method, $path, $dest, $opts) = @_;
    my $caller = caller(1);
    my $router = $pkg->_router($caller); # use Malts::Web::Router::Simple;した場所

    # 初期化
    $opts->{method} = $method;

    $dest = $class->_build_dest($dest);
    $router->connect($path => $dest, $opts);
}

sub _build_dest {
    my ($class, $dest) = @_;

    if (ref $dest eq 'CODE') {
        return {
            action => $dest,
        };
    }
    elsif (ref $dest eq 'ARRAY') {
        my @dests;
        for my $d (@$dest) {
            push @dests, $class->_build_dest($d);
        }

        return {
            action => \@dests,
        };
    }
    elsif (!ref $dest) {
        my %dest;
        my ($controller, $action) = split '#', $dest;
        return {controller => $controller, action => $action};
    }

    return $dest;
}

sub dispatch {
    my ($class, $c) = @_;
    my $router = $pkg->_router($class);
    my %env    = %{$c->req->env};
    my ($args, $route) = $router->routematch(\%env);
    my $captures = [$pkg->_build_captures($args, $route)];

    return if !$args;
    # XXX: ＼(^o^)／
    if ($args && $args->{mount}) {
        $router = $pkg->_router($args->{mount});
        $env{PATH_INFO} = $args->{_mount_path};
        $env{PATH_INFO} ||= '/';

        my ($_args, $_route) = $router->routematch(\%env);
        return if !$_args;

        $captures = [@$captures, $pkg->_build_captures($_args, $_route)];
        $args     = {%$args, %$_args};
        $route    = $_route;
    }

    $c->request->env->{'malts.routing_args'} = $args;
    $pkg->_run_action($c, $args, $route, $captures);
}

sub _build_captures {
    my ($class, $args, $route) = @_;
    my @captures;
    my $splat = 0;

    for my $capture (@{$route->{capture}}) {
        my $value = $args->{$capture};
        next if $capture eq '_mount_path';

        if ($capture eq '__splat__') {
            $value = $args->{splat}->[$splat];
            $splat++;
        }
        push @captures, $value;
    }

    return @captures;
}


sub _run_action {
    my ($class, $c, $args, $route, $captures) = @_;

    my $action = $args->{action};

    if (ref $action eq 'CODE') {
        return $action->($c, @$captures);
    }
    elsif (ref $action eq 'ARRAY') {
        my @actions = @$action;
        for my $act (@actions) {
            my $res = $class->_run_action($c, $act);
            return $res if $res;
        }
    }
    else {
        my $controller = $args->{controller};
        my $namespace  = $c->controller_base_name;

        $controller = Plack::Util::load_class($controller, $namespace);
        return $controller->$action($c, @$captures);
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

=head2 C<< mount >>

=head1 METHODS

=head2 C<< $class->dispatch >>

=cut
