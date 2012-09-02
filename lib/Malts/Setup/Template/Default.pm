package Malts::Setup::Template::Default;

use strict;
use warnings;

sub distribution {
    return <<'__DIST__';
@@ app.psgi
use strict;
use warnings;

package MyApp::Dispatcher;
use Malts::Web::Router::Simple;

get '/' => sub {
    $_[0]->create_response(200, [], 'ok');
};

package MyApp;
use parent qw(Malts);

__PACKAGE__->to_app;
__DIST__
}

1;
__END__

=head1 METHODS

=head2 C<< $class->distribution >>

=cut
