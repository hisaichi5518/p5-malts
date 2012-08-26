package Malts::Test;
use strict;
use warnings;
use Exporter 'import';
use Plack::Test;
use Carp;

our @EXPORT = qw(test_app);

my $_added_hook = {};
our ($_c, $_path_info, $_script_name);

sub test_app {
    my (%args) = @_;
    my $app      = $args{app}      or croak 'app needed';
    my $client   = $args{client}   or croak 'client test code needed';
    my $app_name = $args{app_name} or croak 'app_name needed';
    my $impl     = $args{impl};
    local ($_c, $_path_info, $_script_name);

    if (!$_added_hook->{$app_name}) {
        # 一番まえに入れる
        my $hooks = Malts::App->hooks->{$app_name} ||= {};
        unshift @{$hooks->{before_dispatch} ||= []}, sub {
            my ($context) = @_;
            $_c           = $context;
            $_path_info   = $_c->req->path_info;
            $_script_name = $_c->req->script_name;
        };
        $_added_hook->{$app_name}++;
    }

    $args{client} = sub {
        my $callback = shift;
        my $cb = sub {
            my $req = shift;
            my $res = $callback->($req);

            # for mount
            # mountはresponse_cbで元のenvに書き換えるので
            $_c->req->env->{PATH_INFO}   = $_path_info   if $_c && $_path_info;
            $_c->req->env->{SCRIPT_NAME} = $_script_name if $_c && $_script_name;

            return ($res, $_c);
        };

        $client->($cb)
    };

    local $Plack::Test::Impl = $impl if $impl;
    test_psgi %args;
}

1;
__END__

=head1 NAME

Malts::Test - functions for malts app test.

=head1 SYNOPSIS

    use Malts::Test;
    use Test::More;
    use HTTP::Request::Common;

    my $app = do {
        package MyApp;
        use parent 'Malts';

        sub dispatch {
            my ($c) = @_;
            my $text = 'hello world!';

            $c->{text} = $text;
            $c->render_string(200, $text);
        }

        __PACKAGE__->to_app;
    };

    test_app
        app_name => 'MyApp',
        app      => $app,
        client   => sub {
            my ($cb) = @_;
            my ($res, $c) = $cb->(GET '/');
            is $c->{text}, 'hello world!';
        };

=head1 FUNCTIONS

=head2 C<< test_app >>

=cut
