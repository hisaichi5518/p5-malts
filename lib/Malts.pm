package Malts;
use 5.10.1;
use strict;
use warnings;

use Malts::App;
use Malts::Util;
use Malts::Web::Request;
use Malts::Web::Response;
use Scalar::Util ();
use Carp ();

our $VERSION = '0.500';
our $_context;

sub new     { bless {}, shift }
sub context { $_context }
sub app     { Malts::App->current }

sub boostrap {
    my ($class, $env) = @_;
    my $app   = Malts::App->set_running_app($class);
    my $self  = $class->new();
    $_context = $self;
    $self->create_request($env) if $env;

    return ($app, $self);
}

sub to_app {
    my ($class) = @_;

    return sub {
        my $env  = shift;
        my $app  = Malts::App->set_running_app($class);
        my $self = $class->new;
        local $_context = $self;

        $self->create_request($env);

        my $res;
        $self->run_hooks('before_dispatch', \$res);
        $res = $self->dispatch if !$res;
        $self->run_hooks('after_dispatch', \$res);
        return $res->finalize;
    };
}

sub controller_name {
    my ($self) = @_;
    my $name = $self->app->name;
    return "$name\::Controller";
}

sub dispatcher_class {
    my ($self) = @_;
    my $name = $self->app->name;
    return "$name\::Dispatcher";
}

sub request_class  { 'Malts::Web::Request'  }
sub response_class { 'Malts::Web::Response' }

sub dispatch {
    my ($self) = @_;

    $self->dispatcher_class->dispatch($self)
        or $self->render_string(404, 'Page Not Found')
}

sub create_request {
    my $self = shift;
    $self->{request} = $self->request_class->new(@_);
}

sub create_response {
    my $self = shift;
    return $self->response_class->new(@_);
}

sub config {}

# view
sub html_content_type { 'text/html; charset=UTF-8' }

sub encoding {
    my ($self) = @_;
    $self->{encoding} ||= Malts::Util::find_encoding('utf-8');
}

sub create_headers {
    my ($self, $html) = @_;
    return [
        'Content-Type'   => $self->html_content_type,
        'Content-Length' => length($html),
        'X-Content-Type-Options' => 'nosniff',
        'X-Frame-Options'        => 'DENY',
    ];
}

sub render {
    my ($self, $status, $temp_path, $opts) = @_;
    my $decode_html = $self->view->render($temp_path, $opts);
    my $html    = $self->encoding->encode($decode_html);
    my $headers = $self->create_headers($html);

    $self->run_hooks('html_filter', \$html);
    return $self->create_response($status, $headers, [$html]);

}

sub render_string {
    my ($self, $status, $decode_html) = @_;
    my $html    = $self->encoding->encode($decode_html);
    my $headers = $self->create_headers($html);

    $self->run_hooks('html_filter', \$html);
    return $self->create_response($status, $headers, [$html]);
}


# plugin
sub load_plugins {
    my ($class, @plugins) = @_;

    while(@plugins) {
        my $plugin = shift @plugins;
        my $opts   = ref $plugins[0] eq 'HASH' ? shift @plugins : {};

        $class->load_plugin($plugin, $opts);
    }
}

sub load_plugin {
    my ($class, $plugin, $opts) = @_;
    $plugin = Plack::Util::load_class($plugin, 'Malts::Plugin');

    $plugin->init($class, $opts);
}

sub add_hooks {
    my ($class, @args) = @_;

    while (my ($name, $code) = splice @args, 0, 2) {
        $class->add_hook($name => $code);
    }
}

sub add_hook {
    my ($class, $name, $code) = @_;

    if (ref $class) {
        push @{$class->{_hooks}->{$name} ||= []}, $code;
    }
    else {
        push @{Malts::App->hooks->{$class}->{$name} ||= []}, $code;
    }
}

sub run_hooks {
    my ($self, $name, @args) = @_;

    my $codes = $self->get_hook_codes($name);
    for my $code (@$codes) {
        $code->($self, @args);
    }
}

sub get_hook_codes {
    my ($self, $name) = @_;
    my $class = Scalar::Util::blessed $self ? Scalar::Util::blessed $self : $self;

    return [
        (@{Malts::App->hooks->{$class}->{$name} || []}),
        (Scalar::Util::blessed($self) ? @{$self->{_hooks}->{$name} || []} : ()),
    ];
}

sub add_method {
    my ($class, $name, $code) = @_;
    $class = ref $class ? ref $class : $class;

    no strict 'refs';
    *{"$class\::$name"} = $code;
}

sub add_methods {
    my ($class, %args) = @_;
    $class = ref $class ? ref $class : $class;

    no strict 'refs';
    for my $name (keys %args) {
        my $code = $args{$name};
        *{"$class\::$name"} = $code;
    }
}


# shortcut
sub req       { shift->{request} }
sub request   { shift->{request} }
sub args      { shift->req->args }

sub param     { shift->req->param(@_)     }
sub session   { shift->req->session(@_)   }
sub param_raw { shift->req->param_raw(@_) }


# uri
sub uri_for {
    my ($self, $path, $params) = @_;
    my $uri = $self->req->base;
    $path = $uri->path eq '/' ? $path : $uri->path.$path;

    $uri->path($path);
    $uri->query_form(map { $self->encoding->encode($_) } @$params) if $params;

    return $uri;
}

sub uri_with {
    my ($self, $params) = @_;
    my $uri = $self->req->uri;

    $uri->query_form(map { $self->encoding->encode($_) } @$params) if $params;

    return $uri;
}

sub redirect {
    my ($self, $uri, $status) = @_;

    if (ref $uri eq 'ARRAY') {
        $uri = $self->uri_with($uri);
    }
    elsif ($uri =~ m/^\//) {
        $uri = $self->uri_for($uri);
    }

    return $self->create_response(
        $status || 302,
        ['Location' => "$uri"],
        [],
    );
}

1;
__END__

=encoding utf8

=head1 METHODS

=head2 C<< $class->new >>

=head2 C<< $class->context >>

=head2 C<< $class->app >>

=head2 C<< $class->boostrap([$env:ArrayRef]) -> Object >>

=head2 C<< $class->to_app >>

=head2 C<< $self->controller_name -> Str >>

=head2 C<< $self->dispatcher_class -> Str >>

=head2 C<< $self->request_class -> Str >>

=head2 C<< $self->response_class -> Str >>

=head2 C<< $self->dispatch -> Object >>

=head2 C<< $self->create_request -> Object >>

=head2 C<< $self->create_response -> Object >>

=head2 C<< $self->config >>

=head2 C<< $self->html_content_type -> Str >>

=head2 C<< $self->encoding -> Object >>

=head2 C<< $self->create_headers -> ArrayRef >>

=head2 C<< $self->render -> Object >>

=head2 C<< $self->render_string -> Object >>

=head2 C<< $class->load_plugins(@plugins) >>

    $class->load_plugins(
        'Hoge',         # Malts::Plugin::Hoge->init($class);
        '+MyApp::Fuga', # MyApp::Fuga->init($class);
        'Piyo' => {},   # Malts::Plugin::Piyo->init($class, {});
    );

=head2 C<< $class->load_plugin() >>

=head2 C<< $class->add_hooks() >>

=head2 C<< $class->add_hook() >>

=head2 C<< $class->run_hooks() >>

=head2 C<< $class->get_hook_codes() -> ArrayRef >>

=head2 C<< $class->add_method() >>

=head2 C<< $class->add_methods() >>

=head2 C<< $self->req -> Object >>

=head2 C<< $self->request -> Object >>

=head2 C<< $self->args -> HashRef >>

=head2 C<< $self->param() >>

=head2 C<< $self->session() >>

=head2 C<< $self->param_raw() >>

=head2 C<< $self->uri_for() >>

=head2 C<< $self->uri_with() >>

=head2 C<< $self->redirect() >>

=cut
