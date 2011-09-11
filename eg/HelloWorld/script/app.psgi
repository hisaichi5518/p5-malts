package HelloWorld;
use strict;
use warnings;
use parent 'Malts';

package HelloWorld::Web::Controller::Root;
use strict;
use warnings;
$INC{'HelloWorld/Web/Controller/Root.pm'} = __FILE__;

sub begin {
    my ($self, $c) = @_;
}
sub end {
    my ($self, $c) = @_;
}

sub index {
    my ($self, $c) = @_;
    $c->ok('ok');
}

package HelloWorld::Web;
use strict;
use warnings;

use parent -norequire, 'HelloWorld';
use parent 'Malts::Web';
use Class::Method::Modifiers::Fast qw(after);

after startup => sub {
    my $self = shift;
    my $r = $self->routes('RSimple');
    $r->connect('/' => {controller => 'Root', action => 'index'});
};

package main;
use strict;
use warnings;

HelloWorld::Web->to_app;
