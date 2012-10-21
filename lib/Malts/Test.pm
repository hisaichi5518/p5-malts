package Malts::Test;
use strict;
use warnings;
use Exporter 'import';
use Plack::Test;
use Carp  qw/croak/;
use Clone qw/clone/;

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
        my $hooks = Malts::App->hooks->{$app_name} ||= {};

        unshift @{$hooks->{before_dispatch} ||= []}, sub {
            my ($context) = @_;
            # dieせずに終わったらcloneする。
            push @{$context->{_hooks}->{after_dispatch} ||= []}, sub {
                my ($context) = @_;
                $_c = clone($context);
            };
        };
        $_added_hook->{$app_name}++;
    }

    $args{client} = sub {
        my $callback = shift;
        my $cb = sub {
            my $req = shift;
            my $res = $callback->($req);

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

NOTE: Can't use I<$c> if die at to_app. See Malts::Test tests.

=cut
