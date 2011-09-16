package HelloLog::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);
use Log::Minimal;

sub startup {
    my $self = shift;
    infof('hello logging!');
    $self->ok('Hello Log::Minimal World!');
}

package main;
use strict;
use warnings;

use Plack::Builder;

builder {
    enable "Plack::Middleware::Log::Minimal", autodump => 1;
    HelloLog::Web->to_app;
};
