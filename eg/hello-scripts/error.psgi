use strict;
use warnings;

package ErrorMalts::Web;
use parent qw(Malts Malts::Web);
use Log::Minimal;

sub dispatch {
    my $self = shift;
    croakf {code => 500, message => 'error!'};
}

sub to_app {
    my ($self) = @_;
    return sub {
        my ($env) = @_;
        local $Log::Minimal::DIE = \&_throw;

        my $res = eval { $self->SUPER::to_app->($env) };
        return _catch_error($@) if $@;
        return $res;
    };
}

sub _throw {
    my ($time, $type, $message, $trace, $raw_message) = @_;

    die {
        code => 500,
        time => $time,
        type => $type,
        trace   => $trace,
        (ref $raw_message ne 'HASH'
            ? (message => $raw_message)
            : %$raw_message),
    };
}

sub _catch_error {
    my ($e) = @_;
    if (ref $e ne 'HASH') {
        $e = {
            code => 500,
            message => $e,
        };
    }

    my $c = Malts->context;
    my $code = delete $e->{code} || 500;
    my $action = "res_$code";

    my $res = $c->$action($e);
    return $res->finalize;
}

sub res_500 {
    my ($self, $e) = @_;
    $self->create_response(500, [], [$e->{message}]);
}

package main;
use Plack::Builder;
use Malts::Util;

builder {
    enable "Plack::Middleware::Log::Minimal";

    ErrorMalts::Web->to_app;
};

__END__
