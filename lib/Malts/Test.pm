package Malts::Test;
use strict;
use warnings;
use Exporter 'import';
use Plack::Test;
use Carp;

our @EXPORT = qw(apptest);

my $added_hook = {};
my $c;
sub apptest {
    my (%args) = @_;
    my $app      = $args{app}      or croak 'app needed';
    my $client   = $args{client}   or croak 'client test code needed';
    my $app_name = $args{app_name} or croak 'app_name needed';

    if (!$added_hook->{$app_name}) {
        $app_name->add_hooks(before_dispatch => sub {
            my ($context) = @_;
            $c = $context;
        });
        $added_hook->{$app_name}++;
    }

    $args{client} = sub {
        my $callback = shift;
        my $cb = sub {
            my $req = shift;
            my $res = $callback->($req);

            return ($res, $c);
        };

        $client->($cb)
    };

    local $Plack::Test::Impl = $args{impl} if $args{impl};
    test_psgi %args;
}

1;
__END__

=head1 METHODS

=head2 C<< apptest >>

    apptest
        app => MyApp->to_app,
        app_name => 'MyApp',
        client   => sub {
        my ($app) = @_;
        my ($res, $c) = $app->(GET '/');
        ...;
    };

=cut
