package Malts;
use 5.10.1;
use strict;
use warnings;

use Malts::App;
use Malts::Util;
use Plack::Util;
use Malts::Web::Request;
use Malts::Web::Response;
use Scalar::Util ();
use Carp ();

our $VERSION = '0.800';
our $_context;

sub new {
    my $class = shift;
    my %args = ref $_[0] ? %{$_[0]} : @_;
    bless \%args, $class;
}

sub context { $_context }
sub app     { Malts::App->current }

sub boostrap {
    my ($class, %args) = @_;
    $_context = $class->setup(%args);
}

sub to_app {
    my ($class) = @_;

    return sub {
        my $env  = shift;
        my $self = $class->setup(env => $env);
        local $_context = $self;

        my $res;
        $self->run_hooks('before_dispatch', \$res);
        $res = $self->dispatch if !$res;
        $self->run_hooks('after_dispatch', \$res);
        return $res->finalize;
    };
}

sub setup {
    my ($class, %args) = @_;
    Malts::App->set_running_app($class);

    if (my $env = $args{env}) {
        $args{request} = $class->create_request($env);
    }

    return $class->new(%args);
}

sub controller_base_name {
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

    Plack::Util::load_class($self->dispatcher_class);
    $self->dispatcher_class->dispatch($self)
        or $self->render_string(404, 'Page Not Found')
}

sub create_request {
    my $self = shift;
    return $self->request_class->new(@_);
}

sub create_response {
    my $self = shift;
    return $self->response_class->new(@_);
}

sub config {}

# view
sub html_content_type { 'text/html; charset=UTF-8' }

sub encoding {
    state $enc = Malts::Util::find_encoding('utf-8');
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

    $self->render_string($status, $decode_html);
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

sub add_methods {
    my ($class, %args) = @_;
    $class = ref $class ? ref $class : $class;

    no strict 'refs';
    for my $name (keys %args) {
        my $code = $args{$name};
        *{"$class\::$name"} = $code;
    }
}

sub add_method {
    my ($class, $name, $code) = @_;
    $class = ref $class ? ref $class : $class;

    no strict 'refs';
    *{"$class\::$name"} = $code;
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

=head1 NAME

Malts - web application framework

=head1 SYNOPSIS

    my $app = do {
        package MyApp::Dispatcher;
        use Malts::Web::Router::Simple;

        get '/' => sub {
            my ($c) = @_;
            my $name = $c->param('name');
            $c->render_string(200, sprintf 'Hello %s!', $name);
        };

        package MyApp;
        use parent 'Malts';

        __PACKAGE__->to_app;
    };

=head1 DESCRIPTION

TODO

=head1 METHODS

=head2 C<< $class->new(%args | \%args) -> Object >>

Creates a new context object of whatever is based on Malts.

=head2 C<< $class->context -> Object >>

Returns the context object.

=head2 C<< $class->app -> Object >>

Returns the app object.

=head2 C<< $class->boostrap(%args) -> Object >>

Create a new context object and set it to global context.

=head2 C<< $class->to_app -> CodeRef >>

Create an instance of PSGI application.

=head2 C<< $class->setup(%args) -> Object >>

Create a new context object.

    $class->setup(env => \%env); # Create request object from env.

=head2 C<< $self->controller_base_name -> Str >>

Returns the controller name.

    my $c = MyApp->boostrap;
    print $c->controller_base_name; #=> print "MyApp::Controller"

=head2 C<< $self->dispatcher_class -> Str >>

Returns the dispatcher class.

    my $c = MyApp->boostrap;
    print $c->dispatcher_class; #=> print "MyApp::Dispatcher"

=head2 C<< $self->request_class -> Str >>

Returns the request class. defaults to a I<Malts::Web::Request>.

=head2 C<< $self->response_class -> Str >>

Returns the response class. defaults to a I<Malts::Web::Response>.

=head2 C<< $self->dispatch -> Object >>

=head2 C<< $self->create_request(\%env) -> Object >>

Create a new request object.

=head2 C<< $self->create_response($status, \@headers, $body) -> Object >>

Create a new response object.

=head2 C<< $self->config >>

Exists but does nothing.

This is so you won't have to write a config if you don't want to.

=head2 C<< $self->html_content_type -> Str >>

Returns the contet type. defaults to a "text/html; charset=UTF-8".

=head2 C<< $self->encoding -> Object >>

Create/Get a encoding object using Encode::find_encoding('utf-8').

=head2 C<< $self->create_headers -> ArrayRef >>

Create headers.

    Content-Type   : $self->html_content_type()
    Content-Length : Num
    X-Content-Type-Options : 'nosniff'
    X-Frame-Options        : 'DENY'

=head2 C<< $self->render($status, $template_path) -> Object >>

Create a response object.

=head2 C<< $self->render_string($status, $body) -> Object >>

Create a response object.

=head2 C<< $class->load_plugins(@plugins) >>

Load plugins.

    $class->load_plugins(
        'Hoge',         # Malts::Plugin::Hoge->init($class);
        '+MyApp::Fuga', # MyApp::Fuga->init($class);
        'Piyo' => {},   # Malts::Plugin::Piyo->init($class, {});
    );

=head2 C<< $class->load_plugin($plugin => $config) >>

Load a plugin.

=head2 C<< $class->add_hooks($hook_name => \&hook_code) >>

Add hooks.

=head2 C<< $class->add_hook($hook_name => \&hook_code) >>

Add a hook.

=head2 C<< $class->run_hooks($hook_name) >>

Run hooks.

=head2 C<< $class->get_hook_codes($hook_name) -> ArrayRef >>

Returns hook codes.

=head2 C<< $class->add_methods($method_name => \&method_code) >>

Add methods.

=head2 C<< $class->add_method($method_name => \&method_code) >>

Add a method.

=head2 C<< $self->req -> Object >>

Returns a request object.

=head2 C<< $self->request -> Object >>

Returns a request object.

=head2 C<< $self->args -> HashRef >>

Shortcut to $self->req->args().

=head2 C<< $self->param($param_name) -> Str >>

Shortcut to $self->req->param().

=head2 C<< $self->session -> Str >>

Shortcut to $self->req->session().

=head2 C<< $self->param_raw($param_name) -> Str >>

Shortcut to $self->req->param_raw().

=head2 C<< $self->uri_for($path, \@params) -> Object >>

Create an C<URI> object.

=head2 C<< $self->uri_with(\@params) -> Object >>

Create an C<URI> object.

=head2 C<< $self->redirect($uri, $status) -> Object >>

Create a response object.

=cut
