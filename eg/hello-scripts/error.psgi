use strict;
use warnings;

package HelloMalts::Exception;
use Exporter 'import';
our @EXPORT = qw/throw/;

sub throw {
    die {@_};
}

package HelloMalts::Web;
use parent qw(Malts Malts::Web);
use Log::Minimal;
HelloMalts::Exception->import('throw');

sub dispatch {
    my $self = shift;
    throw(code => 500, message => 'error message!');
    $self->create_response(200, [], ['Hello Malts!']);
}

sub to_app {
    my ($self) = @_;
    return sub {
        my ($env) = @_;
        my $res = eval { $self->SUPER::to_app->($env) };
        if (my $e = $@) {
            # locationとかもあるけど無視
            my $code = $e->{code} || 500;
            $res = [$code, [], [$e->{message} || 'error']];
        }
        return $res;
    };
}

package main;
use Plack::Builder;
use Malts::Util;

builder {
    enable "Plack::Middleware::Log::Minimal", autodump => 1;

    HelloMalts::Web->to_app;
};

__END__
