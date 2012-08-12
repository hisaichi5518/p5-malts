package Malts::Test;
use strict;
use warnings;
use Exporter 'import';
use Plack::Test;
use Carp;

our @EXPORT = qw(test_app);

my $added_hook = {};
my $count = 0;
my ($c, $path_info, $script_name);

sub test_app {
    my (%args) = @_;
    my $app      = $args{app}      or croak 'app needed';
    my $client   = $args{client}   or croak 'client test code needed';
    my $app_name = $args{app_name} or croak 'app_name needed';
    my $impl     = $args{impl};

    if (!$added_hook->{$app_name}) {
        $app_name->add_hooks(before_dispatch => sub {
            my ($context) = @_;
            $c = $context;
            $path_info   = $c->req->path_info;
            $script_name = $c->req->script_name;
        });
        $added_hook->{$app_name}++;
    }

    $args{client} = sub {
        my $callback = shift;
        my $cb = sub {
            my $req = shift;
            my $res = $callback->($req);

            # for mount
            # mountはresponse_cbで元のenvに書き換えるので
            $c->req->env->{PATH_INFO}   = $path_info;
            $c->req->env->{SCRIPT_NAME} = $script_name;

            return ($res, $c);
        };

        $client->($cb)
    };

    local $Plack::Test::Impl = $impl if $impl;
    test_psgi %args;
}

1;
__END__

=head1 METHODS

=head2 C<< test_app >>

    test_app
        app => MyApp->to_app,
        app_name => 'MyApp',
        client   => sub {
        my ($cb) = @_;
        my ($res, $c) = $cb->(GET '/');
        ...;
    };

=cut
